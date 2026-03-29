local FlexLove = require("libs.FlexLove")
local Color = FlexLove.Color

local modsManagerScene = {
  selectedIndex = 1,
  selectedMod = nil,
  isPressed = false,
  pressedKeys = {},
  elements = {},
  rootElement = nil,
  needsReload = false
}

local COLORS = {
  NORMAL = Color.new(0.8, 0.9, 1, 1),
  HOVER = Color.new(1, 1, 1, 1),
  PRESSED = Color.new(0.6, 0.7, 0.8, 1),
  ACCENT = Color.new(0.3, 0.8, 1, 1),
  ENABLED = Color.new(0.2, 0.8, 0.2, 1),
  DISABLED = Color.new(0.8, 0.2, 0.2, 1)
}

function modsManagerScene:createToggleComponent(props)
  local isEnabled = props.isEnabled
  local isLocked = props.isLocked

  local track = FlexLove.new({
    parent = props.parent,
    width = 54,
    height = 28,
    backgroundColor = isEnabled and COLORS.ENABLED or Color.new(0.2, 0.2, 0.25, 1),
    borderRadius = 14,
    disabled = isLocked,
    opacity = isLocked and 0.5 or 1,
    positioning = "flex",
    flexDirection = "horizontal",
    justifyContent = isEnabled and "flex-end" or "flex-start",
    alignItems = "center",
    padding = { horizontal = 3 },
    onEvent = function(elem, event)
      if elem.disabled then return end
      if event.type == "release" then
        print("[ModsManager] Toggle release detected for mod: " .. tostring(self.selectedMod))
        if props.onToggle then props.onToggle() end
      elseif event.type == "hover" then
        elem.borderColor = COLORS.HOVER
        elem.borderWidth = 1
      elseif event.type == "unhover" then
        elem.borderWidth = 0
      end
    end
  })

  local knob = FlexLove.new({
    parent = track,
    width = 22,
    height = 22,
    backgroundColor = isEnabled and COLORS.HOVER or COLORS.NORMAL,
    borderRadius = 11,
    disabled = true,
    positioning = "absolute",
    left = isEnabled and 28 or 4,
    top = 3
  })

  return track, knob
end

function modsManagerScene:createUI()
  if self.rootElement then
    self.rootElement:destroy()
  end
  self.elements = {}

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
    justifyContent = "flex-start",
    alignItems = "center",
    gap = 16,
    padding = { horizontal = 24, vertical = 20 }
  })

  local title = FlexLove.new({
    parent = self.rootElement,
    width = "90%",
    height = 60,
    backgroundColor = Color.new(0.15, 0.15, 0.25, 1),
    borderRadius = 10,
    text = modSystem.i18n.t("mods/manager/title", nil, nil, "Mods Manager"),
    textSize = "3xl",
    textColor = COLORS.ACCENT,
    justifyContent = "center",
    alignItems = "center",
    margin = { bottom = 20 }
  })

  local mainContainer = FlexLove.new({
    parent = self.rootElement,
    width = "95%",
    height = 0,
    flexGrow = 1,
    positioning = "flex",
    flexDirection = "horizontal",
    gap = 20,
    margin = { bottom = 10 }
  })

  local modsList = FlexLove.new({
    parent = mainContainer,
    width = 300,
    height = "100%",
    positioning = "flex",
    flexDirection = "column",
    gap = 5,
    padding = { vertical = 10, horizontal = 10 },
    backgroundColor = Color.new(0.1, 0.1, 0.15, 0.5),
    borderRadius = 8,
    border = { right = true, left = true, top = true, bottom = true },
    borderColor = Color.new(1, 1, 1, 0.1),
    borderWidth = 1,
    overflowY = "auto"
  })

  local descriptionPanel = FlexLove.new({
    parent = mainContainer,
    width = 0,
    flexGrow = 1,
    height = "100%",
    positioning = "flex",
    flexDirection = "column",
    gap = 10,
    padding = { vertical = 20, horizontal = 20 },
    backgroundColor = Color.new(0.1, 0.1, 0.15, 0.8),
    borderRadius = 8,
    border = { left = true, right = true, top = true, bottom = true },
    borderColor = COLORS.ACCENT,
    borderWidth = 2,
    opacity = 0
  })

  self.elements.descriptionPanel = descriptionPanel

  self.elements.rows = {}
  local mods = modSystem.getMods()

  -- Create a sorted list of mod names for consistent display
  local modNames = {}
  for name in pairs(mods) do
    table.insert(modNames, name)
  end
  table.sort(modNames)

  for _, modName in ipairs(modNames) do
    local modInfo = mods[modName]
    local isEnabled = modInfo.enabled

    local row = FlexLove.new({
      parent = modsList,
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
        elseif event.type == "release" then
          self.selectedMod = modName
          self:rebuildUI()
        end
      end
    })

    local nameText = FlexLove.new({
      parent = row,
      text = modInfo.displayName or modInfo.name,
      textSize = "lg",
      textColor = COLORS.NORMAL,
      opacity = isEnabled and 1 or 0.5
    })

    row.nameElem = nameText
    self.elements.rows[modName] = row
  end



  local header = FlexLove.new({
    parent = descriptionPanel,
    width = "100%",
    height = 100,
    positioning = "flex",
    flexDirection = "horizontal",
    alignItems = "center",
    gap = 20,
    border = { bottom = true },
    borderColor = Color.new(1, 1, 1, 0.1),
    margin = { bottom = 10 },
    padding = { vertical = 10, horizontal = 10 },
    disabled = true -- Do not block events for children
  })

  local selectedModInfo = modSystem.getMods()[self.selectedMod]
  local isEnabled = selectedModInfo and selectedModInfo.enabled or false
  local isCore = self.selectedMod == "core"
  print(string.format("[ModsManager] createUI: mod=%s, isEnabled=%s", tostring(self.selectedMod), tostring(isEnabled)))

  -- Switch Toggle Component
  self.elements.toggleTrack, self.elements.toggleKnob = self:createToggleComponent({
    parent = header,
    isEnabled = isEnabled,
    isLocked = isCore,
    onToggle = function() self:toggleMod() end
  })

  local headerInfo = FlexLove.new({
    parent = header,
    width = 0,
    flexGrow = 1,
    height = "100%",
    positioning = "flex",
    flexDirection = "column",
    justifyContent = "center",
    gap = 2
  })

  local descriptionTitle = FlexLove.new({
    parent = headerInfo,
    text = modSystem.i18n.t("mods/manager/select_prompt", nil, nil, "Select a mod to see details"),
    textSize = "2xl",
    textColor = COLORS.HOVER,
    width = "100%",
    textWrap = "word"
  })

  local versionText = FlexLove.new({
    parent = headerInfo,
    text = "",
    textSize = "sm",
    textColor = COLORS.NORMAL,
    width = "100%"
  })

  local contentArea = FlexLove.new({
    parent = descriptionPanel,
    width = "100%",
    flexGrow = 1,
    positioning = "flex",
    flexDirection = "column",
    gap = 10,
    overflowY = "auto",
    padding = { right = 10, vertical = 5 }
  })

  local descriptionText = FlexLove.new({
    parent = contentArea,
    text = "",
    textSize = "lg",
    textColor = COLORS.NORMAL,
    textWrap = "word",
    width = "100%"
  })

  self.elements.descriptionTitle = descriptionTitle
  self.elements.descriptionText = descriptionText
  self.elements.versionText = versionText

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

  self.elements.backBtn = FlexLove.new({
    parent = buttonContainer,
    width = 160,
    height = 48,
    themeComponent = "buttonv2",
    text = modSystem.i18n.t("mods/manager/back", nil, nil, "BACK"),
    textSize = "xl",
    textColor = COLORS.NORMAL,
    onEvent = function(elem, event)
      if event.type == "hover" then
        self.selectedIndex = "back"
        self:updateButtonStates()
      elseif event.type == "release" then
        if self.needsReload then
          modSystem.reload()
        else
          local menu = modSystem.getScene("main_menu")
          if menu then
            manager:enter(menu)
          end
        end
      end
    end
  })

  self:updateButtonStates()
end

function modsManagerScene:updateButtonStates()
  if not self.elements.rows or not self.elements.descriptionPanel then return end

  local mods = modSystem.getMods()
  for modName, row in pairs(self.elements.rows) do
    local modInfo = mods[modName]
    local isHovered = (modName == self.selectedIndex)
    local isSelected = (modName == self.selectedMod)
    local isEnabled = modInfo and modInfo.enabled

    if isSelected then
      -- Persistent highlight for the active mod
      row.backgroundColor = Color.new(COLORS.ACCENT.r, COLORS.ACCENT.g, COLORS.ACCENT.b, 0.4)
      row.nameElem.textColor = COLORS.HOVER
    elseif isHovered then
      -- Temporary highlight for hovering/keyboard focus
      row.backgroundColor = Color.new(1, 1, 1, 0.1)
      row.nameElem.textColor = COLORS.HOVER
    else
      row.backgroundColor = Color.new(0, 0, 0, 0)
      row.nameElem.textColor = COLORS.NORMAL
    end
    -- Always reflect the actual enabled state, regardless of selection/hover
    row.nameElem.opacity = isEnabled and 1 or 0.5
  end

  local selectedMod = modSystem.getMods()[self.selectedMod]
  if selectedMod then
    if self.elements.descriptionPanel.opacity == 0 then
      self.elements.descriptionPanel:fadeIn(0.2)
    end
    self.elements.descriptionTitle:updateText(selectedMod.displayName or selectedMod.name)
    self.elements.descriptionText:updateText(selectedMod.description or "No description available.")
    self.elements.versionText:updateText("Version: " .. (selectedMod.version or "1.0.0"))
  else
    self.elements.descriptionPanel.opacity = 0
    self.elements.descriptionTitle.text = ""
    self.elements.descriptionText.text = ""
    self.elements.versionText.text = ""
  end

  local backBtn = self.elements.backBtn
  local isBackSelected = (self.selectedIndex == "back")
  if backBtn then
    backBtn.textColor = isBackSelected and COLORS.HOVER or COLORS.NORMAL
    if backBtn._themeManager then backBtn._themeManager:setState(isBackSelected and "hover" or "normal") end
  end
end

function modsManagerScene:toggleMod()
  print("[ModsManager] toggleMod called for: " .. tostring(self.selectedMod))
  local modName = self.selectedMod
  if not modName then return end
  local selectedMod = modSystem.getMods()[modName]
  if not selectedMod then return end

  if selectedMod.enabled then
    self:disableMod()
  else
    self:enableMod()
  end
end

function modsManagerScene:enableMod()
  local modName = self.selectedMod
  if type(modName) ~= "string" then return end

  local success, message = modSystem.setEnabled(modName, true)
  if success then
    print("Mod enabled: " .. modName)
    self.needsReload = true
    self:rebuildUI()
  else
    print("Failed to enable mod: " .. message)
  end
end

function modsManagerScene:disableMod()
  local modName = self.selectedMod
  if type(modName) ~= "string" then return end

  local success, message = modSystem.setEnabled(modName, false)
  if success then
    print("Mod disabled: " .. modName)
    self.needsReload = true
    self:rebuildUI()
  else
    print("Failed to disable mod: " .. message)
  end
end

function modsManagerScene:rebuildUI()
  self:createUI()
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

function modsManagerScene:enter(previous, ...)
  self.pressedKeys = {}
  self.needsReload = false
  modSystem.scan()

  -- Set initial selection if not set
  local mods = modSystem.getMods()
  local modNames = {}
  for modName in pairs(mods) do
    table.insert(modNames, modName)
  end
  table.sort(modNames)

  if not self.selectedMod and #modNames > 0 then
    -- Prefer core if it exists, otherwise use the first one
    local hasCore = false
    for _, name in ipairs(modNames) do
      if name == "core" then
        hasCore = true
        break
      end
    end
    self.selectedMod = hasCore and "core" or modNames[1]
  end

  self.selectedIndex = self.selectedMod or "back"
  self:createUI()
end

function modsManagerScene:leave(next, ...)
  FlexLove.destroy()
  self.rootElement = nil
end

function modsManagerScene:update(dt)
  FlexLove.update(dt)
end

function modsManagerScene:draw()
  FlexLove.draw()
end

function modsManagerScene:keypressed(key)
  if not self.pressedKeys[key] then
    self.pressedKeys[key] = true

    local mods = modSystem.getMods()
    local modNames = {}
    for modName in pairs(mods) do
      table.insert(modNames, modName)
    end
    table.sort(modNames)

    local navigationList = {}
    for _, name in ipairs(modNames) do
      table.insert(navigationList, name)
    end
    table.insert(navigationList, "back")

    local currentIndex = 0
    for i, name in ipairs(navigationList) do
      if name == self.selectedIndex then
        currentIndex = i
        break
      end
    end

    if key == "down" then
      currentIndex = currentIndex + 1
      if currentIndex > #navigationList then currentIndex = 1 end
      self.selectedIndex = navigationList[currentIndex]
      self:updateButtonStates()
    elseif key == "up" then
      currentIndex = currentIndex - 1
      if currentIndex < 1 then currentIndex = #navigationList end
      self.selectedIndex = navigationList[currentIndex]
      self:updateButtonStates()
    elseif key == "return" or key == "space" then
        if self.selectedIndex == "back" then
          if self.needsReload then
            modSystem.reload()
          else
            local menu = modSystem.getScene("main_menu")
            if menu then
              manager:enter(menu)
            end
          end
        elseif self.selectedIndex then
          -- If it's a mod name, select it
          local mods = modSystem.getMods()
          if mods[self.selectedIndex] then
            -- If already selected, toggle it. If not, select it.
            if self.selectedMod == self.selectedIndex then
              self:toggleMod()
            else
              self.selectedMod = self.selectedIndex
              self:rebuildUI()
            end
          end
        end
    elseif key == "escape" then
      if self.needsReload then
        modSystem.reload()
      else
        local menu = modSystem.getScene("main_menu")
        if menu then
          manager:enter(menu)
        end
      end
    end
  end
end

function modsManagerScene:keyreleased(key)
  if self.pressedKeys[key] then
    self.pressedKeys[key] = nil
  end
end

return modsManagerScene
