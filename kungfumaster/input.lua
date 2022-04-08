local state = require('state')

local trigger = {
  punch = 0,
  kick = 0,
}

local press_funcs = {
  left = function()
    state.button_left = true
  end,

  right = function()
    state.button_right = true
  end,

  up = function()
    state.button_up = true
  end,

  down = function()
    state.button_down = true
  end,

  x = function()
    state.button_punch = true
    trigger.punch = 0
  end,

  z = function()
    state.button_kick = true
    trigger.kick = 0
  end,
}

local release_funcs = {
  left = function()
    state.button_left = false
  end,

  right = function()
    state.button_right = false
  end,

  up = function()
    state.button_up = false
  end,

  down = function()
    state.button_down = false
  end,

  x = function()
    state.button_punch = false
    trigger.punch = 0
  end,

  z = function()
    state.button_kick = false
    trigger.kick = 0
  end,
}

return {
  press = function(pressed_key)
    if press_funcs[pressed_key] then
      press_funcs[pressed_key]()
    end
  end,
  release = function(released_key)
    if release_funcs[released_key] then
      release_funcs[released_key]()
    end
  end,

  update = function(dt)
    if state.button_punch == true then
      if trigger.punch ~= 0 then
        state.button_punch = false
      else
        trigger.punch = trigger.punch + 1
      end
    end

    if state.button_kick == true then
      if trigger.pick ~= 0 then
        state.button_pick = false
      else
        trigger.kick = trigger.kick + 1
      end
    end
  end
}
