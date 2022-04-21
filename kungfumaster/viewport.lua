--------------------------------------------------------------------------------
-- some reasoning and explanation so that I can pick up later when I forget.
--
-- vitual world width is defined to be between 0 and 7
-- vitual world height is defined to be between 0 and 1
--  /\
--  | 1
--  |
--  |
--  |                          7
--  ____________________________>
--
-- And viewport is defined to be (0~1,0~1),
-- which means 1/7 of the virtual world is projected into the pixel screen
-- whatever the pixel screen resolution is.
--
-- For the world, aka, background, this is quite simple and straightforward.
-- 
-- For the entitires appearing in the world, if sprite sizes are always same,
-- things are quite simple and easy. But that's usually not the case.
--
-- So for the entities with varying sprite size, we take the following step
--
-- 1. A size in virtual world is defined for a reference sprite (usually standing or idle)
-- 2. A size in virtual world for other sprites are calculated at load time
--    with the reference sprite and its size in virtual world.
--
-- So why even go through all these hassels instead of simply using pixel dimension?
-- It's because it seems easier to me to manipulate everything in virtual world unit 
-- as of this writing.
--
--------------------------------------------------------------------------------

local collision = require('collision')
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
  x = 6.0,          -- left
  y = 1.0,          -- top
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
  screen = screenTarget,

  -- initialize viewport object
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
    if x < 0 or x > (self.levelSize.width - self.viewport.width) then
      return
    end
    self.viewport.x = x
    self:updateViewQuad()
  end,

  isVisible = function(self, entity)
    -- just for the safety. in reality, it never occurs
    if entity.vQuad == nil then
      return true
    end

    return collision.check_quad_for_quad(self.viewport, entity.vQuad)
  end,

  toScreenTopLeft = function(self, vx, vy, vQuad)
    local sx, sy

    -- vx, vy are bottom center
    -- we need top left corner
    vx = vx - vQuad.width/2
    vy = vy + vQuad.height

    -- x:0 --> screen.x
    -- x:1 --> screen.x + screen.width - 1
    -- y:0 --> screen.y + screen.height - 1
    -- y:1 --> screen.y
    sx = screenTarget.x + (vx - self.viewport.x) * (screenTarget.width-1)
    sy = (self.viewport.y - vy) * (screenTarget.height -1) + screenTarget.y

    return sx, sy
  end,

  virtualPointToScreenCoord = function(self, vx, vy)
    local sx, sy

    -- x:0 --> screen.x
    -- x:1 --> screen.x + screen.width - 1
    -- y:0 --> screen.y + screen.height - 1
    -- y:1 --> screen.y
    sx = screenTarget.x + (vx - self.viewport.x) * (screenTarget.width-1)
    sy = (self.viewport.y - vy) * (screenTarget.height-1) + screenTarget.y

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
