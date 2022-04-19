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

    local virtWidth = (quad.width / refFrame.pixelwidth) * refFrame.width
    local virtHeight = (quad.height / refFrame.pixelheight) * refFrame.height

    local hitPoint = nil

    if quad.hitPoint then
      local vw, vh

      -- calculating w/h in virtual unit is easy
      vw = (quad.hitPoint.width / refFrame.pixelwidth) * refFrame.width
      vh = (quad.hitPoint.height / refFrame.pixelheight) * refFrame.height

      --
      -- virtual quad has virtWidth x virtHeight size
      -- let's define top/left as (0, 0)
      -- and bottom/right as (virtWidth, virtHeight)
      -- then we need to convert sprite coordinate to this virtual quad coordinate
      --
      local rx, ry      -- relative x, y

      rx = ((quad.hitPoint.pos_x - quad.pos_x)/quad.width) * virtWidth
      ry = ((quad.hitPoint.pos_y - quad.pos_y)/quad.height) * virtHeight

      hitPoint = {
        rx = rx,
        ry = ry,
        width = vw,
        height = vh,
      }
    end

    table.insert(animation.virtSize, {
      width = virtWidth,
      height = virtHeight,
      hitPoint = hitPoint,
    })
  end

  animation.duration = conf.duration

  return animation;
end

return module
