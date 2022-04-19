local common_conf = require('entities/common_conf')
local viewport = require('viewport')
local utils = require('utils')
local state = require('state')

function drawAnimation(anim, spriteNum, x, y, rotation, forward)
  local px, py

  -- px, py is bottom center of the rectangle
  px, py = viewport:toScreenTopLeft(x, y, anim.virtSize[spriteNum])

  -- calculate scale factor
  local scale_x, scale_y

  scale_x, scale_y = viewport:getScaleFactor(anim.virtSize[spriteNum], anim.quads[spriteNum])
  local _, _, sw = anim.quads[spriteNum]:getViewport()

  if forward then
    scale_x = -scale_x
  else
    sw = 0
  end


  love.graphics.draw(anim.spriteSheet, anim.quads[spriteNum], px, py, rotation, scale_x, scale_y, sw, 0)

  if state.button_debug then
    -- XXX
    -- this is the rectangle we will use for collision detection
    --
    local w, h = viewport:toScreenDim(anim.virtSize[spriteNum])

    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.rectangle("line", px, py, w, h)
    love.graphics.setColor(1, 1, 1, 1)

    --
    -- hitPoint
    --
    if anim.virtSize[spriteNum].hitPoint then
      -- (x, y) is bottom center
      -- hitPoint coord is top left
      local left_x = x - anim.virtSize[spriteNum].width / 2
      local right_x = x + anim.virtSize[spriteNum].width / 2
      local top_y = y + anim.virtSize[spriteNum].height
      local hx, hy

      -- rx/ry are relative point from top/left
      -- rx/ry are calculated for forward = false
      if forward then
        hx = right_x - anim.virtSize[spriteNum].hitPoint.rx - anim.virtSize[spriteNum].hitPoint.width
      else
        hx = left_x + anim.virtSize[spriteNum].hitPoint.rx
      end
      hy = top_y - anim.virtSize[spriteNum].hitPoint.ry

      -- now we got top left virtual coordinate of hitPoint rectangle
      -- width/height of the rectangle are already calculated at load time

      -- now we have to convert (hx, hy) to pixel coordinate and
      -- calculate scale factor for with/height of hitPoint
      px, py = viewport:virtualPointToScreenCoord(hx, hy)
      w, h = viewport:toScreenDim({
        width = anim.virtSize[spriteNum].hitPoint.width,
        height = anim.virtSize[spriteNum].hitPoint.height,
      })

      -- now draw
      love.graphics.setColor(1, 0, 0, 1)
      love.graphics.rectangle("line", px, py, w, h)
      love.graphics.setColor(1, 1, 1, 1)
    end
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
    spriteNum = 1,
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

      self.spriteNum = 1
    end,

    draw = function(self)
      local x,y = self:getPos()
      drawAnimation(self.currentAnim, self.spriteNum, x, y, 0, self.forward)
    end,

    update = function(self, dt)
      if dt < 0.1 then
        self.currentState:update(self, dt)
      end
    end,

    commonUpdate = function(self, dt)
      local ret = false

      self.currentAnimTime = self.currentAnimTime + dt
      if self.currentAnimTime >= self.currentAnim.duration then
        -- XXX this can cause a weird problem in sluggish env with huge dt
        -- but keeping it this way for now
        self.currentAnimTime = self.currentAnimTime - self.currentAnim.duration
        --self.currentAnimTime = 0
        ret = true
      end

      local sn = math.floor(self.currentAnimTime / self.currentAnim.duration * #self.currentAnim.quads) + 1
      if sn > #self.currentAnim.quads or sn < 1 then
        --print('BUG: spriteNum bigger than quads:', spriteNum, #anim.quads)
        sn = 1
      end

      self.spriteNum = sn

      return ret
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
