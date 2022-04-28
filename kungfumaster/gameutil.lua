return {
  distance = function(ea, eb)
    local d = ea.vQuad.x - eb.vQuad.x

    return d, math.abs(d)
  end,
}
