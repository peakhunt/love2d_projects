--
-- kungfu master entity
--
local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')

local scale_factor = 3
local jump_distance = 70
local move_speed = 200
local spriteSheet = asset_conf.spriteSheet
local sprites = asset_conf.hero.sprites

function calcJumpDistance(anim, currentAnimTime)
  -- simple parabolic
  --
  -- y = -a(x - t/2)^2 + h
  -- a = 4h/t^2
  --
  local t = anim.duration
  local h = jump_distance
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
  update = function(self, entity, dt)
    if state.button_kick then
      entity:moveState(states.standKicking)
      return
    elseif state.button_punch then
      entity:moveState(states.standPunching)
      return
    end

    if state.button_left then
      entity.forward = true
      entity.pos.scale_x = -1 * scale_factor
      entity:moveState(states.walking)
    elseif state.button_right then
      entity.forward = false
      entity.pos.scale_x = scale_factor
      entity:moveState(states.walking)
    elseif state.button_down then
      entity:moveState(states.sitting)
    elseif state.button_up then
      entity:moveState(states.standJumping)
    end

    entity:commonUpdate(dt)
  end,
  enter = function(self, entity, oldState)
    entity.currentAnimTime = 0
    entity.currentAnim = animations.standing
  end,
}

--
-- state walking
--
states.walking = {
  update = function(self, entity, dt)
    if state.button_kick then
      entity:moveState(states.standKicking)
      return
    elseif state.button_punch then
      entity:moveState(states.standPunching)
      return
    end

    local x,y = entity:getPos()
    local prevForward = entity.forward

    -- movement
    if state.button_left then
      entity.forward = true
    elseif state.button_right then
      entity.forward = false
    else
      entity:moveState(states.standing)
    end
    
    if state.button_down then
      entity:moveState(states.sitting)
      return
    end

    if state.button_up and prevForward == entity.forward then
      entity:moveState(states.walkJumping)
      return
    end

    if entity.forward and prevForward == entity.forward then
      x = x - move_speed * dt
      entity.pos.scale_x = -1 * scale_factor
    elseif prevForward == entity.forward then
      x = x + move_speed * dt
      entity.pos.scale_x = scale_factor
    end 
    entity:setPos(x, y)

    entity:commonUpdate(dt)
  end,
  enter = function(self, entity, oldState)
    entity.currentAnimTime = 0
    entity.currentAnim = animations.walking
  end,
}

--
-- state sitting
--
states.sitting = {
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
      entity.pos.scale_x = -1 * scale_factor
    elseif state.button_right then
      entity.forward = false
      entity.pos.scale_x = scale_factor
    elseif state.button_down then
    elseif state.button_up then
      entity:moveState(states.standing)
    else
      entity:moveState(states.standing)
    end

    entity:commonUpdate(dt)
  end,
  enter = function(self, entity, oldState)
    entity.currentAnimTime = 0
    entity.currentAnim = animations.sitting
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
        x = x - move_speed * dt
      else
        x = x + move_speed * dt
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
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      -- animation over
      entity:moveState(states.standing)
    end
  end,
  enter = function(self, entity, oldState)
    entity.currentAnimTime = 0
    entity.currentAnim = animations.standPunch
  end,
}

--
-- state kicking
--
states.standKicking = {
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      -- animation over
      entity:moveState(states.standing)
    end
  end,
  enter = function(self, entity, oldState)
    entity.currentAnimTime = 0
    entity.currentAnim = animations.standKick
  end,
}

--
-- state punching while sitting down
--
states.sitPunching = {
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      -- animation over
      entity:moveState(states.sitting)
    end
  end,
  enter = function(self, entity, oldState)
    entity.currentAnimTime = 0
    entity.currentAnim = animations.sitPunch
  end,
}

--
-- state kicking while sitting down
--
states.sitKicking = {
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      -- animation over
      entity:moveState(states.sitting)
    end
  end,
  enter = function(self, entity, oldState)
    entity.currentAnimTime = 0
    entity.currentAnim = animations.sitKick
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
        x = x - move_speed * dt
      else
        x = x + move_speed * dt
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
        x = x - move_speed * dt
      else
        x = x + move_speed * dt
      end 
      entity:setPos(x, y)
    end
  end,
  enter = function(self, entity, oldState)
    entity.currentAnim = animations.walkJumpPunch
  end,
}

return function(pos_x, pos_y)
  local entity = {
    pos = {
      x = pos_x,
      y = pos_y,
      scale_x = -scale_factor,
      scale_y = scale_factor,
    },
    savedPos = {
      x = 0,
      y = 0,
    },
    animations = animations,
    states = states,
    forward = true,
    currentState = nil,
    currentAnim = nil,
    currentAnimTime = 0,
    setPos = function(self, x, y)
      self.pos.x = x
      self.pos.y = y
    end,

    getPos = function(self)
      return self.pos.x, self.pos.y
    end,

    moveState = function(self, newstate)
      local oldState = self.currentState

      if oldState ~= nil and oldState.leave then
        oldState:leave(self)
      end

      self.currentState = newstate

      if newstate.enter then
        self.currentState:enter(self, oldState)
      end 
    end,

    draw = function(self)
      local x,y = self:getPos()
      utils.drawAnimation(self.currentAnim, self.currentAnimTime, x, y, 0, self.pos.scale_x, self.pos.scale_y)
    end,

    update = function(self, dt)
      self.currentState:update(self, dt)
    end,

    commonUpdate = function(self, dt)
      self.currentAnimTime = self.currentAnimTime + dt
      if self.currentAnimTime >= self.currentAnim.duration then
        self.currentAnimTime = self.currentAnimTime - self.currentAnim.duration
        return true
      end
      return false
    end,
  }

  entity:moveState(states.standing)

  return entity
end
