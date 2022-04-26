local asset_conf = require('asset_conf')

local spriteSheet = love.graphics.newImage(asset_conf.spriteSheet)
local doors = love.graphics.newImage(asset_conf.doors)

return {
  spriteSheet = spriteSheet,
  doors = doors,
}
