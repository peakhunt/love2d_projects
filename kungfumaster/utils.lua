local state = require('state')
local viewport = require('viewport')

local module = {}

module.newAnimationFromConf = function(image, conf, refFrame)
  local animation = {}

  animation.spriteSheet = image;
  animation.quads = {}
  animation.virtSize = {}

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

    local virtWidth = (quad.width / refFrame.pixelwidth ) * refFrame.width
    local virtHeight = (quad.height / refFrame.pixelheight) * refFrame.height

    table.insert(animation.virtSize, {
      width = virtWidth,
      height = virtHeight,
    })
  end

  animation.duration = conf.duration

  return animation;
end

return module
