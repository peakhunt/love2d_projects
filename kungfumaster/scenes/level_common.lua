local state = require('state')
local viewport = require('viewport')
local dashboard = require('dashboard')

function debug_draw()
  if state.button_debug == false then
    return
  end

  love.graphics.setColor(0, 0, 0, 1)
  -- Draw the current FPS.
  love.graphics.print("FPS: " .. love.timer.getFPS(), 50, 150)
  -- Draw the current delta-time. (The same value
  -- is passed to update each frame).
  love.graphics.print("dt: " .. love.timer.getDelta(), 50, 170)
  love.graphics.print("z: kick, x: punch, arrow keys for move, space: debug", 50, 190)
  love.graphics.print("scene:" .. state.scene.name, 50, 210)

  love.graphics.setColor(1, 0, 0, 1)

  love.graphics.line(viewport.screen.x + viewport.screen.width / 2 - 1,
                     viewport.screen.y,
                     viewport.screen.x + viewport.screen.width / 2 - 1,
                     viewport.screen.y + viewport.screen.height - 1)

  love.graphics.line(viewport.screen.x ,
                     viewport.screen.y + viewport.screen.height/2 -1,
                     viewport.screen.x + viewport.screen.width - 1,
                     viewport.screen.y + viewport.screen.height/2 -1)
  love.graphics.setColor(1, 1, 1, 1)
end

function gameplay_common_draw()
  state.current_level:draw()

  for _, entity in ipairs(state.entities) do
    if viewport:isVisible(entity) and entity.draw then
      entity:draw()
     end
  end

  for _, entity in ipairs(state.scores) do
    entity:draw()
  end

  state.current_level:drawF()

  dashboard.draw()
  debug_draw()
end

function update_test(dt)
  if state.test_enabled == false then
    return
  end

  state.time_left = state.time_left - dt
  if state.time_left < 0 then
  state.time_left = 0
  end

  state.hero_energy = state.hero_energy + love.math.random(-30, 30) * dt
  if state.hero_energy < 0 then
    state.hero_energy = 0
  end
  if state.hero_energy > 100 then
    state.hero_energy = 100 
  end
  state.enemy_energy = state.enemy_energy + love.math.random(-30, 30) * dt
  if state.enemy_energy < 0 then
    state.enemy_energy = 0
  end
  if state.enemy_energy > 100 then
    state.enemy_energy = 100
  end
  state.score = state.score + love.math.random(-300, 300) * dt
  if state.score < 0 or state.score > 999999 then
    state.score = 0
  end
end

function gameplay_common_update(dt)
  if state.paused or dt > 0.1 then
    return
  end

  local index = 1

  update_test(dt)

  while index <= #state.entities do
    local entity = state.entities[index]
    if entity.update then
      entity:update(dt)
    end

    if entity.health == 0 then
      table.remove(state.entities, index)
    else
      index = index + 1
    end
  end

  index = 1
  while index <= #state.scores do
    local entity = state.scores[index]
    if entity.update then
      entity:update(dt)
    end

    if entity.dead then
      table.remove(state.scores, index)
    else
      index = index + 1
    end
  end

  state.current_level:update(dt)
  viewport:update(dt)
  dashboard.update(dt)
end

return {
  draw = gameplay_common_draw,
  update = gameplay_common_update,
}
