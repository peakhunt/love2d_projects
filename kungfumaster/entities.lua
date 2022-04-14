--
-- import anything you want
--
local hero = require('entities/hero')
local crazy88 = require('entities/crazy88')
local dwarf = require('entities/dwarf')
local gogo = require('entities/gogo')
local knife = require('entities/knife')

local entities = {
  crazy88(300, 400),
  dwarf(500, 400),
  gogo(600, 400),
  knife(100, 100),
  knife(500, 300),
  hero(150, 400),
}

return entities
