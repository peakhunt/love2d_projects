--
-- kungfu master entity
--
local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')
local entity_common = require('entities/entity_common')
local common_conf = require('entities/common_conf')

local spriteSheet = asset_conf.spriteSheet
local sprites = asset_conf.hero.sprites

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
  standing = utils.newAnimationFromConf(spriteSheet, sprites.standing),
  walking = utils.newAnimationFromConf(spriteSheet, sprites.walking),
  sitting = utils.newAnimationFromConf(spriteSheet, sprites.sitting),
  standJumping = utils.newAnimationFromConf(spriteSheet, sprites.standJumping),
  walkJumping = utils.newAnimationFromConf(spriteSheet, sprites.walkJumping),
  standPunch = utils.newAnimationFromConf(spriteSheet, sprites.standPunching),
  standKick = utils.newAnimationFromConf(spriteSheet, sprites.standKicking),
  sitPunch = utils.newAnimationFromConf(spriteSheet, sprites.sitPunching),
  sitKick = utils.newAnimationFromConf(spriteSheet, sprites.sitKicking),
  standJumpKick = utils.newAnimationFromConf(spriteSheet, sprites.standJumpKicking),
  standJumpPunch = utils.newAnimationFromConf(spriteSheet, sprites.standJumpPunching),
  walkJumpKick = utils.newAnimationFromConf(spriteSheet, sprites.walkJumpKicking),
  walkJumpPunch = utils.newAnimationFromConf(spriteSheet, sprites.walkJumpPunching),
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
      entity.pos.scale_x = -1 * common_conf.scale_factor
    else
      x = x + common_conf.move_speed * dt
      entity.pos.scale_x = common_conf.scale_factor
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
      entity.pos.scale_x = -1 * common_conf.scale_factor
    elseif state.button_right then
      entity.forward = false
      entity.pos.scale_x = common_conf.scale_factor
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
      local y = entity.savedPos.y - calcJumpDistance(animations.standJumping, entity.currentAnimTime)
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
      local y = entity.savedPos.y - calcJumpDistance(animations.walkJumping, entity.currentAnimTime)

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
      local y = entity.savedPos.y - calcJumpDistance(animations.standJumpKick, entity.currentAnimTime)
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
      local y = entity.savedPos.y - calcJumpDistance(animations.standJumpPunch, entity.currentAnimTime)
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
      local y = entity.savedPos.y - calcJumpDistance(animations.walkJumpKick, entity.currentAnimTime)

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
      local y = entity.savedPos.y - calcJumpDistance(animations.walkJumpPunch, entity.currentAnimTime)

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
  entity.onMoveListener = nil

  entity.setPos = function(self, x, y)
    baseSetPos(entity, x, y)
    if self.onMoveListener then
      self.onMoveListener:onMove(x, y)
    end
  end

  return entity
end
