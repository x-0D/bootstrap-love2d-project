local gameplay = {
  pressedKeys = {}
}

function gameplay:enter(previous, ...)
  print("Entering gameplay scene")
  self.pressedKeys = {}
end

function gameplay:leave(next, ...)
  print("Leaving gameplay scene")
end

function gameplay:update(dt)
end

function gameplay:draw()
  love.graphics.print("Gameplay Screen", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end

function gameplay:keypressed(key)
  if not self.pressedKeys[key] then
    self.pressedKeys[key] = true
    if key == "escape" then
      manager:enter(mainMenu)
    end
  end
end

function gameplay:keyreleased(key)
  if self.pressedKeys[key] then
    self.pressedKeys[key] = nil
    if key == "escape" then
      manager:enter(mainMenu)
    end
  end
end

return gameplay
