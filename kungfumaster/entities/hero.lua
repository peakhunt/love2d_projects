--
-- kungfu master entity
--
local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')

local scale_factor = 3
local jump_distance = 70
local move_speed = 200

function moveState(entity, newState)
  entity.currentState:leave()
  entity.currentState = newState
  entity.currentState:enter()
end

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

return function(pos_x, pos_y)
  local entity = {}

  entity.pos = {
    x = pos_x,
    y = pos_y,
    scale_x = -scale_factor,
    scale_y = scale_factor,
  }

  entity.setPos = function(self, x, y)
    self.pos.x = x
    self.pos.y = y
  end

  entity.getPos = function(self)
    return self.pos.x, self.pos.y
  end

  entity.standingAnim = utils.newAnimationFromConf(asset_conf.spriteSheet, asset_conf.hero.sprites.standing)
  entity.walkingAnim = utils.newAnimationFromConf(asset_conf.spriteSheet, asset_conf.hero.sprites.walking)
  entity.sittingAnim = utils.newAnimationFromConf(asset_conf.spriteSheet, asset_conf.hero.sprites.sitting)
  entity.standJumpingAnim = utils.newAnimationFromConf(asset_conf.spriteSheet, asset_conf.hero.sprites.standJumping)
  entity.walkJumpingAnim = utils.newAnimationFromConf(asset_conf.spriteSheet, asset_conf.hero.sprites.walkJumping)
  entity.standPunchAnim = utils.newAnimationFromConf(asset_conf.spriteSheet, asset_conf.hero.sprites.standPunching)
  entity.standKickAnim = utils.newAnimationFromConf(asset_conf.spriteSheet, asset_conf.hero.sprites.standKicking)
  entity.sitPunchAnim = utils.newAnimationFromConf(asset_conf.spriteSheet, asset_conf.hero.sprites.sitPunching)
  entity.sitKickAnim = utils.newAnimationFromConf(asset_conf.spriteSheet, asset_conf.hero.sprites.sitKicking)

  entity.currentAnim = entity.standingAnim
  entity.forward = true

  entity.stateStanding = {
    update = function(self, dt)
      if state.button_kick then
        moveState(entity, entity.stateStandKicking)
        return
      elseif state.button_punch then
        moveState(entity, entity.stateStandPunching)
        return
      end

      -- movement
      if state.button_left then
        entity.forward = true
        entity.pos.scale_x = -1 * scale_factor
        moveState(entity, entity.stateWalking)
      elseif state.button_right then
        entity.forward = false
        entity.pos.scale_x = scale_factor
        moveState(entity, entity.stateWalking)
      elseif state.button_down then
        moveState(entity, entity.stateSitting)
      elseif state.button_up then
        moveState(entity, entity.stateStandJumping)
      end

      commonUpdate(entity, dt)
    end,
    enter = function(self)
      entity.standingAnim.currentTime = 0
      entity.currentAnim = entity.standingAnim
    end,
    leave = function(self)
    end,
  }

  entity.stateWalking = {
    update = function(self, dt)
      if state.button_kick then
        moveState(entity, entity.stateStandKicking)
        return
      elseif state.button_punch then
        moveState(entity, entity.stateStandPunching)
        return
      end

      local x,y = self:getPos()
      local prevForward = entity.forward

      -- movement
      if state.button_left then
        entity.forward = true
      elseif state.button_right then
        entity.forward = false
      else
        moveState(entity, entity.stateStanding)
      end
      
      if state.button_down then
        moveState(entity, entity.stateSitting)
        return
      end

      if state.button_up and prevForward == entity.forward then
        moveState(entity, entity.stateWalkJumping)
        return
      end

      if entity.forward then
        x = x - move_speed * dt
        entity.pos.scale_x = -1 * scale_factor
      else
        x = x + move_speed * dt
        entity.pos.scale_x = scale_factor
      end 
      entity:setPos(x, y)

      -- kick and punch
      if state.button_kick then
      elseif state.button_punch then
      end

      commonUpdate(entity, dt)
    end,
    enter = function(self)
      entity.walkingAnim.currentTime = 0
      entity.currentAnim = entity.walkingAnim
    end,
    leave = function(self)
    end,
  }

  entity.stateSitting = {
    update = function(self, dt)
      -- kick and punch
      if state.button_kick then
        moveState(entity, entity.stateSitKicking)
        return
      elseif state.button_punch then
        moveState(entity, entity.stateSitPunching)
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
        moveState(entity, entity.stateStanding)
      else
        moveState(entity, entity.stateStanding)
      end

      commonUpdate(entity, dt)
    end,
    enter = function(self)
      entity.sittingAnim.currentTime = 0
      entity.currentAnim = entity.sittingAnim
    end,
    leave = function(self)
    end,
  }

  entity.stateStandJumping = {
    savedPos = {
      x = 0,
      y = 0,
    },
    update = function(self, dt)
      if commonUpdate(entity, dt) == true then
        -- animation over
        moveState(entity, entity.stateStanding)
        entity:setPos(entity.stateStandJumping.savedPos.x, entity.stateStandJumping.savedPos.y)
      else
        local x,_ = entity:getPos()
        local y = entity.stateStandJumping.savedPos.y - calcJumpDistance(entity.standJumpingAnim);
        entity:setPos(x, y)
      end
    end,
    enter = function(self)
      entity.standJumpingAnim.currentTime = 0

      local x,y = entity:getPos()

      entity.stateStandJumping.savedPos.x = x
      entity.stateStandJumping.savedPos.y = y

      entity.currentAnim = entity.standJumpingAnim
    end,
    leave = function(self)
    end,
  }

  entity.stateWalkJumping = {
    savedPosY = 0,
    update = function(self, dt)
      if commonUpdate(entity, dt) == true then
        -- animation over
        moveState(entity, entity.stateWalking)

        local x, _ = entity:getPos()

        entity:setPos(x, entity.stateWalkJumping.savedPosY)
      else
        local x,_ = entity:getPos()
        local y = entity.stateWalkJumping.savedPosY - calcJumpDistance(entity.walkJumpingAnim);

        if entity.forward then
          x = x - move_speed * dt
        else
          x = x + move_speed * dt
        end 
        entity:setPos(x, y)
      end
    end,
    enter = function(self)
      entity.walkJumpingAnim.currentTime = 0

      local _,y = entity:getPos()

      entity.stateWalkJumping.savedPosY = y
      entity.currentAnim = entity.walkJumpingAnim
    end,
    leave = function(self)
    end,
  }

  entity.stateStandPunching = {
    update = function(self, dt)
      if commonUpdate(entity, dt) == true then
        -- animation over
        moveState(entity, entity.stateStanding)
      end
    end,
    enter = function(self)
      entity.standPunchAnim.currentTime = 0
      entity.currentAnim = entity.standPunchAnim
    end,
    leave = function(self)
    end,
  }

  entity.stateStandKicking = {
    update = function(self, dt)
      if commonUpdate(entity, dt) == true then
        -- animation over
        moveState(entity, entity.stateStanding)
      end
    end,
    enter = function(self)
      entity.standKickAnim.currentTime = 0
      entity.currentAnim = entity.standKickAnim
    end,
    leave = function(self)
    end,
  }

  entity.stateSitPunching = {
    update = function(self, dt)
      if commonUpdate(entity, dt) == true then
        -- animation over
        moveState(entity, entity.stateSitting)
      end
    end,
    enter = function(self)
      entity.sitPunchAnim.currentTime = 0
      entity.currentAnim = entity.sitPunchAnim
    end,
    leave = function(self)
    end,
  }

  entity.stateSitKicking = {
    update = function(self, dt)
      if commonUpdate(entity, dt) == true then
        -- animation over
        moveState(entity, entity.stateSitting)
      end
    end,
    enter = function(self)
      entity.sitKickAnim.currentTime = 0
      entity.currentAnim = entity.sitKickAnim
    end,
    leave = function(self)
    end,
  }

  entity.currentState = entity.stateStanding

  entity.draw = function(self)
    local x,y = entity:getPos()
    utils.drawAnimation(entity.currentAnim, x, y, 0, entity.pos.scale_x, entity.pos.scale_y)
  end

  entity.update = function(self, dt)
    self.currentState.update(self, dt)
  end

  return entity
end