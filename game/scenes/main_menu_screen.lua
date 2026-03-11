local FlexLove = require("libs.FlexLove")
local Color = FlexLove.Color

-- Menu visual constants
local COLORS = {
  NORMAL = Color.new(0.8, 0.9, 1, 1),
  HOVER = Color.new(1, 1, 1, 1),
  PRESSED = Color.new(0.6, 0.7, 0.8, 1)
}

local mainMenu = {
  menuButtons = {},
  selectedIndex = 1,
  isPressed = false,
  pressedKeys = {}
}

local menuOptions = {
  { label = "Start Game", action = "start" },
  { label = "Mods Manager", action = "mods" },
  { label = "Credits", action = "credits" },
  { label = "Settings", action = "settings" },
  { label = "Quit", action = "quit" }
}

local rootElement = nil

function mainMenu:updateButtonStates()
  if not self.menuButtons then return end
  for i, button in ipairs(self.menuButtons) do
    local isSelected = (i == self.selectedIndex)
    if isSelected then
      -- Keyboard/Selected visual state
      local state = self.isPressed and "pressed" or "hover"
      if button._themeManager then
        button._themeManager:setState(state)
      end
      if button._renderer then
        button._renderer:setThemeState(state)
      end

      -- Manually update text color for keyboard selection
      button.textColor = self.isPressed and COLORS.PRESSED or COLORS.HOVER
      button._hovered = true
    else
      -- Check if mouse is hovering this button
      local mouseHovering = button._eventHandler and button._eventHandler._hovered
      if not mouseHovering then
        if button._themeManager then
          button._themeManager:setState("normal")
        end
        if button._renderer then
          button._renderer:setThemeState("normal")
        end

        -- Reset to normal text color
        button.textColor = COLORS.NORMAL
        button._hovered = false
      else
        -- Mouse is hovering but it's not the selectedIndex
        -- (This happens if user moves mouse after using keyboard)
        -- The onEvent handler will eventually sync self.selectedIndex = i
        button.textColor = button._eventHandler:isAnyButtonPressed() and COLORS.PRESSED or COLORS.HOVER
      end
    end
  end
end

function mainMenu:enter()
  self.menuButtons = {}
  self.selectedIndex = 1
  self.isPressed = false
  self.pressedKeys = {}

  FlexLove.init({
    theme = "metal",
    immediateMode = false,
    autoFrameManagement = true
  })

  -- Create elements ONCE here for retained mode
  rootElement = FlexLove.new({
    width = "100%",
    height = "100%",
    backgroundColor = Color.new(0.05, 0.05, 0.08, 1),
    positioning = "flex",
    flexDirection = "column",
    justifyContent = "center",
    alignItems = "center",
    padding = { horizontal = 40, vertical = 40 }
  })

  local title = FlexLove.new({
    parent = rootElement,
    width = 600,
    height = 80,
    backgroundColor = Color.new(0.15, 0.15, 0.25, 1),
    borderRadius = 10,
    text = "Bootstrap Love2D",
    textSize = "3xl",
    textColor = Color.new(0.3, 0.8, 1, 1),
    justifyContent = "center",
    alignItems = "center"
  })

  local menuContainer = FlexLove.new({
    parent = rootElement,
    width = 500,
    height = "100%",
    positioning = "flex",
    flexDirection = "column",
    gap = 10,
    padding = { vertical = 20, horizontal = 20 }
  })

  for i, option in ipairs(menuOptions) do
    local button = FlexLove.new({
      parent = menuContainer,
      width = "90%",
      margin = { left = "5%" },
      height = 50,
      themeComponent = "buttonv2",
      text = option.label,
      textSize = "xl",
      textColor = COLORS.NORMAL,
      onEvent = function(elem, event)
        if event.type == "hover" then
          self.selectedIndex = i
          self.isPressed = false
          self:updateButtonStates()
        elseif event.type == "press" then
          self.isPressed = true
          self:updateButtonStates()
        elseif event.type == "release" then
          self.isPressed = false
          self:updateButtonStates()
          self:handleMenuAction(option.action)
        end
      end
    })
    self.menuButtons[i] = button
  end
  self:updateButtonStates()
end

function mainMenu:leave(next, ...)
  FlexLove.destroy()
  rootElement = nil
  self.menuButtons = nil
end

function mainMenu:update(dt)
  FlexLove.update(dt)
  self:updateButtonStates()
end

function mainMenu:keypressed(key)
  if not self.pressedKeys[key] then
    self.pressedKeys[key] = true
    if key == "up" then
      self.selectedIndex = self.selectedIndex - 1
      if self.selectedIndex < 1 then
        self.selectedIndex = #menuOptions
      end
    elseif key == "down" then
      self.selectedIndex = self.selectedIndex + 1
      if self.selectedIndex > #menuOptions then
        self.selectedIndex = 1
      end
    elseif key == "return" or key == "space" then
      self.isPressed = true
    end
    self:updateButtonStates()
  end
end

function mainMenu:keyreleased(key)
  if self.pressedKeys[key] then
    self.pressedKeys[key] = nil
    if key == "return" or key == "space" then
      self.isPressed = false
      self:updateButtonStates()
      self:handleMenuAction(menuOptions[self.selectedIndex].action)
    end
  end
end

function mainMenu:draw()
  FlexLove.draw()
end

function mainMenu:handleMenuAction(action)
  local nextScene = nil

  if action == "start" then
    nextScene = gameplay
  elseif action == "mods" then
    nextScene = modsManagerScreen
  elseif action == "credits" then
    nextScene = credits
  elseif action == "settings" then
    nextScene = settings
  elseif action == "quit" then
    love.event.quit()
  end

  if nextScene then
    manager:enter(nextScene)
  end
end

return mainMenu
