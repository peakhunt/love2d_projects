local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')
local resource = require('resource')
local viewport = require('viewport')

return function(vx, vy, score)
  local entity = {
    score = string.format("%d", score),
    vx = vx,
    vy = vy,
    timeAccumulated = 0,
    dead = false,

    update = function(self, dt)
      self.timeAccumulated = self.timeAccumulated + dt

      if self.timeAccumulated > 1 then
        self.dead = true
      end
    end,

    draw = function(self)
      local px, py = viewport:virtualPointToScreenCoord(self.vx, self.vy)

      love.graphics.setColor(love.math.colorFromBytes(0xff, 0xa5, 0x00))
      love.graphics.print(self.score, resource.font, px, py)
    end,
  }

  return entity
end
