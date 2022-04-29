local asset_conf = require('asset_conf')
local state = require('state')
local viewport = require('viewport')
local hero = require('entities/hero')
local resource = require('resource')
local door = require('entities/door')
local crazy88_spawn = require('crazy88_spawn')

local door_left = door(true)
local door_right = door(false)

return function(level)
  local conf = asset_conf.level[level]
  local background = love.graphics.newImage(conf.background)
  local levelSize = conf.size
  local start = conf.start
  local limit = conf.limit
  local objs = {}

  --
  -- create game objs, aka, spawner
  --
  for _, obj in ipairs(conf.objs) do
    if obj.name == "crazy88" then
      table.insert(objs, crazy88_spawn(obj.config))
    end
  end

  local floor = {
    background = background,
    levelSize = levelSize,
    start = start,
    limit = limit,
    current_door = nil,
    objs = objs,

    update = function(self, dt)
      if self.current_door then
        self.current_door:update(dt)
      end
    end,

    draw = function(self)
      love.graphics.draw(self.background, viewport.quad, 
          viewport.screen.x, viewport.screen.y,
          0, viewport.sx, viewport.sy)

      if self.current_door then
        self.current_door:draw()
      end
    end,

    heroMove = function(self, hx, hy)
      local far_left_x, far_right_x
      
      far_left_x = hx - viewport.viewport.width / 2;
      far_right_x = hx + viewport.viewport.width / 2;

      if far_left_x > 0 and far_right_x < self.levelSize.width then
        viewport:updateX(far_left_x)
      end
    end,
  }
      
  if conf.door == 'left' then
    floor.current_door = door_left
    floor.current_door:reset()
  elseif conf.door == 'right' then
    floor.current_door = door_right
    floor.current_door:reset()
  else
    floor.current_door = nil
  end

  state:reset()

  state.hero = hero(conf.start.ix, conf.start.iy)
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
