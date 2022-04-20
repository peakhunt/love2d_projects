local entities = require('entities')

-------------------------------------------------
--
-- x1, y1 : top left corner of q1
-- x2, y2 : top left corner of q2
-- XXX: remember! this is in virtual coordinate space
--      not in screen coordinate!
--
-------------------------------------------------
function check_collision(x1,y1,w1,h1,x2,y2,w2,h2)
  return x1 < x2+w2 and       -- left of A < right of B
         x2 < x1+w1 and       -- left of B < right of A
         y1 > y2-h2 and       -- top of A > bottom of B
         y2 > y1-h1           -- top of B > bottom of A
end

function check_entity_for_hit(entity, hit)
  return check_collision(
      entity.vQuad.x, entity.vQuad.y,
      entity.vQuad.width, entity.vQuad.height,
      hit.x, hit.y,
      hit.width, hit.height)
end

return {
  update = function(dt)
    local hero = entities.hero

    if hero.vHitQuad == nil then
      return
    end

    for _, entity in pairs(entities) do
      if entity ~= hero then
        if check_entity_for_hit(entity, hero.vHitQuad) then
          print(dt, 'hit hit hit: ', entity.name)
        end
      end
    end
  end,
}
