--
-- kungfu master entity
--
local world = require('world')
local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')

local move_delta = 3

function moveState(entity, newState)
  entity.currentState.leave()
  entity.currentState = newState;
  entity.currentState.enter()
end

return function(pos_x, pos_y)
  local entity = {}
  local entity_width = 16
  local entity_height = 18
  local entity_speed = 0

  entity.body = love.physics.newBody(world, pos_x, pos_y, 'dynamic')
  entity.shape = love.physics.newRectangleShape(entity_width, entity_height)
  entity.fixture = love.physics.newFixture(entity.body, entity.shape)
  entity.fixture:setUserData(entity)

  entity.standingAnim = utils.newAnimationFromConf(asset_conf.spriteSheet, asset_conf.hero.sprites.standing);
  entity.walkingAnim = utils.newAnimationFromConf(asset_conf.spriteSheet, asset_conf.hero.sprites.walking);

  entity.currentAnim = entity.walkingAnim
  entity.forward = true

  entity.stateStanding = {
    update = function(self, dt)
      -- movement
      if state.button_left then
        entity.forward = true
        moveState(entity, entity.stateWalking)
      elseif state.button_right then
        entity.forward = false
        moveState(entity, entity.stateWalking)
      elseif state.button_down then
      elseif state.button_up then
      end

      -- kick and punch
      if state.button_kick then
      elseif state.button_punch then
      end

      entity.standingAnim.currentTime = entity.standingAnim.currentTime + dt
      if entity.standingAnim.currentTime >= entity.standingAnim.duration then
        entity.standingAnim.currentTime = entity.standingAnim.currentTime - entity.standingAnim.duration
      end
    end,

    draw = function(self)
      local x, y = self.body:getWorldPoints(self.shape:getPoints())
      local off;

      if self.forward == true then
        off = -4
      else
        off = 4
      end

      local spriteNum = math.floor(entity.standingAnim.currentTime / entity.standingAnim.duration * #entity.standingAnim.quads) + 1
      love.graphics.draw(entity.standingAnim.spriteSheet, entity.standingAnim.quads[spriteNum], x, y, 0, off, 4)
    end,
    enter = function(self)
      entity.standingAnim.currentTime = 0
    end,
    leave = function(self)
    end,
  }

  entity.stateWalking = {
    update = function(self, dt)
      local x, y;

      x, y = entity.body:getPosition();

      -- movement
      if state.button_left then
        x = x - move_delta
        entity.forward = true
        entity.body:setPosition(x, y)
      elseif state.button_right then
        x = x + move_delta
        entity.forward = false
        entity.body:setPosition(x, y)
      elseif state.button_down then
      elseif state.button_up then
      else
        moveState(entity, entity.stateStanding)
      end

      -- kick and punch
      if state.button_kick then
      elseif state.button_punch then
      end

      entity.walkingAnim.currentTime = entity.walkingAnim.currentTime + dt
      if entity.walkingAnim.currentTime >= entity.walkingAnim.duration then
        entity.walkingAnim.currentTime = entity.walkingAnim.currentTime - entity.walkingAnim.duration
      end
    end,
    draw = function(self)
      local x, y = self.body:getWorldPoints(self.shape:getPoints())
      local off;

      if self.forward == true then
        off = -4
      else
        off = 4
      end

      local spriteNum = math.floor(entity.walkingAnim.currentTime / entity.walkingAnim.duration * #entity.walkingAnim.quads) + 1
      love.graphics.draw(entity.walkingAnim.spriteSheet, entity.walkingAnim.quads[spriteNum], x, y, 0, off, 4)
    end,
    enter = function(self)
      entity.walkingAnim.currentTime = 0
    end,
    leave = function(self)
    end,
  }

  entity.currentState = entity.stateStanding

  entity.draw = function(self)
    self.currentState.draw(self)
  end

  entity.update = function(self, dt)
    self.currentState.update(self, dt)
  end

  return entity
end
