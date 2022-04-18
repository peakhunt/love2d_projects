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
  levelSize = nil,
  viewport = viewPort,
  init = function(self, levelSize, background_width, background_height)
    self.levelSize = levelSize
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
    if x < 0 or x > (self.levelSize.width - viewPort.width) then
      return
    end
    self.viewport.x = x
    self:updateViewQuad()
  end,
  isWithin = function(self, x, y, w, h)
    -- FIXME
    return true
  end,
  toScreenTop = function(self, vx, vy, vQuad)
    local sx, xy

    -- vx, vy are bottom left corner
    -- we need top left corner
    vy = vy + vQuad.height
    sx = screenTarget.x + (vx - self.viewport.x) * screenTarget.width
    sy = screenTarget.height - (vy - self.viewport.y) * screenTarget.height + screenTarget.y

    return sx, sy
  end,
  toScreenDim = function(self, vQuad)
    local width, height

    width = vQuad.width * screenTarget.width
    height = vQuad.height * screenTarget.height

    return width, height
  end,
  getScaleFactor = function(self, vQuad, sQuad)
    local _, _, sw, sh = sQuad:getViewport()
    local w = vQuad.width * screenTarget.width
    local h = vQuad.height * screenTarget.height

    return w/sw, h/sh
  end,
}
