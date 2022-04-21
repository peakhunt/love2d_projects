local asset_conf = require('asset_conf')
local entities = require('entities')
local collision = require('collision')
local viewport = require('viewport')
local timer = require('timer')
local crazy88 = require('entities/crazy88')

local crazy88_spawn = timer(1/3,
function()
  if #entities.table > 10 or love.math.random() < 0.5 then
    return
  end

  local lx, rx = viewport:spaceLeftRight(0.5)

  if lx == -1 and rx == -1 then
    return
  end

  if lx ~= -1 and rx ~= -1 then
    if love.math.random() < 0.5 then
      x = lx
    else
      x = rx
    end
  elseif lx ~= -1 then
    x = lx
  else
    x = rx
  end

  local entity = crazy88(x, asset_conf.floor_bottom)

  table.insert(entities.table, entity)
end)

return {
  update = function(dt)
    local hero = entities.hero

    if hero.vHitQuad ~= nil then
      -- hero attacks
      for _, entity in ipairs(entities.table) do
        if entity ~= hero then
          if collision.check_entity_for_hit(entity, hero.vHitQuad) then
            entity:hit(hero.vHitQuad)
            break   -- only one hit?
          end
        end
      end
    end

    -- 
    -- enemy attacks
    -- FIXME

    --
    -- enemy spwan
    --
    crazy88_spawn:update(dt)
  end,
}
