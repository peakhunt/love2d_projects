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

function commonUpdate(entity, dt)
  entity.currentAnim.currentTime = entity.currentAnim.currentTime + dt
  if entity.currentAnim.currentTime >= entity.currentAnim.duration then
    entity.currentAnim.currentTime = entity.currentAnim.currentTime - entity.currentAnim.duration
    return true
  end
  return false
end

function calcJumpDistance(anim)
  -- simple parabolic
  --
  -- y = -a(x - t/2)^2 + h
  -- a = 4h/t^2
  --
  local t = anim.duration
  local h = jump_distance
  local a = 4 * h / (t * t)
  local x = (anim.currentTime - t / 2)
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

states.standing = {
  update = function(self, entity, dt)
    if state.button_kick then
      entity:moveState(states.standKicking)
      return
    elseif state.button_punch then
      entity:moveState(states.standPunching)
      return
    end

    -- movement
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

    commonUpdate(entity, dt)
  end,
  enter = function(self, entity)
    animations.standing.currentTime = 0
    entity.currentAnim = animations.standing
  end,
  leave = function(self, entity)
  end,
}

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

    commonUpdate(entity, dt)
  end,
  enter = function(self, entity)
    animations.walking.currentTime = 0
    entity.currentAnim = animations.walking
  end,
  leave = function(self, entity)
  end,
}

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

    commonUpdate(entity, dt)
  end,
  enter = function(self, entity)
    animations.sitting.currentTime = 0
    entity.currentAnim = animations.sitting
  end,
  leave = function(self, entity)
  end,
}

states.standJumping = {
  savedPos = {
    x = 0,
    y = 0,
  },
  update = function(self, entity, dt)
    if state.button_kick and entity.currentAnim.currentTime < (entity.currentAnim.duration  * 3 / 5) then
      entity:moveState(states.standJumpKicking)
      return
    end

    if state.button_punch and entity.currentAnim.currentTime < (entity.currentAnim.duration  * 3 / 5) then
      entity:moveState(states.standJumpPunching)
      return
    end

    if commonUpdate(entity, dt) == true then
      -- animation over
      entity:moveState(states.standing)
      entity:setPos(self.savedPos.x, self.savedPos.y)
    else
      local x,_ = entity:getPos()
      local y = self.savedPos.y - calcJumpDistance(animations.standJumping)
      entity:setPos(x, y)
    end
  end,
  enter = function(self, entity)
    animations.standJumping.currentTime = 0

    local x,y = entity:getPos()

    self.savedPos.x = x
    self.savedPos.y = y

    entity.currentAnim = animations.standJumping
  end,
  leave = function(self, entity)
  end,
}

states.walkJumping = {
  savedPosY = 0,
  update = function(self, entity, dt)
    if state.button_kick and entity.currentAnim.currentTime < (entity.currentAnim.duration  * 3 / 5) then
      entity:moveState(states.walkJumpKicking)
      return
    end

    if state.button_punch and entity.currentAnim.currentTime < (entity.currentAnim.duration  * 3 / 5) then
      entity:moveState(states.walkJumpPunching)
      return
    end

    if commonUpdate(entity, dt) == true then
      -- animation over
      entity:moveState(states.walking)

      local x, _ = entity:getPos()

      entity:setPos(x, self.savedPosY)
    else
      local x,_ = entity:getPos()
      local y = self.savedPosY - calcJumpDistance(animations.walkJumping)

      if entity.forward then
        x = x - move_speed * dt
      else
        x = x + move_speed * dt
      end 
      entity:setPos(x, y)
    end
  end,
  enter = function(self, entity)
    animations.walkJumping.currentTime = 0

    local _,y = entity:getPos()

    self.savedPosY = y
    entity.currentAnim = animations.walkJumping
  end,
  leave = function(self, entity)
  end,
}

states.standPunching = {
  update = function(self, entity, dt)
    if commonUpdate(entity, dt) == true then
      -- animation over
      entity:moveState(states.standing)
    end
  end,
  enter = function(self, entity)
    animations.standPunch.currentTime = 0
    entity.currentAnim = animations.standPunch
  end,
  leave = function(self, entity)
  end,
}

states.standKicking = {
  update = function(self, entity, dt)
    if commonUpdate(entity, dt) == true then
      -- animation over
      entity:moveState(states.standing)
    end
  end,
  enter = function(self, entity)
    animations.standKick.currentTime = 0
    entity.currentAnim = animations.standKick
  end,
  leave = function(self, entity)
  end,
}

states.sitPunching = {
  update = function(self, entity, dt)
    if commonUpdate(entity, dt) == true then
      -- animation over
      entity:moveState(states.sitting)
    end
  end,
  enter = function(self, entity)
    animations.sitPunch.currentTime = 0
    entity.currentAnim = animations.sitPunch
  end,
  leave = function(self, entity)
  end,
}

states.sitKicking = {
  update = function(self, entity, dt)
    if commonUpdate(entity, dt) == true then
      -- animation over
      entity:moveState(states.sitting)
    end
  end,
  enter = function(self, entity)
    animations.sitKick.currentTime = 0
    entity.currentAnim = animations.sitKick
  end,
  leave = function(self, entity)
  end,
}

states.standJumpKicking = {
  savedPos = {
    x = 0,
    y = 0,
  },
  update = function(self, entity, dt)
    if commonUpdate(entity, dt) == true then
      -- animation over
      entity:moveState(states.standing)
      entity:setPos(self.savedPos.x, self.savedPos.y)
    else
      local x,_ = entity:getPos()
      local y = self.savedPos.y - calcJumpDistance(animations.standJumpKick)
      entity:setPos(x, y)
    end
  end,
  enter = function(self, entity)
    animations.standJumpKick.currentTime = animations.standJumping.currentTime

    self.savedPos.x = states.standJumping.savedPos.x
    self.savedPos.y = states.standJumping.savedPos.y

    entity.currentAnim = animations.standJumpKick
  end,
  leave = function(self, entity)
  end,
}

states.standJumpPunching = {
  savedPos = {
    x = 0,
    y = 0,
  },
  update = function(self, entity, dt)
    if commonUpdate(entity, dt) == true then
      -- animation over
      entity:moveState(states.standing)
      entity:setPos(self.savedPos.x, self.savedPos.y)
    else
      local x,_ = entity:getPos()
      local y = self.savedPos.y - calcJumpDistance(animations.standJumpPunch)
      entity:setPos(x, y)
    end
  end,
  enter = function(self, entity)
    animations.standJumpPunch.currentTime = animations.standJumping.currentTime

    self.savedPos.x = states.standJumping.savedPos.x
    self.savedPos.y = states.standJumping.savedPos.y

    entity.currentAnim = animations.standJumpPunch
  end,
  leave = function(self, entity)
  end,
}

states.walkJumpKicking = {
  savedPosY = 0,
  update = function(self, entity, dt)
    if commonUpdate(entity, dt) == true then
      -- animation over
      entity:moveState(states.walking)

      local x, _ = entity:getPos()

      entity:setPos(x, self.savedPosY)
    else
      local x,_ = entity:getPos()
      local y = self.savedPosY - calcJumpDistance(animations.walkJumpKick)

      if entity.forward then
        x = x - move_speed * dt
      else
        x = x + move_speed * dt
      end 
      entity:setPos(x, y)
    end
  end,
  enter = function(self, entity)
    animations.walkJumpKick.currentTime = animations.walkJumping.currentTime

    self.savedPosY = states.walkJumping.savedPosY

    entity.currentAnim = animations.walkJumpKick
  end,
  leave = function(self, entity)
  end,
}

states.walkJumpPunching = {
  savedPosY = 0,
  update = function(self, entity, dt)
    if commonUpdate(entity, dt) == true then
      -- animation over
      entity:moveState(states.walking)

      local x, _ = entity:getPos()
      entity:setPos(x, self.savedPosY)
    else
      local x,_ = entity:getPos()
      local y = self.savedPosY - calcJumpDistance(animations.walkJumpPunch)

      if entity.forward then
        x = x - move_speed * dt
      else
        x = x + move_speed * dt
      end 
      entity:setPos(x, y)
    end
  end,
  enter = function(self, entity)
    animations.walkJumpPunch.currentTime = animations.walkJumping.currentTime

    self.savedPosY = states.walkJumping.savedPosY

    entity.currentAnim = animations.walkJumpPunch
  end,
  leave = function(self, entity)
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
    animations = animations,
    states = states,
    forward = true,
    currentState = nil,
    currentAnim = nil,

    setPos = function(self, x, y)
      self.pos.x = x
      self.pos.y = y
    end,

    getPos = function(self)
      return self.pos.x, self.pos.y
    end,

    moveState = function(self, newstate)
      if self.currentState ~= nil then
        self.currentState:leave(self)
      end

      self.currentState = newstate
      self.currentState:enter(self)
    end,

    draw = function(self)
      local x,y = self:getPos()
      utils.drawAnimation(self.currentAnim, x, y, 0, self.pos.scale_x, self.pos.scale_y)
    end,

    update = function(self, dt)
      self.currentState:update(self, dt)
    end
  }

  entity:moveState(states.standing)

  return entity
end
