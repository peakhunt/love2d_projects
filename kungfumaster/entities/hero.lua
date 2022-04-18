--
-- kungfu master entity
--
local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')
local entity_common = require('entities/entity_common')
local common_conf = require('entities/common_conf')
local state = require('state')

local spriteSheet = asset_conf.spriteSheet
local assetHero = asset_conf.hero
local sprites = assetHero.sprites

--------------------------------------------------------------------------------
-- some reasoning and explanation so that I can pick up later when I forget.
--
-- vitual world width is defined to be between 0 and 7
-- vitual world height is defined to be between 0 and 1
--  /\
--  | 1
--  |
--  |
--  |                          7
--  ____________________________>
--
-- And viewport is defined to be (0~1,0~1),
-- which means 1/7 of the virtual world is projected into the pixel screen
-- whatever the pixel screen resolution is.
--
-- For the world, aka, background, this is quite simple and straightforward.
-- 
-- For the entitires appearing in the world, if sprite sizes are always same,
-- things are quite simple and easy. But that's usually not the case.
--
-- So for the entities with varying sprite size, we take the following step
--
-- 1. A size in virtual world is defined for a reference sprite (usually standing or idle)
-- 2. A size in virtual world for other sprites are calculated at load time
--    with the reference sprite and its size in virtual world.
--
-- So why even go through all these hassels instead of simply using pixel dimension?
-- It's because it seems easier to me to manipulate everything in virtual world unit 
-- as of this writing.
--
--------------------------------------------------------------------------------

function calcJumpDistance(anim, currentAnimTime)
  -- simple parabolic
  --
  -- y = -a(x - t/2)^2 + h
  -- a = 4h/t^2
  --
  local t = anim.duration
  local h = common_conf.jump_distance
  local a = 4 * h / (t * t)
  local x = (currentAnimTime - t / 2)
  local y = -a * x * x + h
  return y
end

--------------------------------------------------------------------------------
-- 
-- hero sprite animations
--
--------------------------------------------------------------------------------
local animations = {
  standing = utils.newAnimationFromConf(spriteSheet, sprites.standing, assetHero.refFrame),
  walking = utils.newAnimationFromConf(spriteSheet, sprites.walking, assetHero.refFrame),
  sitting = utils.newAnimationFromConf(spriteSheet, sprites.sitting, assetHero.refFrame),
  standJumping = utils.newAnimationFromConf(spriteSheet, sprites.standJumping, assetHero.refFrame),
  walkJumping = utils.newAnimationFromConf(spriteSheet, sprites.walkJumping, assetHero.refFrame),
  standPunch = utils.newAnimationFromConf(spriteSheet, sprites.standPunching, assetHero.refFrame),
  standKick = utils.newAnimationFromConf(spriteSheet, sprites.standKicking, assetHero.refFrame),
  sitPunch = utils.newAnimationFromConf(spriteSheet, sprites.sitPunching, assetHero.refFrame),
  sitKick = utils.newAnimationFromConf(spriteSheet, sprites.sitKicking, assetHero.refFrame),
  standJumpKick = utils.newAnimationFromConf(spriteSheet, sprites.standJumpKicking, assetHero.refFrame),
  standJumpPunch = utils.newAnimationFromConf(spriteSheet, sprites.standJumpPunching, assetHero.refFrame),
  walkJumpKick = utils.newAnimationFromConf(spriteSheet, sprites.walkJumpKicking, assetHero.refFrame),
  walkJumpPunch = utils.newAnimationFromConf(spriteSheet, sprites.walkJumpPunching, assetHero.refFrame),
}

--------------------------------------------------------------------------------
-- 
-- hero state machine
--
--------------------------------------------------------------------------------
local states = {}

--
-- state standing
--
states.standing = {
  animation = animations.standing,
  update = function(self, entity, dt)
    if state.button_kick then
      entity:moveState(states.standKicking)
      return
    elseif state.button_punch then
      entity:moveState(states.standPunching)
      return
    end

    if state.button_left then
      entity:moveState(states.walking)
    elseif state.button_right then
      entity:moveState(states.walking)
    elseif state.button_down then
      entity:moveState(states.sitting)
    elseif state.button_up then
      entity:moveState(states.standJumping)
    end

    entity:commonUpdate(dt)
  end,
}

--
-- state walking
--
states.walking = {
  animation = animations.walking,
  update = function(self, entity, dt)
    if state.button_kick then
      entity:moveState(states.standKicking)
      return
    elseif state.button_punch then
      entity:moveState(states.standPunching)
      return
    end

    local prevForward = entity.forward

    if state.button_left then
      entity.forward = true
      if prevForward ~= entity.forward then
        entity:moveState(states.standing)
        return
      end
    elseif state.button_right then
      entity.forward = false
      if prevForward ~= entity.forward then
        entity:moveState(states.standing)
        return
      end
    else
      entity:moveState(states.standing)
      return
    end
    
    if state.button_down then
      entity:moveState(states.sitting)
      return
    end

    local x,y = entity:getPos()

    if entity.forward then
      x = x - common_conf.move_speed * dt
    else
      x = x + common_conf.move_speed * dt
    end 
    entity:setPos(x, y)

    if state.button_up then
      entity:moveState(states.walkJumping)
      return
    end

    entity:commonUpdate(dt)
  end,
}

--
-- state sitting
--
states.sitting = {
  animation = animations.sitting,
  update = function(self, entity, dt)
    -- kick and punch
    if state.button_kick then
      entity:moveState(states.sitKicking)
      return
    elseif state.button_punch then
      entity:moveState(states.sitPunching)
      return
    end

    -- movement
    if state.button_left then
      entity.forward = true
    elseif state.button_right then
      entity.forward = false
    elseif state.button_down then
    elseif state.button_up then
      entity:moveState(states.standing)
    else
      entity:moveState(states.standing)
    end

    entity:commonUpdate(dt)
  end,
}

--
-- state jumping
--
states.standJumping = {
  update = function(self, entity, dt)
    if state.button_kick and entity.currentAnimTime < (entity.currentAnim.duration  * 3 / 5) then
      entity:moveState(states.standJumpKicking)
      return
    end

    if state.button_punch and entity.currentAnimTime < (entity.currentAnim.duration  * 3 / 5) then
      entity:moveState(states.standJumpPunching)
      return
    end

    if entity:commonUpdate(dt) == true then
      -- animation over
      entity:moveState(states.standing)
      entity:setPos(entity.savedPos.x, entity.savedPos.y)
    else
      local x,_ = entity:getPos()
      local y = entity.savedPos.y + calcJumpDistance(animations.standJumping, entity.currentAnimTime)
      entity:setPos(x, y)
    end
  end,
  enter = function(self, entity, oldState)
    entity.currentAnimTime = 0

    local x,y = entity:getPos()

    entity.savedPos.x = x
    entity.savedPos.y = y

    entity.currentAnim = animations.standJumping
  end,
}

--
-- state jumping while walking
--
states.walkJumping = {
  update = function(self, entity, dt)
    if state.button_kick and entity.currentAnimTime < (entity.currentAnim.duration  * 3 / 5) then
      entity:moveState(states.walkJumpKicking)
      return
    end

    if state.button_punch and entity.currentAnimTime < (entity.currentAnim.duration  * 3 / 5) then
      entity:moveState(states.walkJumpPunching)
      return
    end

    if entity:commonUpdate(dt) == true then
      -- animation over
      entity:moveState(states.walking)

      local x, _ = entity:getPos()

      entity:setPos(x, entity.savedPos.y)
    else
      local x,_ = entity:getPos()
      local y = entity.savedPos.y + calcJumpDistance(animations.walkJumping, entity.currentAnimTime)

      if entity.forward then
        x = x - common_conf.move_speed * dt
      else
        x = x + common_conf.move_speed * dt
      end 
      entity:setPos(x, y)
    end
  end,
  enter = function(self, entity, oldState)
    entity.currentAnimTime = 0

    local _,y = entity:getPos()

    entity.savedPos.y = y
    entity.currentAnim = animations.walkJumping
  end,
}

--
-- state punhcing
--
states.standPunching = {
  animation = animations.standPunch,
  update = function(self, entity, dt)
    entity:updateOneshot(dt, states.standing)
  end,
}

--
-- state kicking
--
states.standKicking = {
  animation = animations.standKick,
  update = function(self, entity, dt)
    entity:updateOneshot(dt, states.standing)
  end,
}

--
-- state punching while sitting down
--
states.sitPunching = {
  animation = animations.sitPunch,
  update = function(self, entity, dt)
    entity:updateOneshot(dt, states.sitting)
  end,
}

--
-- state kicking while sitting down
--
states.sitKicking = {
  animation = animations.sitKick,
  update = function(self, entity, dt)
    entity:updateOneshot(dt, states.sitting)
  end,
}

--
-- state kicking while stand jumping
--
states.standJumpKicking = {
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      -- animation over
      entity:moveState(states.standing)
      entity:setPos(entity.savedPos.x, entity.savedPos.y)
    else
      local x,_ = entity:getPos()
      local y = entity.savedPos.y + calcJumpDistance(animations.standJumpKick, entity.currentAnimTime)
      entity:setPos(x, y)
    end
  end,
  enter = function(self, entity, oldState)
    entity.currentAnim = animations.standJumpKick
  end,
}

--
-- state punching while stand jumping
--
states.standJumpPunching = {
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      -- animation over
      entity:moveState(states.standing)
      entity:setPos(entity.savedPos.x, entity.savedPos.y)
    else
      local x,_ = entity:getPos()
      local y = entity.savedPos.y + calcJumpDistance(animations.standJumpPunch, entity.currentAnimTime)
      entity:setPos(x, y)
    end
  end,
  enter = function(self, entity, oldState)
    entity.currentAnim = animations.standJumpPunch
  end,
}

--
-- state kicking while walk jumping
--
states.walkJumpKicking = {
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      -- animation over
      entity:moveState(states.walking)

      local x, _ = entity:getPos()

      entity:setPos(x, entity.savedPos.y)
    else
      local x,_ = entity:getPos()
      local y = entity.savedPos.y + calcJumpDistance(animations.walkJumpKick, entity.currentAnimTime)

      if entity.forward then
        x = x - common_conf.move_speed * dt
      else
        x = x + common_conf.move_speed * dt
      end 
      entity:setPos(x, y)
    end
  end,
  enter = function(self, entity, oldState)
    entity.currentAnim = animations.walkJumpKick
  end,
}

--
-- state punching while walk jumping
--
states.walkJumpPunching = {
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      -- animation over
      entity:moveState(states.walking)

      local x, _ = entity:getPos()
      entity:setPos(x, entity.savedPos.y)
    else
      local x,_ = entity:getPos()
      local y = entity.savedPos.y + calcJumpDistance(animations.walkJumpPunch, entity.currentAnimTime)

      if entity.forward then
        x = x - common_conf.move_speed * dt
      else
        x = x + common_conf.move_speed * dt
      end 
      entity:setPos(x, y)
    end
  end,
  enter = function(self, entity, oldState)
    entity.currentAnim = animations.walkJumpPunch
  end,
}

return function(pos_x, pos_y)
  local entity =  entity_common(pos_x, pos_y, states, animations, states.standing)
  local baseSetPos = entity.setPos

  entity.name = "helo"

  entity.setPos = function(self, x, y)
    baseSetPos(entity, x, y)

    if state.current_level then
      state.current_level:heroMove(x, y)
    end
  end

  return entity
end
