local module = {}

module.newAnimation = function(image, width, height, duration)
  local animation = {}

  animation.spriteSheet = image;
  animation.quads = {};

  for y = 0, image:getHeight() - height, height do
    for x = 0, image:getWidth() - width, width do
      table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
    end
  end

  animation.duration = duration or 1
  animation.currentTime = 0

  return animation
end

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
  animation.currentTime = 0

  return animation;
end

return module
