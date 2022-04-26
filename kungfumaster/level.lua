local asset_conf = require('asset_conf')
local state = require('state')
local viewport = require('viewport')
local hero = require('entities/hero')
local resource = require('resource')

return function(level)
  local conf = asset_conf.level[level]
  local background = love.graphics.newImage(conf.background)
  local levelSize = conf.size
  local start = conf.start
  local limit = conf.limit
  local doors = conf.doors

  if doors ~= nil then
    doors.love2d_quads = {}
    for _, quad in ipairs(doors.quads) do
      table.insert(doors.love2d_quads,
        love.graphics.newQuad(
          quad.pos_x,
          quad.pos_y,
          quad.width,
          quad.height,
          resource[doors.sprite]:getDimensions()
        )
      )
    end
  end

  local floor = {
    background = background,
    levelSize = levelSize,
    start = start,
    limit = limit,
    doors = doors,

    update = function(self, dt)
    end,

    draw = function(self)
      love.graphics.draw(self.background, viewport.quad, 
          viewport.screen.x, viewport.screen.y,
          0, viewport.sx, viewport.sy)

      --
      -- FIXME fix it later using level start-up state machine
      --
      if self.doors ~= nil then
        local px, py
        local scale_x, scale_y
        local sQuad = self.doors.love2d_quads[1]

        px, py = viewport:virtualPointToScreenCoord(self.doors.pos.x, self.doors.pos.y)
        scale_x, scale_y = viewport:getScaleFactor(self.doors.pos, sQuad)

        love.graphics.draw(resource[self.doors.sprite], sQuad,
          px, py, 0,
          scale_x, scale_y)
      end
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
