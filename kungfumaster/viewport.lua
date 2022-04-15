local window_width = 800;
local window_height = 600;

--
-- 4/5 of the screen height
-- 
local screenTarget = {
  x = 0,
  y = window_height / 5,
  width = 800,
  height = window_height * 4 / 5 - 20,
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

local quad

return {
  quad = nil,
  pixel_width_per_viewport = 0,
  pixel_height_per_viewport = 0,
  sx = 0,
  sy = 0,
  viewport = viewPort,
  init = function(self, levelSize, background_width, background_height)
    self.pixel_width_per_viewport = background_width * (self.viewport.width/levelSize.width)
    self.pixel_height_per_viewport = background_height * (self.viewport.height / levelSize.height)
    self.quad = love.graphics.newQuad(
      self.pixel_width_per_viewport * self.viewport.x,
      0,
      self.pixel_width_per_viewport,
      self.pixel_height_per_viewport,
      background_width,
      background_height
    )
    self.sx = screenTarget.width / self.pixel_width_per_viewport
    self.sy = screenTarget.height / self.pixel_height_per_viewport
  end,
  updateViewQuad = function(self)
    local _, y, w, h = self.quad:getViewport()
    self.quad:setViewport(self.viewport.x * self.pixel_width_per_viewport, y, w, h)
  end,
  updateX = function(self, x)
    self.viewport.x = x
    self:updateViewQuad()
  end,
}
