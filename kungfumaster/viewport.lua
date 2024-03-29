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
local asset_conf = require('asset_conf')
local collision = require('collision')
local state = require('state')
local window_width = asset_conf.screen_width
local window_height = asset_conf.screen_height

--
-- 4/5 of the screen height
-- 
local screenTarget = {
  x = 0,
  y = window_height / 5,
  width = window_width,
  height = window_height * 4 / 5 - 20,
}

local dashboardTarget = {
  x = 0,
  y = 0,
  width = window_width,
  height = window_height / 5,
}

--
-- viewport width is 1/7 of the total background image
--
local quad

return {
  quad = nil,
  pixel_width_per_viewport = 0,
  pixel_height_per_viewport = 0,
  sx = 0,
  sy = 0,
  levelSize = nil,
  viewport = nil,
  screen = screenTarget,
  dashboard = dashboardTarget,

  -- initialize viewport object
  init = function(self, viewport, levelSize, background_width, background_height)
    self.viewport = viewport
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

  update = function(self)
    local far_left_x, far_right_x
    
    far_left_x = state.hero.pos.x - self.viewport.width / 2;
    far_right_x = state.hero.pos.x + self.viewport.width / 2;

    if far_left_x > 0 and far_right_x < self.levelSize.width then
      self:updateX(far_left_x)
    end
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

    return self:virtualPointToScreenCoord(vx, vy)
  end,

  virtualPointToScreenCoord = function(self, vx, vy)
    local sx, sy

    -- FIXME: let me think about this. virtual 1 doesn't have to be the exact end of screen pixel!
    -- x:0 --> screen.x
    -- x:1 --> screen.x + screen.width - 1
    -- y:0 --> screen.y + screen.height - 1
    -- y:1 --> screen.y
    sx = screenTarget.x + (vx - self.viewport.x) * (screenTarget.width - 1)
    sy = (self.viewport.y - vy) * (screenTarget.height - 1) + screenTarget.y

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

  spaceLeftRight = function(self, delta)
    local lx, rx
    
    lx = self.viewport.x - self.viewport.width + delta
    rx = self.viewport.x + self.viewport.width + delta

    -- FIXME addhoc
    if lx < 0 or lx >= 7.0 then
      lx = -1
    end

    if rx < 0 or rx >= 7.0 then
      rx = -1
    end

    return lx, rx
  end,
}
