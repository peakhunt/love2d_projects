local asset_conf = require('asset_conf')
local state = require('state')
local viewport = require('viewport')
local hero = require('entities/hero')

return function(level)
  local conf = asset_conf.level[level]
  local background = love.graphics.newImage(conf.background)
  local levelSize = conf.size
  local start = conf.start
  local limit = conf.limit

  local floor = {
    background = background,
    levelSize = levelSize,
    start = start,
    limit = limit,

    update = function(self, dt)
    end,

    draw = function(self)
      love.graphics.draw(self.background, viewport.quad, 0, 600/5, 0, viewport.sx, viewport.sy)
    end,

    heroMove = function(self, hx, hy)
      local far_left_x, far_right_x
      
      far_left_x = hx - viewport.viewport.width / 2;
      far_right_x = hx + viewport.viewport.width / 2;

      if far_left_x > 0 and far_right_x < levelSize.width then
        viewport:updateX(far_left_x)
      end
    end,
  }

  state:reset()

  state.hero = hero(conf.start.x, conf.start.y)
  table.insert(state.entities, state.hero)
  state.level = level
  state.current_level = floor

  state.hero.forward = conf.forward

  local vp = {
    x = conf.viewport.x,
    y = conf.viewport.y,
    width = conf.viewport.width,
    height = conf.viewport.height,
  }

  viewport:init(vp, levelSize, background:getPixelWidth(), background:getPixelHeight())

  return floor
end
