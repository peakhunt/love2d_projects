local common_conf = require('entities/common_conf')
local viewport = require('viewport')
local utils = require('utils')
local state = require('state')

function drawAnimation(anim, currentTime, x, y, rotation, forward)
  local spriteNum = math.floor(currentTime / anim.duration * #anim.quads) + 1
  if spriteNum > #anim.quads or spriteNum < 1 then
    -- print('BUG: spriteNum bigger than quads:', spriteNum, #anim.quads)
    -- return
    spriteNum = 1
  end

  local px, py

  -- px, py is bottom left corener of the rectangle
  px, py = viewport:toScreenTop(x, y, anim.virtSize[spriteNum])

  -- calculate scale factor
  local scale_x, scale_y
  local w, h = viewport:toScreenDim(anim.virtSize[spriteNum])

  scale_x, scale_y = viewport:getScaleFactor(anim.virtSize[spriteNum], anim.quads[spriteNum])

  if forward then
    scale_x = -scale_x
  end

  local _, _, sw = anim.quads[spriteNum]:getViewport()

  love.graphics.draw(anim.spriteSheet, anim.quads[spriteNum], px, py, rotation, scale_x, scale_y, sw/2)

  if state.button_debug then
    local w, h = viewport:toScreenDim(anim.virtSize[spriteNum])

    if forward then
      px = px + w/2
      w = -w
    else
      px = px - w/2
    end

    love.graphics.setColor(1.0, 0, 0, 1)
    love.graphics.rectangle("line", px, py, w, h)
    love.graphics.setColor(1, 1, 1, 1)
  end
end

return function(pos_x, pos_y, states, animations, start_state)
  local entity = {
    pos = {
      x = pos_x,
      y = pos_y,
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
      else
        self.currentAnimTime = 0
        self.currentAnim = newstate.animation
      end 
    end,

    draw = function(self)
      local x,y = self:getPos()
      drawAnimation(self.currentAnim, self.currentAnimTime, x, y, 0, self.forward)
    end,

    update = function(self, dt)
      if dt < 0.1 then
        self.currentState:update(self, dt)
      end
    end,

    commonUpdate = function(self, dt)
      self.currentAnimTime = self.currentAnimTime + dt
      if self.currentAnimTime >= self.currentAnim.duration then
        -- XXX this can cause a weird problem in sluggish env with huge dt
        -- but keeping it this way for now
        self.currentAnimTime = self.currentAnimTime - self.currentAnim.duration
        --self.currentAnimTime = 0
        return true
      end
      return false
    end,

    updateOneshot = function(self, dt, nextState)
      if self:commonUpdate(dt) == true then
        self:moveState(nextState)
      end
    end,
  }

  entity:moveState(start_state)

  return entity
end
