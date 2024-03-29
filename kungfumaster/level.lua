local asset_conf = require('asset_conf')
local state = require('state')
local viewport = require('viewport')
local factory = require('factory')

local door_left = factory.entities.door(true)
local door_right = factory.entities.door(false)

function setup_boss_and_hero(conf, x, y, forward)
  --
  -- create boss if present
  --
  if conf.boss then
    local b = conf.boss
    local boss = factory.entities[b.name](b.x, b.y)

    boss.forward = not conf.forward
    table.insert(state.entities, boss)
  end

  state.hero = factory.entities.hero(x, y)
  state.hero.forward = forward
  table.insert(state.entities, state.hero)
end

function setup_entities(conf)
  for _, obj in ipairs(conf.entities) do
    if obj.type == "silvia" then
      local silvia = factory.entities.silvia(obj.pos.x, obj.pos.y)

      silvia.forward = obj.forward
      silvia:moveState(obj.state)
      state.silvia = silvia
      table.insert(state.entities, silvia)
    end
  end
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

  viewport:init(vp, levelSize, background:getDimensions())

  --
  -- create game objs, aka, spawner
  --
  for _, obj in ipairs(conf.objs) do
    if obj.name == "crazy88" then
      table.insert(objs, factory.spawns.crazy88(obj.config))
    elseif obj.name == "gogo" then
      table.insert(objs, factory.spawns.gogo(obj.config))
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
    conf = conf,
    finish = conf.finish_quad,

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

      if state.button_debug then
        local px, py = viewport:virtualPointToScreenCoord(self.finish.x, self.finish.y)
        local w, h = viewport:toScreenDim(self.finish)

        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.rectangle("line", px, py, w, h)
        love.graphics.setColor(1, 1, 1, 1)
      end
    end,

    drawF = function(self)
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(self.foreground, viewport.quad, 
          viewport.screen.x, viewport.screen.y,
          0, viewport.sx, viewport.sy)
    end,

    restart = function(self)
      state:restart()
      setup_boss_and_hero(conf, conf.start.ix, conf.start.iy, conf.forward)
      setup_entities(conf)
      state.level = level
      state.current_level = self
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

  floor:restart()

  return floor
end
