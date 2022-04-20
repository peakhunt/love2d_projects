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

  --
  -- current game level object
  --
  current_level = nil,

  --
  -- for game management and dashboard
  --
  level = 1,            -- 1 to 5
  life_left = 3,
  time_left = 60,       -- seconds. 4 digit
  score = 0,            -- 6 digits
  top_score = 0,        -- 6 digits
  hero_energy = 100,    -- 0 to 100 %
  enemy_energy = 100,   -- 0 to 100 %. level boss' energy

  --
  -- for debugging and testing
  --
  test_enabled = true,
}
