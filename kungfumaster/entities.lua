--
-- import anything you want
--
local hero = require('entities/hero')
local crazy88 = require('entities/crazy88')

local entities = {
  crazy88(300, 400),
  hero(150, 400),
}

return entities
