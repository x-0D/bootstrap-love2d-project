local credits = {
  pressedKeys = {}
}

function credits:enter(previous, ...)
  print("Entering credits scene")
  self.pressedKeys = {}
end

function credits:leave(next, ...)
  print("Leaving credits scene")
end

function credits:update(dt)
end

function credits:draw()
  love.graphics.print("Credits Screen", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end

function credits:keypressed(key)
  if not self.pressedKeys[key] then
    self.pressedKeys[key] = true
    if key == "escape" then
      local menu = modSystem.getScene("main_menu")
      if menu then
        manager:enter(menu)
      end
    end
  end
end

function credits:keyreleased(key)
  if self.pressedKeys[key] then
    self.pressedKeys[key] = nil
    if key == "escape" then
      local menu = modSystem.getScene("main_menu")
      if menu then
        manager:enter(menu)
      end
    end
  end
end

return credits
