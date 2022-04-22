--
-- crazy88 entity
--
local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')
local entity_common = require('entities/entity_common')
local common_conf = require('entities/common_conf')

local spriteSheet = asset_conf.spriteSheet
local assetCrazy88 = asset_conf.crazy88
local sprites = assetCrazy88.sprites

--------------------------------------------------------------------------------
-- 
-- crazy88 sprite animations
--
--------------------------------------------------------------------------------
local animations = {
  walking = utils.newAnimationFromConf(spriteSheet, sprites.walking, assetCrazy88.refFrame),
  approaching = utils.newAnimationFromConf(spriteSheet, sprites.approaching, assetCrazy88.refFrame),
  holding = utils.newAnimationFromConf(spriteSheet, sprites.holding, assetCrazy88.refFrame),
  falling = utils.newAnimationFromConf(spriteSheet, sprites.falling, assetCrazy88.refFrame),
  hitTop = utils.newAnimationFromConf(spriteSheet, sprites.hitTop, assetCrazy88.refFrame),
  hitMiddle = utils.newAnimationFromConf(spriteSheet, sprites.hitMiddle, assetCrazy88.refFrame),
  hitBottom = utils.newAnimationFromConf(spriteSheet, sprites.hitBottom, assetCrazy88.refFrame),
}

--------------------------------------------------------------------------------
-- 
-- crazy88 state machine
--
--------------------------------------------------------------------------------
local states = {}

states.walking = {
  animation = animations.walking,
  update = function(self, entity, dt)
    --
    -- implement some walking logic here
    --
    local hero = state.hero
    local distance = entity.vQuad.x - hero.vQuad.x

    if math.abs(distance) < 0.4 then
      entity:moveState(states.approaching)
    end

    if math.abs(distance) > 0.3 then
      if distance < 0 then
        entity.forward = false
      else
        entity.forward = true
      end
    end

    local xdelta
    if entity.forward then
      xdelta =  -common_conf.crazy88_speed * dt
    else
      xdelta =  common_conf.crazy88_speed * dt
    end

    entity:move(xdelta, 0)

    entity:commonUpdate(dt)
  end,
  takeHit = function(self, entity, hitQuad)
    local mid1, mid2, a_quarter

    a_quarter = entity.vQuad.height / 4

    mid1 = entity.vQuad.y - a_quarter
    mid2 = mid1 - 2 * a_quarter

    if hitQuad.y > mid1 then
      -- top hit
      entity:moveState(states.hitTop)
    elseif hitQuad.y < mid1 and hitQuad.y > mid2 then
      -- middle hit
      entity:moveState(states.hitMiddle)
    else
      -- bottom hit
      entity:moveState(states.hitBottom)
    end
  end,
}

states.approaching = {
  animation = animations.approaching,
  update = function(self, entity, dt)
    --
    -- implement some walking logic here
    --
    local hero = state.hero
    local distance = entity.vQuad.x - hero.vQuad.x

    if math.abs(distance) >= 0.4 then
      entity:moveState(states.walking)
    end

    if math.abs(distance) > 0.3 then
      if distance < 0 then
        entity.forward = false
      else
        entity.forward = true
      end
    end

    local xdelta
    if entity.forward then
      xdelta =  -common_conf.crazy88_speed * dt
    else
      xdelta =  common_conf.crazy88_speed * dt
    end

    entity:move(xdelta, 0)

    entity:commonUpdate(dt)
  end,
  takeHit = function(self, entity, hitQuad)
    local mid1, mid2, a_quarter

    a_quarter = entity.vQuad.height / 4

    mid1 = entity.vQuad.y - a_quarter
    mid2 = mid1 - 2 * a_quarter

    if hitQuad.y > mid1 then
      -- top hit
      entity:moveState(states.hitTop)
    elseif hitQuad.y < mid1 and hitQuad.y > mid2 then
      -- middle hit
      entity:moveState(states.hitMiddle)
    else
      -- bottom hit
      entity:moveState(states.hitBottom)
    end
  end,

  collideWithHero = function(self, entity, hero)
    local distance = math.abs(entity.pos.x - hero.pos.x)

    if distance <=  hero.vQuad.width / 3 then
      state.held = state.held + 1
      entity:moveState(states.holding)
    end
  end,
}

states.holding = {
  animation = animations.holding,
  update = function(self, entity, dt)
    entity:commonUpdate(dt)
  end,
  collideWithHero = function(self, entity, hero)
    if hero.trembling then
      if entity.health == 0.25 then
        state.held = state.held - 1
        entity:moveState(states.falling)
      else
        entity.health = entity.health - 0.25
      end
    end
  end,
}

states.falling = {
  animation = animations.falling,
  update = function(self, entity, dt)
    local xdelta, ydelta

    if entity.forward then
      xdelta = common_conf.crazy88_fall_speed * dt
    else
      xdelta = -common_conf.crazy88_fall_speed * dt
    end
    ydelta = -common_conf.crazy88_fall_speed * dt

    entity:move(xdelta, ydelta)

    if entity:commonUpdate(dt) == true then
      entity.health = 0
    end
  end,
}

states.hitTop = {
  animation = animations.hitTop,
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      entity:moveState(states.falling)
    end
  end,
}
states.hitMiddle = {
  animation = animations.hitMiddle,
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      entity:moveState(states.falling)
    end
  end,
}

states.hitBottom = {
  animation = animations.hitBottom,
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      entity:moveState(states.falling)
    end
  end,
}

return function(pos_x, pos_y)
  local entity = entity_common(pos_x, pos_y, states, animations, states.walking)

  entity.name = "crazy88"
  return entity
end
