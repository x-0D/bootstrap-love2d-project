local FlexLove = require("libs.FlexLove")
local Color = FlexLove.Color

local settingsScene = {
  selectedIndex = 1,
  modalIndex = 1,
  isPressed = false,
  isConfirming = false,
  confirmationTimer = 0,
  oldSettings = nil,
  pendingSettings = {},
  currentSettings = {},
  options = {},
  elements = {},
  rootElement = nil,
  confirmationOverlay = nil,
  pressedKeys = {}
}

-- Settings visual constants (consistent with main menu)
local COLORS = {
  NORMAL = Color.new(0.8, 0.9, 1, 1),
  HOVER = Color.new(1, 1, 1, 1),
  PRESSED = Color.new(0.6, 0.7, 0.8, 1),
  ACCENT = Color.new(0.3, 0.8, 1, 1)
}

-- Supported resolutions
local function getSupportedResolutions()
  local modes = love.window.getFullscreenModes()
  table.sort(modes, function(a, b)
    if a.width ~= b.width then return a.width < b.width end
    return a.height < b.height
  end)

  local resStrings = {}
  local seen = {}
  for _, m in ipairs(modes) do
    local s = m.width .. "x" .. m.height
    if not seen[s] then
      table.insert(resStrings, s)
      seen[s] = true
    end
  end
  return resStrings
end

function settingsScene:initSettings()
  local w, h, flags = love.window.getMode()
  self.currentSettings = {
    resolution = w .. "x" .. h,
    mode = flags.fullscreen and (flags.fullscreentype == "desktop" and "Borderless" or "Fullscreen") or "Windowed",
    vsync = flags.vsync and "On" or "Off",
    fps = "Unlimited",
    msaa = tostring(flags.msaa),
    hidpi = flags.highdpi and "On" or "Off"
  }

  self.pendingSettings = {}
  for k, v in pairs(self.currentSettings) do
    self.pendingSettings[k] = v
  end

  local resolutions = getSupportedResolutions()
  local currentRes = self.currentSettings.resolution
  local resIdx = 1
  for i, r in ipairs(resolutions) do
    if r == currentRes then resIdx = i; break end
  end

  self.options = {
    { key = "resolution", label = "Resolution", values = resolutions, currentIndex = resIdx },
    { key = "mode", label = "Display Mode", values = { "Windowed", "Fullscreen", "Borderless" }, currentIndex = 1 },
    { key = "vsync", label = "VSync", values = { "On", "Off" }, currentIndex = flags.vsync and 1 or 2 },
    { key = "fps", label = "FPS Cap", values = { "30", "60", "120", "144", "240", "Unlimited" }, currentIndex = 6 },
    { key = "msaa", label = "MSAA", values = { "0", "2", "4", "8", "16" }, currentIndex = 1 },
    { key = "hidpi", label = "HiDPI", values = { "On", "Off" }, currentIndex = flags.highdpi and 1 or 2 }
  }

  for i, v in ipairs(self.options[2].values) do
    if v == self.currentSettings.mode then self.options[2].currentIndex = i; break end
  end
  for i, v in ipairs(self.options[5].values) do
    if v == self.currentSettings.msaa then self.options[5].currentIndex = i; break end
  end
end

function settingsScene:updateButtonStates()
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

  local totalItems = #self.options + 2

  for i = 1, #self.options do
    local row = self.elements.rows[i]
    local isSelected = (i == self.selectedIndex)

    if isSelected then
      row.backgroundColor = Color.new(1, 1, 1, 0.1)
      row.labelElem.textColor = COLORS.HOVER
    else
      row.backgroundColor = Color.new(0, 0, 0, 0)
      row.labelElem.textColor = COLORS.NORMAL
    end
  end

  local applyBtn = self.elements.applyBtn
  local isApplySelected = (self.selectedIndex == totalItems - 1)
  if applyBtn then
    applyBtn.textColor = isApplySelected and COLORS.HOVER or COLORS.NORMAL
    if applyBtn._themeManager then applyBtn._themeManager:setState(isApplySelected and "hover" or "normal") end
  end

  local backBtn = self.elements.backBtn
  local isBackSelected = (self.selectedIndex == totalItems)
  if backBtn then
    backBtn.textColor = isBackSelected and COLORS.HOVER or COLORS.NORMAL
    if backBtn._themeManager then backBtn._themeManager:setState(isBackSelected and "hover" or "normal") end
  end
end

function settingsScene:changeValue(optionIdx, delta)
  local opt = self.options[optionIdx]
  opt.currentIndex = opt.currentIndex + delta
  if opt.currentIndex < 1 then opt.currentIndex = #opt.values end
  if opt.currentIndex > #opt.values then opt.currentIndex = 1 end

  local newValue = opt.values[opt.currentIndex]
  self.pendingSettings[opt.key] = newValue

  if self.elements.rows[optionIdx] then
    self.elements.rows[optionIdx].valueElem.text = newValue
  end
end

function settingsScene:applySettings()
  local w, h = self.pendingSettings.resolution:match("(%d+)x(%d+)")
  w, h = tonumber(w), tonumber(h)

  local flags = {
    fullscreen = (self.pendingSettings.mode ~= "Windowed"),
    fullscreentype = (self.pendingSettings.mode == "Borderless" and "desktop" or "exclusive"),
    vsync = (self.pendingSettings.vsync == "On"),
    msaa = tonumber(self.pendingSettings.msaa),
    highdpi = (self.pendingSettings.hidpi == "On"),
    display = 1
  }

  local oldW, oldH, oldFlags = love.window.getMode()
  self.oldSettings = {
    w = oldW, h = oldH, flags = oldFlags,
    pending = {}
  }
  for k, v in pairs(self.currentSettings) do
    self.oldSettings.pending[k] = v
  end

  local success = love.window.setMode(w, h, flags)
  if success then
    FlexLove.resize()
    self:rebuildUI()

    self.isConfirming = true
    self.confirmationTimer = 30
    self.modalIndex = 1
    self:createConfirmationOverlay()
    self:updateButtonStates()
  else
    print("Failed to set window mode")
  end
end

function settingsScene:confirmSettings()
  self.isConfirming = false
  for k, v in pairs(self.pendingSettings) do
    self.currentSettings[k] = v
  end
  if self.confirmationOverlay then
    self.confirmationOverlay:destroy()
    self.confirmationOverlay = nil
  end
end

function settingsScene:revertSettings()
  self.isConfirming = false
  if self.oldSettings then
    love.window.setMode(self.oldSettings.w, self.oldSettings.h, self.oldSettings.flags)
    FlexLove.resize()

    for k, v in pairs(self.oldSettings.pending) do
      self.pendingSettings[k] = v
      self.currentSettings[k] = v
    end
    self:initSettings()
    self:rebuildUI()
  end
  if self.confirmationOverlay then
    self.confirmationOverlay:destroy()
    self.confirmationOverlay = nil
  end
end

function settingsScene:rebuildUI()
  if self.rootElement then
    self.rootElement:destroy()
  end
  self:createUI()
end

function settingsScene:createUI()
  self.rootElement = FlexLove.new({
    width = "100%",
    height = "100%",
    backgroundColor = Color.new(0.05, 0.05, 0.08, 1),
    positioning = "flex",
    flexDirection = "column",
    justifyContent = "center",
    alignItems = "center",
    padding = { horizontal = 40, vertical = 20 }
  })

  local title = FlexLove.new({
    parent = self.rootElement,
    width = 600,
    height = 60,
    backgroundColor = Color.new(0.15, 0.15, 0.25, 1),
    borderRadius = 10,
    text = "Settings",
    textSize = "3xl",
    textColor = COLORS.ACCENT,
    justifyContent = "center",
    alignItems = "center",
    margin = { bottom = 20 }
  })

  local settingsContainer = FlexLove.new({
    parent = self.rootElement,
    width = 700,
    height = "60%",
    positioning = "flex",
    flexDirection = "column",
    gap = 5,
    padding = { vertical = 10, horizontal = 10 },
    backgroundColor = Color.new(0.1, 0.1, 0.15, 0.5),
    borderRadius = 8
  })

  self.elements.rows = {}
  for i, opt in ipairs(self.options) do
    local row = FlexLove.new({
      parent = settingsContainer,
      width = "100%",
      height = 40,
      positioning = "flex",
      flexDirection = "horizontal",
      justifyContent = "space-between",
      alignItems = "center",
      padding = { horizontal = 20 },
      borderRadius = 4,
      onEvent = function(elem, event)
        -- Only update selection on hover, don't block events for children
        if event.type == "hover" and not self.isConfirming then
          self.selectedIndex = i
          self:updateButtonStates()
        end
      end
    })

    local label = FlexLove.new({
      parent = row,
      text = opt.label,
      textSize = "lg",
      textColor = COLORS.NORMAL,
      width = "40%"
    })

    local selectorContainer = FlexLove.new({
      parent = row,
      width = "50%",
      height = "100%",
      positioning = "flex",
      flexDirection = "horizontal",
      justifyContent = "space-between",
      alignItems = "center"
    })

    -- Arrows now use higher zIndex and dedicated onEvent handlers
    local leftArrow = FlexLove.new({
      parent = selectorContainer,
      themeComponent = "buttonv2",
      text = "<",
      textSize = "xl",
      textColor = COLORS.ACCENT,
      width = 50,
      height = "100%",
      textAlign = "center",
      justifyContent = "center",
      alignItems = "center",
      zIndex = 10, -- Ensure it's above the row
      onEvent = function(elem, event)
        if event.type == "release" and not self.isConfirming then
          self:changeValue(i, -1)
          return true -- Consume event
        elseif event.type == "hover" then
          self.selectedIndex = i
          self:updateButtonStates()
        end
      end
    })

    local valueText = FlexLove.new({
      parent = selectorContainer,
      text = opt.values[opt.currentIndex],
      textSize = "lg",
      textColor = COLORS.HOVER,
      textAlign = "center",
      width = "40%"
    })

    local rightArrow = FlexLove.new({
      parent = selectorContainer,
      themeComponent = "buttonv2",
      text = ">",
      textSize = "xl",
      textColor = COLORS.ACCENT,
      width = 50,
      height = "100%",
      textAlign = "center",
      justifyContent = "center",
      alignItems = "center",
      zIndex = 10, -- Ensure it's above the row
      onEvent = function(elem, event)
        if event.type == "release" and not self.isConfirming then
          self:changeValue(i, 1)
          return true -- Consume event
        elseif event.type == "hover" then
          self.selectedIndex = i
          self:updateButtonStates()
        end
      end
    })

    row.labelElem = label
    row.valueElem = valueText
    self.elements.rows[i] = row
  end

  local buttonContainer = FlexLove.new({
    parent = self.rootElement,
    width = 700,
    height = 80,
    positioning = "flex",
    flexDirection = "horizontal",
    justifyContent = "center",
    gap = 40,
    margin = { top = 20 }
  })

  self.elements.applyBtn = FlexLove.new({
    parent = buttonContainer,
    width = 200,
    height = 50,
    themeComponent = "buttonv2",
    text = "Apply",
    textSize = "xl",
    textColor = COLORS.NORMAL,
    onEvent = function(elem, event)
      if event.type == "hover" and not self.isConfirming then
        self.selectedIndex = #self.options + 1
        self:updateButtonStates()
      elseif event.type == "release" and not self.isConfirming then
        self:applySettings()
      end
    end
  })

  self.elements.backBtn = FlexLove.new({
    parent = buttonContainer,
    width = 200,
    height = 50,
    themeComponent = "buttonv2",
    text = "Back",
    textSize = "xl",
    textColor = COLORS.NORMAL,
    onEvent = function(elem, event)
      if event.type == "hover" and not self.isConfirming then
        self.selectedIndex = #self.options + 2
        self:updateButtonStates()
      elseif event.type == "release" and not self.isConfirming then
        manager:enter(mainMenu)
      end
    end
  })

  self:updateButtonStates()
end

function settingsScene:createConfirmationOverlay()
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
    text = "Keep changes?",
    textSize = "2xl",
    textColor = COLORS.HOVER
  })

  self.elements.timerText = FlexLove.new({
    parent = dialog,
    text = "Reverting in 30 seconds...",
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
    text = "Keep",
    onEvent = function(_, event)
      if event.type == "hover" then
        self.modalIndex = 1
        self:updateButtonStates()
      elseif event.type == "release" then
        self:confirmSettings()
      end
    end
  })

  self.elements.revertBtn = FlexLove.new({
    parent = btnRow,
    width = 150,
    height = 50,
    themeComponent = "buttonv2",
    text = "Revert",
    onEvent = function(_, event)
      if event.type == "hover" then
        self.modalIndex = 2
        self:updateButtonStates()
      elseif event.type == "release" then
        self:revertSettings()
      end
    end
  })
end

function settingsScene:enter(previous, ...)
  local w, h = love.graphics.getDimensions()
  FlexLove.init({
    theme = "metal",
    immediateMode = false,
    autoFrameManagement = true,
    baseScale = { width = w, height = h }
  })

  self:initSettings()
  self.pressedKeys = {}
  self:createUI()
  self.selectedIndex = 1
  self.isConfirming = false
end

function settingsScene:leave(next, ...)
  FlexLove.destroy()
  self.rootElement = nil
  self.confirmationOverlay = nil
end

function settingsScene:update(dt)
  FlexLove.update(dt)

  if self.isConfirming then
    self.confirmationTimer = self.confirmationTimer - dt
    if self.elements.timerText then
      self.elements.timerText.text = string.format("Reverting in %d seconds...", math.ceil(self.confirmationTimer))
    end

    if self.confirmationTimer <= 0 then
      self:revertSettings()
    end
  end
end

function settingsScene:draw()
  FlexLove.draw()
end

function settingsScene:keypressed(key)
  if not self.pressedKeys[key] then
    self.pressedKeys[key] = true
    if self.isConfirming then
      if key == "left" or key == "up" then
        self.modalIndex = 1
      elseif key == "right" or key == "down" then
        self.modalIndex = 2
      elseif key == "return" or key == "space" then
        if self.modalIndex == 1 then
          self:confirmSettings()
        else
          self:revertSettings()
        end
      elseif key == "escape" then
        self:revertSettings()
      end
      self:updateButtonStates()
      return
    end

    local totalItems = #self.options + 2

    if key == "up" then
      self.selectedIndex = self.selectedIndex - 1
      if self.selectedIndex < 1 then self.selectedIndex = totalItems end
    elseif key == "down" then
      self.selectedIndex = self.selectedIndex + 1
      if self.selectedIndex > totalItems then self.selectedIndex = 1 end
    elseif key == "left" then
      if self.selectedIndex <= #self.options then
        self:changeValue(self.selectedIndex, -1)
      end
    elseif key == "right" then
      if self.selectedIndex <= #self.options then
        self:changeValue(self.selectedIndex, 1)
      end
    elseif key == "return" or key == "space" then
      if self.selectedIndex == #self.options + 1 then
        self:applySettings()
      elseif self.selectedIndex == #self.options + 2 then
        manager:enter(mainMenu)
      end
    elseif key == "escape" then
      manager:enter(mainMenu)
    end

    self:updateButtonStates()
  end
end

function settingsScene:keyreleased(key)
  if self.pressedKeys[key] then
    self.pressedKeys[key] = nil
    if key == "return" or key == "space" then
      if self.isConfirming then
        if self.modalIndex == 1 then
          self:confirmSettings()
        else
          self:revertSettings()
        end
      elseif self.selectedIndex == #self.options + 1 then
        self:applySettings()
      elseif self.selectedIndex == #self.options + 2 then
        manager:enter(mainMenu)
      end
    elseif key == "escape" then
      manager:enter(mainMenu)
    end
  end
end

return settingsScene
