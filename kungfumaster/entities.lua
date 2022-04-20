--
-- import anything you want
--
local bottom_y = 0.19

local hero = require('entities/hero')
local crazy88 = require('entities/crazy88')
local dwarf = require('entities/dwarf')
local gogo = require('entities/gogo')
local knife = require('entities/knife')

local entities = {
  knife(6.1, 0.5, false),
  knife(7.1, 0.22, true),
  crazy88(6.3, bottom_y),
  dwarf(6.2, bottom_y),
  gogo(6.7, bottom_y),
  hero = hero(6.5, bottom_y),
}

return entities
