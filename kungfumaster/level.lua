local asset_conf = require('asset_conf')
local state = require('state')

local window_width = 800;
local window_height = 600;

--
-- 4/5 of the screen height
-- 
local screenTarget = {
  x = 0,
  y = window_height / 5,
  width = 800,
  height = window_height * 4 / 5,
}

--
-- viewport width is 1/7 of the total background image
--
local viewPort = {
  width = 1.0,
  height = 1.0,
  x = 6.0,
  y = 0,
}

--
-- virtual world is 7.0 width and 1.0 height
-- x grows from left to right
--
local levelSize = {
  width = 7.0,
  height = 1.0,
}

--
-- we should be able to move from end to end in 30 seconds
--
local move_speed = levelSize.width / 30

return function(level)
  local conf = asset_conf.level[level]
  local background = love.graphics.newImage(conf.background)

  local pixel_width_per_viewport = background:getPixelWidth() * (viewPort.width/levelSize.width)
  local pixel_height_per_viewport = background:getPixelHeight() * (viewPort.height / levelSize.height)

  local quad = love.graphics.newQuad(
    pixel_width_per_viewport * viewPort.x,
    0,
    pixel_width_per_viewport,
    pixel_height_per_viewport,
    background:getDimensions()
  )

  local sx = screenTarget.width / pixel_width_per_viewport
  local sy = screenTarget.height / pixel_height_per_viewport

  local floor = {
    background = background,
    quad = quad,
    updateViewQuad = function(self)
      local _, y, w, h = self.quad:getViewport()
      self.quad:setViewport(viewPort.x * pixel_width_per_viewport, y, w, h)
    end,
    update = function(self, dt)
      if state.button_left then
        viewPort.x = viewPort.x - move_speed * dt
        self:updateViewQuad()
      elseif state.button_right then
        local x, y, w, h = self.quad:getViewport()

        viewPort.x = viewPort.x + move_speed * dt
        self:updateViewQuad()
      end
    end,

    draw = function(self)
      love.graphics.draw(self.background, self.quad, 0, 600/5, 0, sx, sy)
    end,
  }

  return floor
end
