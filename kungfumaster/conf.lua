-- conf.lua
-- love2D configuration file
local asset_conf = require('asset_conf')

love.conf = function(t)
  t.console = true
  t.window.width = asset_conf.screen_width
  t.window.height = asset_conf.screen_height
end
