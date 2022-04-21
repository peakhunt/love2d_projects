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

return {
  check_entity_for_hit = function(entity, hit)
    return check_collision(
        entity.vQuad.x, entity.vQuad.y,
        entity.vQuad.width, entity.vQuad.height,
        hit.x, hit.y,
        hit.width, hit.height)
  end,

  check_quad_for_quad = function(a, b)
    return check_collision(
        a.x, a.y,
        a.width, a.height,
        b.x, b.y,
        b.width, b.height)
  end,
}
