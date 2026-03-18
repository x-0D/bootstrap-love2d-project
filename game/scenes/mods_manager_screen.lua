local FlexLove = require("libs.FlexLove")
local Color = FlexLove.Color
local modSystem = require("mods")

local modsManagerScene = {
  selectedIndex = 1,
  isPressed = false,
  pressedKeys = {},
  elements = {},
  rootElement = nil,
  confirmationOverlay = nil,
  confirmationTimer = 0,
  isConfirming = false
}

local COLORS = {
  NORMAL = Color.new(0.8, 0.9, 1, 1),
  HOVER = Color.new(1, 1, 1, 1),
  PRESSED = Color.new(0.6, 0.7, 0.8, 1),
  ACCENT = Color.new(0.3, 0.8, 1, 1),
  ENABLED = Color.new(0.2, 0.8, 0.2, 1),
  DISABLED = Color.new(0.8, 0.2, 0.2, 1)
}

function modsManagerScene:createUI()
  if self.rootElement then
    self.rootElement:destroy()
  end

  local w, h = love.graphics.getDimensions()
  FlexLove.init({
    theme = "metal",
    immediateMode = false,
    autoFrameManagement = true,
    baseScale = { width = w, height = h }
  })

  self.rootElement = FlexLove.new({
    width = "100%",
    height = "100%",
    backgroundColor = Color.new(0.05, 0.05, 0.08, 1),
    positioning = "flex",
    flexDirection = "column",
    justifyContent = "center",
    alignItems = "center",
    gap = 16,
    padding = { horizontal = 24, vertical = 12 }
  })

  local title = FlexLove.new({
    parent = self.rootElement,
    width = "90%",
    height = 60,
    backgroundColor = Color.new(0.15, 0.15, 0.25, 1),
    borderRadius = 10,
    text = "Mods Manager",
    textSize = "3xl",
    textColor = COLORS.ACCENT,
    justifyContent = "center",
    alignItems = "center",
    margin = { bottom = 20 }
  })

  local modsContainer = FlexLove.new({
    parent = self.rootElement,
    width = "90%",
    height = "auto",
    flexGrow = 1,
    positioning = "flex",
    flexDirection = "column",
    gap = 5,
    padding = { vertical = 10, horizontal = 10 },
    backgroundColor = Color.new(0.1, 0.1, 0.15, 0.5),
    borderRadius = 8,
    overflowY = "auto"
  })

  self.elements.rows = {}
  local mods = modSystem.getMods()

  for modName, modInfo in pairs(mods) do
    local row = FlexLove.new({
      parent = modsContainer,
      width = "100%",
      height = 50,
      positioning = "flex",
      flexDirection = "horizontal",
      justifyContent = "space-between",
      alignItems = "center",
      padding = { horizontal = 20 },
      borderRadius = 4,
      onEvent = function(elem, event)
        if event.type == "hover" then
          self.selectedIndex = modName
          self:updateButtonStates()
        end
      end
    })

    local leftCol = FlexLove.new({
      parent = row,
      width = "50%",
      height = "100%",
      positioning = "flex",
      flexDirection = "column",
      justifyContent = "center"
    })

    local nameText = FlexLove.new({
      parent = leftCol,
      text = modInfo.name,
      textSize = "lg",
      textColor = COLORS.NORMAL
    })

    local descText = FlexLove.new({
      parent = leftCol,
      text = modInfo.description or "No description",
      textSize = "sm",
      textColor = COLORS.NORMAL
    })

    local rightCol = FlexLove.new({
      parent = row,
      width = "40%",
      height = "100%",
      positioning = "flex",
      flexDirection = "column",
      justifyContent = "center",
      alignItems = "flex-end"
    })

    local statusText = FlexLove.new({
      parent = rightCol,
      text = modInfo.enabled and "Enabled" or "Disabled",
      textSize = "sm",
      textColor = modInfo.enabled and COLORS.ENABLED or COLORS.DISABLED
    })

    local versionText = FlexLove.new({
      parent = rightCol,
      text = "v" .. (modInfo.version or "1.0.0"),
      textSize = "sm",
      textColor = COLORS.NORMAL
    })

    row.nameElem = nameText
    row.descElem = descText
    row.statusText = statusText
    row.versionElem = versionText
    self.elements.rows[modName] = row
  end

  local buttonContainer = FlexLove.new({
    parent = self.rootElement,
    width = "90%",
    height = 100,
    positioning = "flex",
    flexDirection = "horizontal",
    justifyContent = "center",
    alignItems = "center",
    gap = 20,
    flexWrap = "wrap",
    margin = { top = 20 }
  })

  self.elements.enableBtn = FlexLove.new({
    parent = buttonContainer,
    width = 160,
    height = 48,
    themeComponent = "buttonv2",
    text = "Enable",
    textSize = "xl",
    textColor = COLORS.NORMAL,
    onEvent = function(elem, event)
      if event.type == "hover" then
        self.selectedIndex = "enable"
        self:updateButtonStates()
      elseif event.type == "release" then
        self:enableMod()
      end
    end
  })

  self.elements.disableBtn = FlexLove.new({
    parent = buttonContainer,
    width = 160,
    height = 48,
    themeComponent = "buttonv2",
    text = "Disable",
    textSize = "xl",
    textColor = COLORS.NORMAL,
    onEvent = function(elem, event)
      if event.type == "hover" then
        self.selectedIndex = "disable"
        self:updateButtonStates()
      elseif event.type == "release" then
        self:disableMod()
      end
    end
  })

  self.elements.loadBtn = FlexLove.new({
    parent = buttonContainer,
    width = 160,
    height = 48,
    themeComponent = "buttonv2",
    text = "Load",
    textSize = "xl",
    textColor = COLORS.NORMAL,
    onEvent = function(elem, event)
      if event.type == "hover" then
        self.selectedIndex = "load"
        self:updateButtonStates()
      elseif event.type == "release" then
        self:loadMod()
      end
    end
  })

  self.elements.unloadBtn = FlexLove.new({
    parent = buttonContainer,
    width = 160,
    height = 48,
    themeComponent = "buttonv2",
    text = "Unload",
    textSize = "xl",
    textColor = COLORS.NORMAL,
    onEvent = function(elem, event)
      if event.type == "hover" then
        self.selectedIndex = "unload"
        self:updateButtonStates()
      elseif event.type == "release" then
        self:unloadMod()
      end
    end
  })

  self.elements.backBtn = FlexLove.new({
    parent = buttonContainer,
    width = 160,
    height = 48,
    themeComponent = "buttonv2",
    text = "Back",
    textSize = "xl",
    textColor = COLORS.NORMAL,
    onEvent = function(elem, event)
      if event.type == "hover" then
        self.selectedIndex = "back"
        self:updateButtonStates()
      elseif event.type == "release" then
        manager:enter(mainMenu)
      end
    end
  })

  self:updateButtonStates()
end

function modsManagerScene:updateButtonStates()
  if self.isConfirming then
    if self.elements.keepBtn then
      local isSelected = (self.modalIndex == 1)
      self.elements.keepBtn.textColor = isSelected and COLORS.HOVER or COLORS.NORMAL
      if self.elements.keepBtn._themeManager then
        self.elements.keepBtn._themeManager:setState(isSelected and "hover" or "normal")
      end
    end
    if self.elements.revertBtn then
      local isSelected = (self.modalIndex == 2)
      self.elements.revertBtn.textColor = isSelected and COLORS.HOVER or COLORS.NORMAL
      if self.elements.revertBtn._themeManager then
        self.elements.revertBtn._themeManager:setState(isSelected and "hover" or "normal")
      end
    end
    return
  end

  if not self.elements.rows then return end

  local totalItems = 5

  for modName, row in pairs(self.elements.rows) do
    local isSelected = (modName == self.selectedIndex)
    if isSelected then
      row.backgroundColor = Color.new(1, 1, 1, 0.1)
      row.nameElem.textColor = COLORS.HOVER
      row.descElem.textColor = COLORS.HOVER
    else
      row.backgroundColor = Color.new(0, 0, 0, 0)
      row.nameElem.textColor = COLORS.NORMAL
      row.descElem.textColor = COLORS.NORMAL
    end
  end

  local enableBtn = self.elements.enableBtn
  local isEnableSelected = (self.selectedIndex == "enable")
  if enableBtn then
    enableBtn.textColor = isEnableSelected and COLORS.HOVER or COLORS.NORMAL
    if enableBtn._themeManager then enableBtn._themeManager:setState(isEnableSelected and "hover" or "normal") end
  end

  local disableBtn = self.elements.disableBtn
  local isDisableSelected = (self.selectedIndex == "disable")
  if disableBtn then
    disableBtn.textColor = isDisableSelected and COLORS.HOVER or COLORS.NORMAL
    if disableBtn._themeManager then disableBtn._themeManager:setState(isDisableSelected and "hover" or "normal") end
  end

  local loadBtn = self.elements.loadBtn
  local isLoadSelected = (self.selectedIndex == "load")
  if loadBtn then
    loadBtn.textColor = isLoadSelected and COLORS.HOVER or COLORS.NORMAL
    if loadBtn._themeManager then loadBtn._themeManager:setState(isLoadSelected and "hover" or "normal") end
  end

  local unloadBtn = self.elements.unloadBtn
  local isUnloadSelected = (self.selectedIndex == "unload")
  if unloadBtn then
    unloadBtn.textColor = isUnloadSelected and COLORS.HOVER or COLORS.NORMAL
    if unloadBtn._themeManager then unloadBtn._themeManager:setState(isUnloadSelected and "hover" or "normal") end
  end

  local backBtn = self.elements.backBtn
  local isBackSelected = (self.selectedIndex == "back")
  if backBtn then
    backBtn.textColor = isBackSelected and COLORS.HOVER or COLORS.NORMAL
    if backBtn._themeManager then backBtn._themeManager:setState(isBackSelected and "hover" or "normal") end
  end
end

function modsManagerScene:enableMod()
  local modName = self.selectedIndex
  if type(modName) ~= "string" then return end

  local success, message = modSystem.setEnabled(modName, true)
  if success then
    print("Mod enabled: " .. modName)
    self:rebuildUI()
  else
    print("Failed to enable mod: " .. message)
  end
end

function modsManagerScene:disableMod()
  local modName = self.selectedIndex
  if type(modName) ~= "string" then return end

  local success, message = modSystem.setEnabled(modName, false)
  if success then
    print("Mod disabled: " .. modName)
    self:rebuildUI()
  else
    print("Failed to disable mod: " .. message)
  end
end

function modsManagerScene:loadMod()
  -- No-op in new system, or we can just call it to check for errors
  local modName = self.selectedIndex
  if type(modName) ~= "string" then return end
  print("Mod " .. modName .. " will be loaded when gameplay starts")
end

function modsManagerScene:unloadMod()
  -- No-op in new system
  local modName = self.selectedIndex
  if type(modName) ~= "string" then return end
  print("Mod " .. modName .. " will be unloaded when leaving gameplay")
end

function modsManagerScene:rebuildUI()
  self:createUI()
end

function modsManagerScene:createConfirmationOverlay()
  self.confirmationOverlay = FlexLove.new({
    width = "100%",
    height = "100%",
    backgroundColor = Color.new(0, 0, 0, 0.8),
    positioning = "flex",
    flexDirection = "column",
    justifyContent = "center",
    alignItems = "center",
    zIndex = 100
  })

  local dialog = FlexLove.new({
    parent = self.confirmationOverlay,
    width = 500,
    height = 300,
    backgroundColor = Color.new(0.1, 0.1, 0.15, 1),
    borderRadius = 15,
    border = { top = true, bottom = true, left = true, right = true },
    borderColor = COLORS.ACCENT,
    positioning = "flex",
    flexDirection = "column",
    justifyContent = "center",
    alignItems = "center",
    padding = 40,
    gap = 20
  })

  FlexLove.new({
    parent = dialog,
    text = "Confirm action?",
    textSize = "2xl",
    textColor = COLORS.HOVER
  })

  self.elements.timerText = FlexLove.new({
    parent = dialog,
    text = "Action will be executed immediately",
    textSize = "lg",
    textColor = COLORS.NORMAL
  })

  local btnRow = FlexLove.new({
    parent = dialog,
    width = "100%",
    height = 60,
    positioning = "flex",
    flexDirection = "horizontal",
    justifyContent = "center",
    gap = 20
  })

  self.elements.keepBtn = FlexLove.new({
    parent = btnRow,
    width = 150,
    height = 50,
    themeComponent = "buttonv2",
    text = "Confirm",
    onEvent = function(_, event)
      if event.type == "hover" then
        self.modalIndex = 1
        self:updateButtonStates()
      elseif event.type == "release" then
        self:confirmAction()
      end
    end
  })

  self.elements.revertBtn = FlexLove.new({
    parent = btnRow,
    width = 150,
    height = 50,
    themeComponent = "buttonv2",
    text = "Cancel",
    onEvent = function(_, event)
      if event.type == "hover" then
        self.modalIndex = 2
        self:updateButtonStates()
      elseif event.type == "release" then
        self:cancelAction()
      end
    end
  })
end

function modsManagerScene:confirmAction()
  self.isConfirming = false
  if self.confirmationOverlay then
    self.confirmationOverlay:destroy()
    self.confirmationOverlay = nil
  end
end

function modsManagerScene:cancelAction()
  self.isConfirming = false
  if self.confirmationOverlay then
    self.confirmationOverlay:destroy()
    self.confirmationOverlay = nil
  end
end

function modsManagerScene:enter(previous, ...)
  local w, h = love.graphics.getDimensions()
  FlexLove.init({
    theme = "metal",
    immediateMode = false,
    autoFrameManagement = true,
    baseScale = { width = w, height = h }
  })

  self.pressedKeys = {}
  modSystem.scan()
  self:createUI()

  -- Set initial selected index to the first mod or first button
  local mods = modSystem.getMods()
  local modNames = {}
  for modName in pairs(mods) do
    table.insert(modNames, modName)
  end
  table.sort(modNames)

  if #modNames > 0 then
    self.selectedIndex = modNames[1]
  else
    self.selectedIndex = "back"
  end

  self.isConfirming = false
end

function modsManagerScene:leave(next, ...)
  FlexLove.destroy()
  self.rootElement = nil
  self.confirmationOverlay = nil
end

function modsManagerScene:update(dt)
  FlexLove.update(dt)

  if self.isConfirming then
    self.confirmationTimer = self.confirmationTimer - dt
    if self.elements.timerText then
      self.elements.timerText.text = string.format("Action will be executed in %d seconds...", math.ceil(self.confirmationTimer))
    end

    if self.confirmationTimer <= 0 then
      self:confirmAction()
    end
  end
end

function modsManagerScene:draw()
  FlexLove.draw()
end

function modsManagerScene:keypressed(key)
  if not self.pressedKeys[key] then
    self.pressedKeys[key] = true
    if self.isConfirming then
      if key == "left" or key == "up" then
        self.modalIndex = 1
      elseif key == "right" or key == "down" then
        self.modalIndex = 2
      elseif key == "return" or key == "space" then
        if self.modalIndex == 1 then
          self:confirmAction()
        else
          self:cancelAction()
        end
      elseif key == "escape" then
        self:cancelAction()
      end
      self:updateButtonStates()
      return
    end

    local mods = modSystem.getMods()
    local modNames = {}
    for modName in pairs(mods) do
      table.insert(modNames, modName)
    end
    table.sort(modNames)

    local buttonNames = { "enable", "disable", "load", "unload", "back" }
    local navigationList = {}
    for _, name in ipairs(modNames) do
      table.insert(navigationList, name)
    end
    for _, name in ipairs(buttonNames) do
      table.insert(navigationList, name)
    end

    local currentIndex = 1
    for i, name in ipairs(navigationList) do
      if name == self.selectedIndex then
        currentIndex = i
        break
      end
    end

    if key == "up" then
      currentIndex = currentIndex - 1
      if currentIndex < 1 then
        currentIndex = #navigationList
      end
      self.selectedIndex = navigationList[currentIndex]
    elseif key == "down" then
      currentIndex = currentIndex + 1
      if currentIndex > #navigationList then
        currentIndex = 1
      end
      self.selectedIndex = navigationList[currentIndex]
    elseif key == "return" or key == "space" then
      if self.selectedIndex == "enable" then
        self:enableMod()
      elseif self.selectedIndex == "disable" then
        self:disableMod()
      elseif self.selectedIndex == "load" then
        self:loadMod()
      elseif self.selectedIndex == "unload" then
        self:unloadMod()
      elseif self.selectedIndex == "back" then
        manager:enter(mainMenu)
      end
    elseif key == "escape" then
      manager:enter(mainMenu)
    end

    self:updateButtonStates()
  end
end

function modsManagerScene:keyreleased(key)
  if self.pressedKeys[key] then
    self.pressedKeys[key] = nil
    if key == "return" or key == "space" then
      if self.isConfirming then
        if self.modalIndex == 1 then
          self:confirmAction()
        else
          self:cancelAction()
        end
      -- Note: Actions are already handled in keypressed for immediate response
      -- but we can keep it here if we want release-based actions
      end
    end
  end
end

return modsManagerScene
