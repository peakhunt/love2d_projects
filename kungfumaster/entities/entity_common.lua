local common_conf = require('entities/common_conf')
local viewport = require('viewport')
local utils = require('utils')
local state = require('state')

function drawEntity(entity)
  local px, py

  -- px, py is bottom center of the rectangle
  px, py = viewport:toScreenTopLeft(entity.pos.x, entity.pos.y, entity.currentAnim.virtSize[entity.spriteNum])

  -- calculate scale factor
  local scale_x, scale_y
  scale_x, scale_y = viewport:getScaleFactor(entity.currentAnim.virtSize[entity.spriteNum], entity.currentAnim.quads[entity.spriteNum])

  local _, _, sw = entity.currentAnim.quads[entity.spriteNum]:getViewport()

  if entity.forward then
    scale_x = -scale_x
  else
    sw = 0
  end

  love.graphics.draw(entity.currentAnim.spriteSheet,
                     entity.currentAnim.quads[entity.spriteNum],
                     px, py, rotation,
                     scale_x, scale_y,
                     sw, 0)

  if state.button_debug then
    -- XXX
    -- this is the rectangle we will use for collision detection
    --
    local w, h = viewport:toScreenDim(entity.vQuad)

    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.rectangle("line", px, py, w, h)
    love.graphics.setColor(1, 1, 1, 1)

    --
    -- hitPoint
    --
    if entity.vHitQuad then
      px, py = viewport:virtualPointToScreenCoord(entity.vHitQuad.x, entity.vHitQuad.y)
      w, h = viewport:toScreenDim({
        width = entity.vHitQuad.width,
        height = entity.vHitQuad.height,
      })

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

    -- current quad in virtual space
    vQuad = nil,

    -- current hit quad in virtual space
    -- position in virtual space is already calculated by update
    vHitQuad = nil,

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
      drawEntity(self)
    end,

    update = function(self, dt)
      -- preupdate

      -- main update
      if dt < 0.1 then
        self.currentState:update(self, dt)
      end

      -- post update
      self.vQuad = self.currentAnim.virtSize[self.spriteNum]
      self:updateHitPoint()
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

    updateHitPoint = function(self)
      if self.vQuad.hitPoint == nil then
        self.vHitQuad = nil
        return
      end

      -- (x, y) is bottom center
      -- hitPoint coord is top left
      local left_x  = self.pos.x - self.vQuad.width / 2
      local right_x = self.pos.x + self.vQuad.width / 2
      local top_y   = self.pos.y + self.vQuad.height
      local hx, hy

      if self.forward then
        hx = right_x - self.vQuad.hitPoint.rx - self.vQuad.hitPoint.width
      else
        hx = left_x + self.vQuad.hitPoint.rx
      end

      hy = top_y - self.vQuad.hitPoint.ry

      self.vHitQuad = {
        x = hx,
        y = hy,
        width = self.vQuad.hitPoint.width,
        height = self.vQuad.hitPoint.height,
      }
    end,
  }

  entity:moveState(start_state)

  return entity
end
