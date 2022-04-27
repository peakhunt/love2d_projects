local asset_conf = require('asset_conf')

local spriteSheet = love.graphics.newImage(asset_conf.spriteSheet)
local doorSprite = love.graphics.newImage(asset_conf.doorSprite)
local font = love.graphics.newFont("assets/arcadeclassic.ttf", 20)
local font_small = love.graphics.newFont("assets/arcadeclassic.ttf", 15)
local font_big = love.graphics.newFont("assets/arcadeclassic.ttf", 25)

return {
  spriteSheet = spriteSheet,
  doorSprite = doorSprite,
  font = font,
  font_small = font_small,
  font_big = font_big,
}
