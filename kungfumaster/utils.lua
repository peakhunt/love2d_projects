local module = {}

module.newAnimationFromConf = function(image, conf)
  local animation = {}

  animation.spriteSheet = image;
  animation.quads = {}

  for _, quad in ipairs(conf.quads) do
    table.insert(animation.quads,
      love.graphics.newQuad(
        quad.pos_x,
        quad.pos_y,
        quad.width,
        quad.height,
        image:getDimensions()
      )
    )
  end

  animation.duration = conf.duration

  return animation;
end

module.drawAnimation = function(anim, currentTime, x, y, rotation, scale_x, scale_y)
  local spriteNum = math.floor(currentTime / anim.duration * #anim.quads) + 1
  local _,_,_,h = anim.quads[spriteNum]:getViewport()
  local px, py

  px = x
  py = y - h * scale_y

  love.graphics.draw(anim.spriteSheet, anim.quads[spriteNum], px, py, rotation, scale_x, scale_y)
end

return module
