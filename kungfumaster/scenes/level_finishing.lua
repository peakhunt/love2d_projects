local asset_conf = require('asset_conf')
local collision = require('collision')
local viewport = require('viewport')
local timer = require('timer')
local state = require('state')
local input = require('input')
local factory = require('factory')

return function()
  local scene = {
    name = "level_finishing",
    manager = nil,

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
  return scene
end
