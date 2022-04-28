--
-- gogo entity
--
local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')
local entity_common = require('entities/entity_common')
local common_conf = require('entities/common_conf')
local resource = require('resource')
local knife = require('entities/knife')

local spriteSheet = resource.spriteSheet
local assetGogo = asset_conf.gogo
local sprites = assetGogo.sprites

local targetRange = 0.45
local tooCloseStart = 0.2
local tooCloseStop = 0.35

--------------------------------------------------------------------------------
-- 
-- gogo sprite animations
--
--------------------------------------------------------------------------------
local animKey = {
  "standing",
  "walking",
  "throwingHigh",
  "throwingLow",
  "falling",
  "hit1",
  "hit2",
}

local animations = {
  standing = utils.newAnimationFromConf(spriteSheet, sprites.standing, assetGogo.refFrame),
  walking = utils.newAnimationFromConf(spriteSheet, sprites.walking, assetGogo.refFrame),
  throwingHigh = utils.newAnimationFromConf(spriteSheet, sprites.throwingHigh, assetGogo.refFrame),
  throwingLow = utils.newAnimationFromConf(spriteSheet, sprites.throwingLow, assetGogo.refFrame),
  falling = utils.newAnimationFromConf(spriteSheet, sprites.falling, assetGogo.refFrame),
  hit1 = utils.newAnimationFromConf(spriteSheet, sprites.hit1, assetGogo.refFrame),
  hit2 = utils.newAnimationFromConf(spriteSheet, sprites.hit2, assetGogo.refFrame),
}

--------------------------------------------------------------------------------
-- 
-- gogo state machine
--
--------------------------------------------------------------------------------
local states = {}

function throwKnife(entity, y)
  local distance = entity.vQuad.x - state.hero.vQuad.x
  local forward = true

  if distance < 0 then
    forward = false
  end

  local k
  local x

  if forward then
    x = entity.vQuad.x
  else
    x = entity.vQuad.x + entity.vQuad.width
  end

  k = knife(x, y, forward)
  table.insert(state.entities, k)
end

function gotHitCommon(self, entity, from, hitQuad)
  if entity.health == 1.0 then
    entity:moveState(states.hit1)
  else
    entity:moveState(states.hit2)
  end
end

states.standing = {
  animation = animations.standing,
  update = function(self, entity, dt)
    local hero = state.hero
    local r = love.math.random()
    local distance = entity.vQuad.x - hero.vQuad.x

    -- too far to throw a knife
    if math.abs(distance) > targetRange then
      -- too far
      entity:moveState(states.walkingTo)
      return
    end

    -- too close. have to run away
    if math.abs(distance) < tooCloseStart and -- too close
       entity.timeAccumulated < 0.7 and       -- and not waited enough to aim
       r < 0.2 then                           -- then 20% chance
       entity:moveState(states.walkingAway)
        return
    end

    if distance < 0 then
      entity.forward = false
    else
      entity.forward = true
    end

    entity.timeAccumulated = entity.timeAccumulated + dt
    if entity.timeAccumulated > 1.0 then
      if r < 0.3 then
        entity:moveState(states.throwingHigh)
      elseif r < 0.6 then
        entity:moveState(states.throwingLow)
      else
        entity.timeAccumulated = 0
      end
    end

    entity:commonUpdate(dt)
  end,

  enter = function(self, entity, oldState)
    entity:commonStateEnter(animations.standing)
    entity.timeAccumulated = 0
  end,

  takeHit = gotHitCommon,
}

--
-- walking away from hero 
--
states.walkingAway = {
  animation = animations.walking,
  update = function(self, entity, dt)
    local hero = state.hero
    local distance = entity.vQuad.x - hero.vQuad.x

    if math.abs(distance) > tooCloseStop then
      entity:moveState(states.standing)
      return
    end

    if distance < 0 then
      entity.forward = true
    else
      entity.forward = false
    end

    local xdelta
    if entity.forward then
      xdelta =  -common_conf.gogo_speed * dt
    else
      xdelta =  common_conf.gogo_speed * dt
    end

    entity:move(xdelta, 0)

    entity:commonUpdate(dt)
  end,

  takeHit = gotHitCommon,
}

--
-- walking to hero
--
states.walkingTo = {
  animation = animations.walking,
  update = function(self, entity, dt)
    local hero = state.hero
    local distance = entity.vQuad.x - hero.vQuad.x

    if math.abs(distance) < targetRange then
      entity:moveState(states.standing)
      return
    end

    if distance < 0 then
      entity.forward = fale
    else
      entity.forward = true
    end

    local xdelta
    if entity.forward then
      xdelta =  -common_conf.gogo_speed * dt
    else
      xdelta =  common_conf.gogo_speed * dt
    end

    entity:move(xdelta, 0)

    entity:commonUpdate(dt)
  end,

  takeHit = gotHitCommon,
}

states.throwingHigh = {
  animation = animations.throwingHigh,
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      throwKnife(entity, entity.pos.y + (entity.vQuad.height * 7 / 8))
      entity:moveState(states.waiting)
    end
  end,

  takeHit = gotHitCommon,
}

states.throwingLow = {
  animation = animations.throwingLow,
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      throwKnife(entity, entity.pos.y + entity.vQuad.height / 4)
      entity:moveState(states.waiting)
    end
  end,

  takeHit = gotHitCommon,
}

states.waiting = {
  animation = animations.standing,
  update = function(self, entity, dt)
    entity.timeAccumulated = entity.timeAccumulated + dt

    if entity.timeAccumulated > 0.5 + love.math.random() then
      entity:moveState(states.standing)
        return
    end

    entity:commonUpdate(dt);
  end,

  enter = function(self, entity, oldState)
    entity:commonStateEnter(animations.standing)
    entity.timeAccumulated = 0
  end,

  takeHit = gotHitCommon,
}

states.hit1 = {
  animation = animations.hit1,
  update = function(self, entity, dt)
    -- just for test for now
    if entity:commonUpdate(dt) == true then
      entity.health = 0.5
      entity:moveState(states.standing)
    end
  end,
}

states.hit2 = {
  animation = animations.hit2,
  update = function(self, entity, dt)
    -- just for test for now
    if entity:commonUpdate(dt) == true then
      entity:moveState(states.falling)
    end
  end,
}

states.falling = {
  animation = animations.falling,
  update = function(self, entity, dt)
    local xdelta, ydelta

    if entity.forward then
      xdelta = common_conf.fall_speed * dt
    else
      xdelta = -common_conf.fall_speed * dt
    end
    ydelta = -common_conf.fall_speed * dt

    entity:move(xdelta, ydelta)

    if entity:commonUpdate(dt) == true then
      entity.health = 0
    end
  end,
}

return function(pos_x, pos_y)
  local entity = entity_common(pos_x, pos_y, states, animations, states.standing)

  entity.name = "gogo"
  entity.restrainPos = true
  entity.score = 200
  entity.timeAccumulated = 0

  return entity
end
