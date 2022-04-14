--
-- import anything you want
--
local bottom_y = 160 * 3

local hero = require('entities/hero')
local crazy88 = require('entities/crazy88')
local dwarf = require('entities/dwarf')
local gogo = require('entities/gogo')
local knife = require('entities/knife')

local entities = {
  crazy88(300, bottom_y),
  dwarf(500, bottom_y),
  gogo(600, bottom_y),
  knife(100, 250),
  knife(500, 370),
  hero(150, bottom_y),
}

return entities
