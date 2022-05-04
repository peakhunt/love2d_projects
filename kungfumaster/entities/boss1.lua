local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')
local entity_common = require('entities/entity_common')
local common_conf = require('entities/common_conf')
local resource = require('resource')
local gameutil = require('gameutil')

local spriteSheet = resource.spriteSheet
local assetBoss1 = asset_conf.boss1
local sprites = assetBoss1.sprites

local minDistanceForAttack = 0.1

--------------------------------------------------------------------------------
-- 
-- boss1 sprite animations
--
--------------------------------------------------------------------------------
local animations = {
  standing = utils.newAnimationFromConf(spriteSheet, sprites.standing, assetBoss1.refFrame),
  walking = utils.newAnimationFromConf(spriteSheet, sprites.walking, assetBoss1.refFrame),
  standAttackHigh = utils.newAnimationFromConf(spriteSheet, sprites.standAttackHigh, assetBoss1.refFrame),
  standAttackMid = utils.newAnimationFromConf(spriteSheet, sprites.standAttackMid, assetBoss1.refFrame),
  sitting = utils.newAnimationFromConf(spriteSheet, sprites.sitting, assetBoss1.refFrame),
  sitAttack = utils.newAnimationFromConf(spriteSheet, sprites.sitAttack, assetBoss1.refFrame),
  hit1 = utils.newAnimationFromConf(spriteSheet, sprites.hit1, assetBoss1.refFrame),
  hit2 = utils.newAnimationFromConf(spriteSheet, sprites.hit2, assetBoss1.refFrame),
  hit3 = utils.newAnimationFromConf(spriteSheet, sprites.hit3, assetBoss1.refFrame),
  hit4 = utils.newAnimationFromConf(spriteSheet, sprites.hit4, assetBoss1.refFrame),
  hit5 = utils.newAnimationFromConf(spriteSheet, sprites.hit5, assetBoss1.refFrame),
  falling = utils.newAnimationFromConf(spriteSheet, sprites.falling, assetBoss1.refFrame),
}

--------------------------------------------------------------------------------
-- 
-- boss1 state machine
--
--------------------------------------------------------------------------------
local states = {}

function standGotHitCommon(self, entity, from, hitQuad)
  local mid1, mid2, a_quarter

  entity.health = entity.health - 0.1
  state:decBossEnergy(0.1)

  a_quarter = entity.vQuad.height / 4

  mid1 = entity.vQuad.y - a_quarter
  mid2 = mid1 - 2 * a_quarter

  if hitQuad.y > mid1 then
    -- top hit
    entity:moveState(states.hit1)
  elseif hitQuad.y < mid1 and hitQuad.y > mid2 then
    -- middle hit
    entity:moveState(states.hit2)
  else
    -- bottom hit
    entity:moveState(states.hit3)
  end
end

function sitGotHitCommon(self, entity, from, hitQuad)
  local mid1, mid2, a_quarter

  entity.health = entity.health - 0.1
  state:decBossEnergy(0.1)

  a_quarter = entity.vQuad.height / 4

  mid1 = entity.vQuad.y - a_quarter
  mid2 = mid1 - 2 * a_quarter

  if hitQuad.y > mid2 then
    entity:moveState(states.hit4)
  else
    -- bottom hit
    entity:moveState(states.hit5)
  end
end

states.standing = {
  animation = animations.standing,
  update = function(self, entity, dt)
    local _, adistance = gameutil.distance(entity, state.hero)

    if state.boss_activated == true then
      if adistance > minDistanceForAttack then
        entity.randomTimer = 0
        entity:moveState(states.walking)
        return
      end
    else
      if adistance <= 0.4 then
        state.boss_activated = true
      end
      return
    end

    if entity.randomTimer == 0 then
      entity.randomTimer = love.math.random() + 0.2
      entity.timeAccumulated = 0
    else
      entity.timeAccumulated = entity.timeAccumulated + dt

      if entity.timeAccumulated >= entity.randomTimer then
        -- time out
        entity.randomTimer = 0

        local r = love.math.random()

        if r < 0.3 then
          entity:moveState(states.standAttackHigh)
        elseif r < 0.6 then
          entity:moveState(states.standAttackMid)
        elseif r < 0.8 then
          entity:moveState(states.sitting)
        end
      end
    end

    entity:commonUpdate(dt)
  end,

  takeHit = standGotHitCommon,
}

states.walking = {
  animation = animations.walking,
  update = function(self, entity, dt)
    local distance, adistance = gameutil.distance(entity, state.hero)

    if adistance <= minDistanceForAttack then
      entity:moveState(states.standing)
      return
    end

    entity.forward = gameutil.forwardDirection(distance)

    local xdelta = gameutil.calcXDelta(entity.forward, common_conf.boss1_speed, dt)

    entity:move(xdelta, 0)

    entity:commonUpdate(dt)
  end,

  takeHit = standGotHitCommon,
}

states.standAttackHigh = {
  animation = animations.standAttackHigh,
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      entity:moveState(states.standing)
    end
  end,

  enter = function(self, entity, oldState)
    entity.attacking = true
    entity:commonStateEnter(animations.standAttackHigh)
  end,

  leave = function(self, entity)
    entity.attacking = false
  end,

  takeAttack = function(self, entity, hero, hitQuad)
    entity.attacking = false
    hero:takeHit(entity, hitQuad)
  end,
}

states.standAttackMid = {
  animation = animations.standAttackMid,
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      entity:moveState(states.standing)
    end
  end,

  enter = function(self, entity, oldState)
    entity.attacking = true
    entity:commonStateEnter(animations.standAttackMid)
  end,

  leave = function(self, entity)
    entity.attacking = false
  end,

  takeAttack = function(self, entity, hero, hitQuad)
    entity.attacking = false
    hero:takeHit(entity, hitQuad)
  end,
}

states.sitting = {
  animation = animations.sitting,
  update = function(self, entity, dt)
    if entity.randomTimer == 0 then
      entity.randomTimer = love.math.random() + 0.2
      entity.timeAccumulated = 0
    else
      entity.timeAccumulated = entity.timeAccumulated + dt

      if entity.timeAccumulated >= entity.randomTimer then
        -- time out
        entity.randomTimer = 0

        local r = love.math.random()

        if r < 0.5 then
          entity:moveState(states.standing)
        else
          entity:moveState(states.sitAttack)
        end
      end
    end

    entity:commonUpdate(dt)
  end,

  takeHit = sitGotHitCommon,
}

states.sitAttack = {
  animation = animations.sitAttack,
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      entity:moveState(states.sitting)
    end
  end,

  enter = function(self, entity, oldState)
    entity.attacking = true
    entity:commonStateEnter(animations.sitAttack)
  end,

  leave = function(self, entity)
    entity.attacking = false
  end,

  takeAttack = function(self, entity, hero, hitQuad)
    entity.attacking = false
    hero:takeHit(entity, hitQuad)
  end,
}

states.hit1 = {
  animation = animations.hit1,
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      if entity.health <= 0 then
        entity:moveState(states.falling)
      else
        entity:moveState(states.standing)
      end
    end
  end,
}

states.hit2 = {
  animation = animations.hit2,
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      if entity.health <= 0 then
        entity:moveState(states.falling)
      else
        entity:moveState(states.standing)
      end
    end
  end,
}

states.hit3 = {
  animation = animations.hit3,
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      if entity.health <= 0 then
        entity:moveState(states.falling)
      else
        entity:moveState(states.standing)
      end
    end
  end,
}

states.hit4 = {
  animation = animations.hit4,
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      if entity.health <= 0 then
        entity:moveState(states.falling)
      else
        entity:moveState(states.sitting)
      end
    end
  end,
}

states.hit5 = {
  animation = animations.hit5,
  update = function(self, entity, dt)
    if entity:commonUpdate(dt) == true then
      if entity.health <= 0 then
        entity:moveState(states.falling)
      else
        entity:moveState(states.sitting)
      end
    end
  end,
}

states.falling = {
  animation = animations.falling,
  update = function(self, entity, dt)
    local xdelta, ydelta = gameutil.calcFallDelta(entity.forward, common_conf.fall_speed, dt)

    entity:move(xdelta, ydelta)

    if entity:commonUpdate(dt) then
      state.boss_cleared = true
      entity.dead = true
    end
  end,
}

return function(pos_x, pos_y)
  local entity = entity_common(pos_x, pos_y, states, animations, states.standing)

  entity.name = "boss1"
  entity.restrainPos = true
  entity.score = 1000
  entity.timeAccumulated = 0
  entity.randomTimer = 0
  entity.damage = 0.1

  return entity
end
