local asset_conf = require('asset_conf')
local state = require('state')
local viewport = require('viewport')

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

  viewport:init(levelSize, background:getPixelWidth(), background:getPixelHeight())

  local floor = {
    background = background,
    update = function(self, dt)
      if state.button_left then
        local x = viewport.viewport.x

        x = x - move_speed * dt
        viewport:updateX(x)
      elseif state.button_right then
        local x = viewport.viewport.x

        x = x + move_speed * dt
        viewport:updateX(x)
      end
    end,

    draw = function(self)
      love.graphics.draw(self.background, viewport.quad, 0, 600/5, 0, viewport.sx, viewport.sy)
    end,
  }

  return floor
end
