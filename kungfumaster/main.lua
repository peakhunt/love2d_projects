local world = require('world')
local entities = require('entities')
local asset_conf = require('asset_conf')

function love.load()
end

function love.draw()
  love.graphics.setBackgroundColor(115/255, 27/255, 135/255, 1)

  for _, entity in ipairs(entities) do
    if entity.draw then
      entity:draw()
     end
  end
end

function love.focus(focused)
end

function love.keypressed(pressed_key)
end

function love.keyreleased(released_key)
end

function love.update(dt)
  local index = 1

  while index <= #entities do
    local entity = entities[index]

    if entity.update then
      entity:update(dt)
    end

    index = index + 1
  end

  world:update(dt)
end
