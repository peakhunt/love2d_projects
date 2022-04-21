local asset_conf = require('asset_conf')
local hero = require('entities/hero')
local crazy88 = require('entities/crazy88')
local dwarf = require('entities/dwarf')
local gogo = require('entities/gogo')
local knife = require('entities/knife')
local state = require('state')

local h = hero(6.5, asset_conf.floor_bottom)

state.hero = h

local entities = {
  table = {
    h
  },
  hero = h,
}

return entities
