--
-- kungfu master entity
--
local world = require('world')
local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')

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

  entity.stateIdle = function(self, dt)
  begin

  entity.draw = function(self)
    local x, y = self.body:getWorldPoints(self.shape:getPoints())

    local spriteNum = math.floor(entity.currentAnim.currentTime / entity.currentAnim.duration * #entity.currentAnim.quads) + 1
    love.graphics.draw(entity.currentAnim.spriteSheet, entity.currentAnim.quads[spriteNum], x, y, 0, 4)
  end

  entity.update = function(self, dt)
    -- movement
    if state.button_left then
    elseif state.button_right then
    elseif state.button_down then
    elseif state.button_up then
    end

    -- kick and punch
    if state.button_kick then
    elseif state.button_punch then
    end

    entity.currentAnim.currentTime = entity.currentAnim.currentTime + dt
    if entity.currentAnim.currentTime >= entity.currentAnim.duration then
      entity.currentAnim.currentTime = entity.currentAnim.currentTime - entity.currentAnim.duration
    end
  end

  return entity
end
