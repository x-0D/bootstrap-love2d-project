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
  local w, h = love.graphics.getDimensions()
  love.graphics.printf(modSystem.i18n.t("credits/title", nil, nil, "CREDITS"), 0, h * 0.2, w, "center")
  love.graphics.printf(modSystem.i18n.t("credits/content", nil, nil, "Built with Love2D, Concord, and FlexLove"), 0, h * 0.5, w, "center")
  love.graphics.printf(modSystem.i18n.t("ui/hint/back_to_menu", nil, nil, "Press ESC to return"), 0, h * 0.8, w, "center")
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
  end
end

return credits
