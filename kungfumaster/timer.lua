return function(interval, callback)
  local timer = {
    interval = interval,
    accumulated = 0,
    callback = callback,
    started = false,

    update = function(self, dt)
      if self.started then
        self.accumulated = self.accumulated + dt
        if self.accumulated >= self.interval then
          self.accumulated = 0
          self.callback()
        end
      end
    end,

    start = function(self)
      self.accumulated = 0
      self.started = true
    end,

    stop = function(self)
      self.started = false
    end,
  }
  return timer
end
