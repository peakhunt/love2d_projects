local asset_conf = require('asset_conf')

local spriteSheet = love.graphics.newImage(asset_conf.spriteSheet)

return {
  spriteSheet = spriteSheet,
}
