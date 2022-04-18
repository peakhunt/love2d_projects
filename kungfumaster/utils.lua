local state = require('state')
local viewport = require('viewport')

local module = {}
local debug_rect = true

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

module.drawAnimation = function(anim, currentTime, x, y, rotation, forward)
  local spriteNum = math.floor(currentTime / anim.duration * #anim.quads) + 1
  if spriteNum > #anim.quads or spriteNum < 1 then
    -- print('BUG: spriteNum bigger than quads:', spriteNum, #anim.quads)
    -- return
    spriteNum = 1
  end

  local _,_,w,h = anim.quads[spriteNum]:getViewport()
  local px, py

  -- px, py is bottom left corener of the rectangle
  px, py = viewport:toScreenTop(x, y, anim.virtSize[spriteNum])

  -- calculate scale factor
  local scale_x, scale_y

  scale_x, scale_y = viewport:getScaleFactor(anim.virtSize[spriteNum], anim.quads[spriteNum])

  if forward then
    scale_x = -scale_x
  end

  love.graphics.draw(anim.spriteSheet, anim.quads[spriteNum], px, py, rotation, scale_x, scale_y)

  if state.button_debug then
    local w, h = viewport:toScreenDim(anim.virtSize[spriteNum])

    if forward then
      w = -w
    end

    local r,g,b,a =  love.graphics.getColor()
    love.graphics.setColor(1.0, 0, 0, 1)
    love.graphics.rectangle("line", px, py, w, h)
    love.graphics.setColor(r, g, b, a)
  end
end

return module
