local asset_conf = require('asset_conf')
local collision = require('collision')
local viewport = require('viewport')
local timer = require('timer')
local crazy88 = require('entities/crazy88')
local gogo = require('entities/gogo')
local state = require('state')
local input = require('input')

local crazy88_spawn = timer(1/2,
function()
  if state.crazy88_count >= 10 or love.math.random() < 0.5 then
    return
  end

  local lx, rx = viewport:spaceLeftRight(0.5)

  if lx == -1 and rx == -1 then
    return
  end

  if lx ~= -1 and rx ~= -1 then
    if love.math.random() < 0.5 then
      x = lx
    else
      x = rx
    end
  elseif lx ~= -1 then
    x = lx
  else
    x = rx
  end

  local entity = crazy88(x, asset_conf.floor_bottom)

  table.insert(state.entities, entity)
  state.crazy88_count = state.crazy88_count + 1
end)

local gogo_spawn = timer(3,
function()
  if state.gogo_count >= 2 or love.math.random() < 0.2 then
    return
  end

  local lx, rx = viewport:spaceLeftRight(0.5)

  if lx == -1 and rx == -1 then
    return
  end

  if lx ~= -1 and rx ~= -1 then
    if love.math.random() < 0.5 then
      x = lx
    else
      x = rx
    end
  elseif lx ~= -1 then
    x = lx
  else
    x = rx
  end

  local entity = gogo(x, asset_conf.floor_bottom)

  table.insert(state.entities, entity)
  state.gogo_count = state.gogo_count + 1
end)

local game_states = {}

game_states.level_starting = {
  timeAccumulated = 0,
  enter = function(self)
    self.timeAccumulated = 0
    state.hero:startWalking()
  end,

  exit = function(self)
  end,

  update = function(self, logic, dt)
    self.timeAccumulated = self.timeAccumulated + dt
    if self.timeAccumulated >= asset_conf.levelStartDuration then
      logic:moveState(game_states.level_playing)
      return
    end

    local dx = dt * 
      ((state.current_level.start.sx - state.current_level.start.ix)/asset_conf.levelStartDuration)

    state.hero:move(dx, 0)
  end,

  draw = function(self, logic)
  end,

  keypressed = function(self, pressed_key)
  end,

  keyreleased = function(self, released_key)
  end,
}

game_states.level_playing = {
  enter = function(self)
    state.hero:setPos(state.current_level.start.sx, state.current_level.start.sy)
    state.hero:stopWalking()
    crazy88_spawn:start()
    gogo_spawn:start()
  end,

  exit = function(self)
    crazy88_spawn:stop()
    gogo_spawn:stop()
  end,

  update = function(self, logic, dt)
    input.update(dt)

    local hero = state.hero

    for _, entity in ipairs(state.entities) do

      -- hero attack test
      if hero.vHitQuad ~= nil and entity ~= hero then
        if collision.check_entity_for_hit(entity, hero.vHitQuad) then
          entity:takeHit(hero, hero.vHitQuad)
        end
      end

      -- enemy attack test
      if entity ~= hero then
        if collision.check_entity_for_hit(hero, entity.vQuad) then
          entity:collideWithHero(hero)
        end
      end
    end

    crazy88_spawn:update(dt)
    gogo_spawn:update(dt)
  end,

  draw = function(self, logic)
  end,

  keypressed = function(self, pressed_key)
    input.press(pressed_key)
  end,

  keyreleased = function(self, released_key)
    input.release(released_key)
  end,
}

game_states.level_finishing = {
  enter = function(self)
  end,

  exit = function(self)
  end,

  update = function(self, logic, dt)
  end,

  draw = function(self, logic)
  end,

  keypressed = function(self, pressed_key)
  end,

  keyreleased = function(self, released_key)
  end,
}

local gamelogic = {
  state = nil,

  update = function(self, dt)
    self.state:update(self, dt)
  end,

  draw = function(self)
    self.state:update(self)
  end,

  moveState = function(self, newstate)
    if self.state then
      self.state:exit()
    end

    self.state = newstate

    self.state:enter()
  end,

  keypressed = function(self, pressed_key)
    self.state:keypressed(pressed_key)
  end,

  keyreleased = function(self, released_key)
    self.state:keyreleased(released_key)
  end,

  reset = function(self)
    self:moveState(game_states.level_starting)
  end
}

return gamelogic
