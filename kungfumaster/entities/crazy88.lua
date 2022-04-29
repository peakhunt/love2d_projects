--
-- crazy88 entity
--
local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')
local entity_common = require('entities/entity_common')
local common_conf = require('entities/common_conf')
local resource = require('resource')
local gameutil = require('gameutil')

local spriteSheet = resource.spriteSheet
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

function gotHitCommon(self, entity, from, hitQuad)
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

  entity:showScore(from, hitQuad)
end

states.walking = {
  animation = animations.walking,
  update = function(self, entity, dt)
    --
    -- implement some walking logic here
    --
    local hero = state.hero
    local distance, adistance = gameutil.distance(entity, hero)

    if adistance < 0.4 then
      entity:moveState(states.approaching)
      return
    end

    if adistance > 0.3 then
      entity.forward = gameutil.forwardDirection(distance)
    end

    local xdelta = gameutil.calcXDelta(entity.forward, common_conf.crazy88_speed, dt)

    entity:move(xdelta, 0)

    entity:commonUpdate(dt)
  end,
  takeHit = gotHitCommon,
}

states.approaching = {
  animation = animations.approaching,
  update = function(self, entity, dt)
    --
    -- implement some walking logic here
    --
    local hero = state.hero
    local distance, adistance = gameutil.distance(entity, hero)

    if adistance >= 0.4 then
      entity:moveState(states.walking)
      return
    end

    if adistance > 0.3 then
      entity.forward = gameutil.forwardDirection(distance)
    end

    local xdelta = gameutil.calcXDelta(entity.forward, common_conf.crazy88_speed, dt)

    entity:move(xdelta, 0)

    entity:commonUpdate(dt)
  end,
  takeHit = gotHitCommon,

  collideWithHero = function(self, entity, hero)
    local _, adistance = gameutil.distance(entity, hero)

    if adistance <=  hero.vQuad.width / 3 then
      entity:moveState(states.holding)
    end
  end,
}

states.holding = {
  animation = animations.holding,
  update = function(self, entity, dt)
    local _, adistance = gameutil.distance(entity, state.hero)

    if adistance > entity.vQuad.width then
      entity:moveState(states.approaching)
      return
    end

    entity.timeAccumulated = entity.timeAccumulated + dt
    if entity.timeAccumulated > 1.0 then
      entity.timeAccumulated = entity.timeAccumulated - 1
      state:decHeroEnergy(0.05)
    end

    entity:commonUpdate(dt)
  end,

  collideWithHero = function(self, entity, hero)
    if hero.trembling then
      if entity.health == 0.25 then
        entity:moveState(states.falling)
      else
        entity.health = entity.health - 0.25
      end
    end
  end,

  enter = function(self, entity, oldState)
    state:incHeld()
    entity.timeAccumulated = 0
    entity:commonStateEnter(animations.holding)
  end,

  leave = function(self, entity)
    state:decHeld()
  end,
}

states.falling = {
  animation = animations.falling,
  update = function(self, entity, dt)
    local xdelta, ydelta = gameutil.calcFallDelta(entity.forward, common_conf.fall_speed, dt)

    entity:move(xdelta, ydelta)

    if entity:commonUpdate(dt) == true then
      entity.health = 0
      state.crazy88_count = state.crazy88_count - 1
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
  entity.restrainPos = true
  entity.score = 100
  entity.damage = 0.05
  entity.timeAccumulated = 0

  return entity
end
