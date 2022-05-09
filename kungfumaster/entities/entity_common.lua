local common_conf = require('entities/common_conf')
local viewport = require('viewport')
local utils = require('utils')
local state = require('state')
local factory = require('factory')

function clamp(x, min, max)
  return math.min(math.max(min, x), max)
end

function drawEntity(entity)
  local px, py

  px, py = viewport:virtualPointToScreenCoord(entity.vQuad.x, entity.vQuad.y)

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
      love.graphics.rectangle("fill", px, py, w, h)
      love.graphics.setColor(1, 1, 1, 1)
    end
  end
end

return function(pos_x, pos_y, states, animations, start_state)
  local entity = {
    pos = {
      --
      -- bottom/center position of current quad in virtual space
      -- why center? because it was easiest to manipulate facing direction
      -- why bottom? because it was easiest to manage bottom given various sprite heights
      --
      x = pos_x,
      y = pos_y,
    },
    savedPos = {
      x = 0,
      y = 0,
    },

    health = 1,
    dead = false,

    animations = animations,
    states = states,
    forward = true,
    currentState = nil,
    currentAnim = nil,
    currentAnimTime = 0,
    spriteNum = 1,
    trembling = false,
    restrainPos = false,
    attacking = false,

    -- current quad in virtual space
    -- x/y here is top/left corner of the quad in virtual space
    vQuad = {},

    -- current hit quad in virtual space
    -- position in virtual space is already calculated by update
    vHitQuad = nil,
    vHitQuadBuf = {},

    setPos = function(self, x, y)
      if self.restrainPos then
        self.pos.x = clamp(x, state.current_level.limit.min, state.current_level.limit.max)
      else
        self.pos.x = x
      end
      self.pos.y = y
    end,

    getPos = function(self)
      return self.pos.x, self.pos.y
    end,

    commonStateEnter = function(self, newAnim)
      self.currentAnimTime = 0
      self.currentAnim = newAnim 
      self.spriteNum = 1
    end,

    moveState = function(self, newstate)
      local oldState = self.currentState

      if oldState ~= nil and oldState.leave then
        oldState:leave(self)
      end

      if type(newstate) == 'string' then
        newstate = self.states[newstate]
      end

      self.currentState = newstate

      if newstate.enter then
        self.currentState:enter(self, oldState)
      else
        self:commonStateEnter(newstate.animation)
      end 

      self:updateQuad()
    end,

    draw = function(self)
      drawEntity(self)
    end,

    update = function(self, dt)
      -- preupdate
      self.trembling = false

      -- main update
      self.currentState:update(self, dt)

      -- post update
      self:updateQuad()
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

    updateQuad = function(self)
      self.vQuad.x = self.pos.x - self.currentAnim.virtSize[self.spriteNum].width/2
      self.vQuad.y = self.pos.y + self.currentAnim.virtSize[self.spriteNum].height
      self.vQuad.width = self.currentAnim.virtSize[self.spriteNum].width
      self.vQuad.height = self.currentAnim.virtSize[self.spriteNum].height

      self:updateHitPoint()
    end,

    updateHitPoint = function(self)
      local hitPoint = self.currentAnim.virtSize[self.spriteNum].hitPoint

      if hitPoint == nil then
        self.vHitQuad = nil
        return
      end

      local left_x  = self.vQuad.x
      local right_x = self.vQuad.x + self.vQuad.width
      local top_y   = self.vQuad.y
      local hx, hy

      if self.forward then
        hx = right_x - hitPoint.rx - hitPoint.width
      else
        hx = left_x + hitPoint.rx
      end

      hy = top_y - hitPoint.ry

      self.vHitQuadBuf.x = hx
      self.vHitQuadBuf.y = hy
      self.vHitQuadBuf.width = hitPoint.width
      self.vHitQuadBuf.height =hitPoint.height

      self.vHitQuad = self.vHitQuadBuf
    end,

    takeHit = function(self, from, hitQuad)
      if self.currentState.takeHit then
        self.currentState:takeHit(self, from, hitQuad)
      end
    end,

    collideWithHero = function(self, hero)
      if self.currentState.collideWithHero then
        self.currentState:collideWithHero(self, hero)
      end
    end,

    move = function(self, xdelta, ydelta)
      local x,y = self:getPos()

      x = x + xdelta
      y = y + ydelta

      self:setPos(x, y)
    end,

    showScore = function(self, hero, hitQuad)
      if hero.currentState.scoreX and self.score then
        local s = hero.currentState.scoreX * self.score

        local x, y

        -- FIXME which one is better?
        --x = entity.vQuad.x
        --y = entity.vQuad.y + 0.05
        x = hitQuad.x
        y = hitQuad.y - hitQuad.height

        state:incScore(s, factory.entities.score(x, y, s))
      end
    end,

    takeAttack = function(self, hero, hitQuad)
      if self.currentState.takeAttack then
        self.currentState:takeAttack(self, hero, hitQuad)
      end
    end,
  }

  entity:moveState(start_state)

  return entity
end
