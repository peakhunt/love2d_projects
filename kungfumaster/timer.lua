return function(interval, callback)
  local timer = {
    interval = interval,
    accumulated = 0,
    callback = callback,

    update = function(self, dt)
      self.accumulated = self.accumulated + dt
      if self.accumulated >= self.interval then
        self.accumulated = 0
        self.callback()
      end
    end,
  }
  return timer
end
