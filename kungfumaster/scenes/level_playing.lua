local asset_conf = require('asset_conf')
local collision = require('collision')
local viewport = require('viewport')
local timer = require('timer')
local factory = require('factory')

local state = require('state')
local input = require('input')

local level_common = require('scenes/level_common')

return function()
  local scene = {
    name = "level_playing",

    enter = function(self)
      state.hero:setPos(state.current_level.start.sx, state.current_level.start.sy)
      state.hero:stopWalking()

      for _, obj in ipairs(state.current_level.objs) do
        obj:start()
      end
    end,

    exit = function(self)
      for _, obj in ipairs(state.current_level.objs) do
        obj:stop()
      end
    end,

    update = function(self, dt)
      input.update(dt)

      local hero = state.hero

      for _, entity in ipairs(state.entities) do

        -- hero attack test
        if hero.vHitQuad ~= nil and entity ~= hero then
          if collision.check_entity_for_hit(entity, hero.vHitQuad) then
            entity:takeHit(hero, hero.vHitQuad)
          end
        end

        -- enemy attack test
        if entity ~= hero then
          if collision.check_entity_for_hit(hero, entity.vQuad) then
            entity:collideWithHero(hero)
          end
        end
      end

      for _, obj in ipairs(state.current_level.objs) do
        obj:update(dt)
      end

      if state.hero_energy == 0 then
        state:changeScene(factory.scenes.hero_falling())
        return
      end

      level_common.update(dt)
    end,

    draw = function(self)
      level_common.draw()
    end,

    keypressed = function(self, pressed_key)
      input.press(pressed_key)
    end,

    keyreleased = function(self, released_key)
      input.release(released_key)
    end,
  }
  return scene
end
