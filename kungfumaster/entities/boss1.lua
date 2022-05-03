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

states.standing = {
  animation = animations.standing,
  update = function(self, entity, dt)
    if state.boss_activated == true then
      entity.timeAccumulated = entity.timeAccumulated + dt
      if entity.timeAccumulated > 2 then
        entity.timeAccumulated = 0
        entity:moveState(states.walking)
      end
    else
      local _, adistance = gameutil.distance(entity, state.hero)

      if adistance <= 0.4 then
        state.boss_activated = true
      end
    end

    entity:commonUpdate(dt)
  end,
}

states.walking = {
  animation = animations.walking,
  update = function(self, entity, dt)
    entity.timeAccumulated = entity.timeAccumulated + dt
    if entity.timeAccumulated > 2 then
      entity.timeAccumulated = 0
      entity:moveState(states.standAttackHigh)
    end

    entity:commonUpdate(dt)
  end,
}

states.standAttackHigh = {
  animation = animations.standAttackHigh,
  update = function(self, entity, dt)
    entity.timeAccumulated = entity.timeAccumulated + dt
    if entity.timeAccumulated > 2 then
      entity.timeAccumulated = 0
      entity:moveState(states.standAttackMid)
    end

    entity:commonUpdate(dt)
  end,
}

states.standAttackMid = {
  animation = animations.standAttackMid,
  update = function(self, entity, dt)
    entity.timeAccumulated = entity.timeAccumulated + dt
    if entity.timeAccumulated > 2 then
      entity.timeAccumulated = 0
      entity:moveState(states.sitting)
    end

    entity:commonUpdate(dt)
  end,
}

states.sitting = {
  animation = animations.sitting,
  update = function(self, entity, dt)
    entity.timeAccumulated = entity.timeAccumulated + dt
    if entity.timeAccumulated > 2 then
      entity.timeAccumulated = 0
      entity:moveState(states.sitAttack)
    end

    entity:commonUpdate(dt)
  end,
}

states.sitAttack = {
  animation = animations.sitAttack,
  update = function(self, entity, dt)
    entity.timeAccumulated = entity.timeAccumulated + dt
    if entity.timeAccumulated > 2 then
      entity.timeAccumulated = 0
      entity:moveState(states.hit1)
    end

    entity:commonUpdate(dt)
  end,
}

states.hit1 = {
  animation = animations.hit1,
  update = function(self, entity, dt)
    entity.timeAccumulated = entity.timeAccumulated + dt
    if entity.timeAccumulated > 2 then
      entity.timeAccumulated = 0
      entity:moveState(states.hit2)
    end

    entity:commonUpdate(dt)
  end,
}

states.hit2 = {
  animation = animations.hit2,
  update = function(self, entity, dt)
    entity.timeAccumulated = entity.timeAccumulated + dt
    if entity.timeAccumulated > 2 then
      entity.timeAccumulated = 0
      entity:moveState(states.hit3)
    end

    entity:commonUpdate(dt)
  end,
}

states.hit3 = {
  animation = animations.hit3,
  update = function(self, entity, dt)
    entity.timeAccumulated = entity.timeAccumulated + dt
    if entity.timeAccumulated > 2 then
      entity.timeAccumulated = 0
      entity:moveState(states.hit4)
    end

    entity:commonUpdate(dt)
  end,
}

states.hit4 = {
  animation = animations.hit4,
  update = function(self, entity, dt)
    entity.timeAccumulated = entity.timeAccumulated + dt
    if entity.timeAccumulated > 2 then
      entity.timeAccumulated = 0
      entity:moveState(states.hit5)
    end

    entity:commonUpdate(dt)
  end,
}

states.hit5 = {
  animation = animations.hit5,
  update = function(self, entity, dt)
    entity.timeAccumulated = entity.timeAccumulated + dt
    if entity.timeAccumulated > 2 then
      entity.timeAccumulated = 0
      entity:moveState(states.falling)
    end

    entity:commonUpdate(dt)
  end,
}

states.falling = {
  animation = animations.falling,
  update = function(self, entity, dt)
    entity.timeAccumulated = entity.timeAccumulated + dt
    if entity.timeAccumulated > 2 then
      entity.timeAccumulated = 0
      entity:moveState(states.standing)
    end

    entity:commonUpdate(dt)
  end,
}

return function(pos_x, pos_y)
  local entity = entity_common(pos_x, pos_y, states, animations, states.standing)

  entity.name = "boss1"
  entity.restrainPos = true
  entity.score = 200
  entity.timeAccumulated = 0

  return entity
end
