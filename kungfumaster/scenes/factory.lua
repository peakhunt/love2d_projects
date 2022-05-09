local hero_falling = require('scenes/hero_falling')
local level_finishing = require('scenes/level_finishing')
local level_playing = require('scenes/level_playing')
local level_starting = require('scenes/level_starting')
local game_ending = require('scenes/game_ending')

local factory = require('factory')

factory.scenes.hero_falling = hero_falling
factory.scenes.level_finishing = level_finishing
factory.scenes.level_playing = level_playing
factory.scenes.level_starting = level_starting
factory.scenes.game_ending = game_ending
