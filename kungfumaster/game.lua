local factory = require('factory')
local state = require('state')

return {
  newGame = function(lvl)
    state:reset()
    factory.level(lvl)
    state:changeScene(factory.scenes.level_starting())
  end,

  nextLevel = function()
    local lvl = state.level
    if lvl < 5 then
      lvl = lvl + 1
      factory.level(lvl)
      state:changeScene(factory.scenes.level_starting())
    end
  end,
}
