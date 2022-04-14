local asset_conf = require('asset_conf')

local target_width = 800
local target_height = 600
local num_segments = 7


return function(level)
  local conf = asset_conf.level[level]
  local background = love.graphics.newImage(conf.background)
  local width_per_screen = conf.background_width / num_segments
  local height_per_screen = conf.background_height
  local quad = love.graphics.newQuad(
    width_per_screen * (num_segments - 1),
    0,
    width_per_screen,
    height_per_screen,
    background:getDimensions()
  )
  local sx = target_width / width_per_screen
  local sy = target_height / height_per_screen

  local floor = {
    background = background,
    quad = quad,
    update = function(self, dt)
    end,

    draw = function(self)
      love.graphics.draw(self.background, self.quad, 0, 0, 0, sx, sy)
    end,
  }

  return floor
end
