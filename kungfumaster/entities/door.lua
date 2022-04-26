local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')
local resource = require('resource')
local viewport = require('viewport')

local spriteSheet = resource.doorSprite
local doors = asset_conf.doors

--------------------------------------------------------------------------------
-- 
-- door sprite animations
--
--------------------------------------------------------------------------------
local animations = {
  leftClosing = utils.newAnimationSimple(spriteSheet, doors.left),
  rightClosing = utils.newAnimationSimple(spriteSheet, doors.right),
}

--------------------------------------------------------------------------------
-- 
-- door state machine
--
--------------------------------------------------------------------------------
local states = {}

states.closing = {
  update = function(self, entity, dt)
    entity.currentAnimTime = entity.currentAnimTime + dt
    if entity.currentAnimTime >= entity.currentAnim.duration then
      entity.currentAnimTime = entity.currentAnimTime - entity.currentAnim.duration
      entity:moveState(states.closed)
      return
    end 

    local sn = math.floor(entity.currentAnimTime / entity.currentAnim.duration * #entity.currentAnim.quads) + 1

    if sn > #entity.currentAnim.quads or sn < 1 then
      sn = 1
    end

    entity.spriteNum = sn
  end,

  draw = function(self, entity)
    local px, py
    local scale_x, scale_y
    local sQuad = entity.currentAnim.quads[entity.spriteNum]

    px, py = viewport:virtualPointToScreenCoord(entity.conf.pos.x, entity.conf.pos.y)

    scale_x, scale_y = viewport:getScaleFactor(entity.conf.pos, sQuad)

    love.graphics.draw(spriteSheet, sQuad,
      px, py, 0,
      scale_x, scale_y)
  end,
}

states.closed = {
  update = function(self, entity, dt)
  end,

  draw = function(self, entity)
  end,
}

return function(left)
  local entity = {
    left = left,
    currentState = nil,
    currentAnimTime = 0,
    currentAnim = nil,
    spriteNum = 1,
    conf = nil,

    moveState = function(self, newstate)
      self.currentState = newstate
      self.currentAnimTime = 0
      self.spriteNum = 1

      if newstate == states.closing then
        if self.left then
          self.currentAnim = animations.leftClosing
          self.conf = doors.left
        else
          self.currentAnim = animations.rightClosing
          self.conf = doors.right
        end
      else
        self.currentAnim = nil
      end
    end,

    draw = function(self)
      self.currentState:draw(self)
    end,

    update = function(self, dt)
      self.currentState:update(self, dt)
    end,

    reset = function(self)
      self:moveState(states.closing)
    end,
  }

  entity:moveState(states.closing)

  return entity
end
