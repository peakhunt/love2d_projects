local asset_conf = require('asset_conf')
local state = require('state')
local viewport = require('viewport')
local resource = require('resource')
local factory = require('factory')
local crazy88_spawn = require('crazy88_spawn')
local gogo_spawn = require('gogo_spawn')

local door_left = factory.entities.door(true)
local door_right = factory.entities.door(false)

function setup_hero(x, y, forward)
  state.hero = factory.entities.hero(x, y)
  state.hero.forward = forward
  table.insert(state.entities, state.hero)
end

return function(level)
  local conf = asset_conf.level[level]
  local background = love.graphics.newImage(conf.background)
  local foreground = love.graphics.newImage(conf.foreground)

  local levelSize = conf.size
  local start = conf.start
  local limit = conf.limit
  local objs = {}
  local vp = {
    x = conf.viewport.x,
    y = conf.viewport.y,
    width = conf.viewport.width,
    height = conf.viewport.height,
  }

  --
  -- create game objs, aka, spawner
  --
  for _, obj in ipairs(conf.objs) do
    if obj.name == "crazy88" then
      table.insert(objs, crazy88_spawn(obj.config))
    elseif obj.name == "gogo" then
      table.insert(objs, gogo_spawn(obj.config))
    end
  end

  local floor = {
    background = background,
    foreground = foreground,
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
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(self.background, viewport.quad, 
          viewport.screen.x, viewport.screen.y,
          0, viewport.sx, viewport.sy)

      if self.current_door then
        self.current_door:draw()
      end
    end,

    drawF = function(self)
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(self.foreground, viewport.quad, 
          viewport.screen.x, viewport.screen.y,
          0, viewport.sx, viewport.sy)
    end,

    restart = function(self)
      setup_hero(conf.start.ix, conf.start.iy, conf.forward)
      viewport:updateX(conf.viewport.x)
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

  setup_hero(conf.start.ix, conf.start.iy, conf.forward)
  state.level = level
  state.current_level = floor

  viewport:init(vp, levelSize, background:getDimensions())

  return floor
end
