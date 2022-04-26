local asset_conf = require('asset_conf')

local spriteSheet = love.graphics.newImage(asset_conf.spriteSheet)
local doorSprite = love.graphics.newImage(asset_conf.doorSprite)

return {
  spriteSheet = spriteSheet,
  doorSprite = doorSprite,
}
