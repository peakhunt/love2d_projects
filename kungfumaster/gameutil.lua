return {
  distance = function(ea, eb)
    local d = ea.vQuad.x - eb.vQuad.x

    return d, math.abs(d)
  end,

  -- 
  -- A is an entity calling this function
  -- B is whatever entity but mostly hero
  --
  -- distance is negative if
  --    A  <----->    B
  -- distance is positive if
  --    B  <----->    A
  -- 0 ------------------------>7
  --
  forwardDirection = function(distance)
    if distance < 0 then
      return false
    end
    return true
  end,

  calcXDelta = function(forward, speed, dt)
    local xdelta = speed * dt

    if forward then
      xdelta = -xdelta
    end

    return xdelta
  end,

  calcFallDelta = function(forward, speed, dt)
    local xdelta, ydelta

    if forward then
      xdelta = speed * dt
    else
      xdelta = -speed * dt
    end
    ydelta = -speed * dt

    return xdelta, ydelta
  end
}
