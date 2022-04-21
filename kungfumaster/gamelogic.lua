local entities = require('entities')
local collision = require('collision')

return {
  update = function(dt)
    local hero = entities.hero

    if hero.vHitQuad == nil then
      return
    end

    for _, entity in pairs(entities) do
      if entity ~= hero then
        if collision.check_entity_for_hit(entity, hero.vHitQuad) then
          entity:hit(hero.vHitQuad)
        end
      end
    end
  end,
}
