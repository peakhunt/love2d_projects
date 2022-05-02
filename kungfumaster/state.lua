-------------------------------------------------------------------------------------
--
--
-- XXX
-- DO NOT REQUIRE ANYTHING HERE OR YOU WILL END UP FALLING INTO CIRCULAR REQUIRE HELL
--
--
-------------------------------------------------------------------------------------
return {
  --
  -- for game inputs
  --
  button_left = false,
  button_right = false,
  button_up = false,
  button_down = false,
  button_punch = false,
  button_kick = false,
  button_debug = false,

  paused = false,

  --
  -- current game level object
  --
  current_level = nil,

  --
  -- hero
  --
  hero = nil,
  held = 0,

  crazy88_count = 0,
  gogo_count = 0,
  --
  -- game objects
  --
  entities = {},
  scores = {},

  --
  -- for game management and dashboard
  --
  level = 1,            -- 1 to 5
  life_left = 3,
  time_left = 60,       -- seconds. 4 digit
  score = 0,            -- 6 digits
  top_score = 0,        -- 6 digits
  hero_energy = 1,      -- 0 to 1
  enemy_energy = 1,     -- 0 to 1. level boss' energy

  --
  --
  --
  scene = "",

  --
  -- for debugging and testing
  --
  test_enabled = false,

  --
  -- conveniences
  --
  reset = function(self)
    self.button_left = false
    self.button_right = false
    self.button_up = false
    self.button_down = false
    self.button_punch = false
    self.button_kick = false

    self.current_level = nil
    self.hero = nil
    self.held = 0

    self.entities = {}
    self.scores = {}

    self.level = 1
    self.life_left = 3
    self.time_left = 60
    self.score = 0
    self.top_score = 0
    self.hero_energy = 1
    self.enemy_energy = 1

    self.gogo_count = 0
    self.crazy88_count = 0
  end,

  restart = function(self)
    self.hero_energy = 1
    self.enemy_energy = 1
    self.time_left = 60
    self.held = 0
    self.entities = {}
    self.scores = {}

    self.gogo_count = 0
    self.crazy88_count = 0

    self.current_level:restart()
  end,

  incScore = function(self, inc, scoreObj)
    self.score = self.score + inc
    if scoreObj then
      table.insert(self.scores, scoreObj)
    end
  end,

  incHeld = function(self)
    self.held = self.held + 1
  end,

  decHeld = function(self)
    self.held = self.held - 1
  end,

  isHeld = function(self)
    if self.held == 0 then
      return false
    end
    return true
  end,

  decHeroEnergy = function(self, delta)
    self.hero_energy = self.hero_energy - delta
    if self.hero_energy < 0 then
      self.hero_energy = 0
    end
  end,

  decHeroLives = function(self, d)
    self.life_left = self.life_left - d
  end,
}
