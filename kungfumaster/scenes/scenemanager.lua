--
-- actually I really didn't wanna create another object for scene management.
-- simply, this could be put into state
-- but because of circular require hell, I'm doing it this way
--
local state = require('state')

local constructors = {
  hero_falling = require('scenes/hero_falling'),
  level_finishing = require('scenes/level_finishing'),
  level_playing = require('scenes/level_playing'),
  level_starting = require('scenes/level_starting'),
}

local manager = {
  currentScene = nil,
}

manager.scenes = {
  hero_falling = constructors['hero_falling'](manager),
  level_finishing = constructors['level_finishing'](manager),
  level_playing = constructors['level_playing'](manager),
  level_starting = constructors['level_starting'](manager),
}

manager.changeScene = function(self, scene)
  if self.currentScene ~= nil then
    self.currentScene:exit()
  end

  self.currentScene = self.scenes[scene]
  state.scene = scene

  if self.currentScene ~= nil then
    self.currentScene:enter()
  end
end

manager.reset = function(self)
  self:changeScene('level_starting')
end

manager.update = function(self, dt)
  self.currentScene:update(dt)
end

manager.draw = function(self)
  self.currentScene:draw()
end

manager.keypressed = function(self, pressed_key)
  self.currentScene:keypressed(pressed_key)
end

manager.keyreleased = function(self, released_key)
  self.currentScene:keyreleased(released_key)
end

return manager
