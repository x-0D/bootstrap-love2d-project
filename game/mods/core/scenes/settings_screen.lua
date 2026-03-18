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
  pressedKeys = {},
  currentCategory = "Graphics",
  -- Animation state
  selectionY = 0,
  targetSelectionY = 0,
  selectionOpacity = 0,
  categoryOpacity = 0
}

-- AAA Visual Constants
local COLORS = {
  BACKGROUND = Color.new(0.02, 0.02, 0.03, 1),
  PANEL = Color.new(0.05, 0.05, 0.07, 0.8),
  ACCENT = Color.new(0.3, 0.8, 1, 1),
  NORMAL = Color.new(0.7, 0.7, 0.7, 1),
  HOVER = Color.new(1, 1, 1, 1),
  SELECTED = Color.new(0.3, 0.8, 1, 0.2),
  DANGER = Color.new(1, 0.3, 0.3, 1)
}

local CATEGORIES = {
  { id = "Graphics", icon = "G" },
  { id = "Audio", icon = "A" },
  { id = "Gameplay", icon = "P" },
  { id = "Controls", icon = "C" }
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
    hidpi = flags.highdpi and "On" or "Off",
    master_vol = 80,
    music_vol = 70,
    sfx_vol = 90
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

  -- Group options by category
  self.categories = {
    Graphics = {
      { key = "resolution", label = "Resolution", type = "selector", values = resolutions, currentIndex = resIdx },
      { key = "mode", label = "Display Mode", type = "selector", values = { "Windowed", "Fullscreen", "Borderless" }, currentIndex = 1 },
      { key = "vsync", label = "VSync", type = "selector", values = { "On", "Off" }, currentIndex = flags.vsync and 1 or 2 },
      { key = "fps", label = "FPS Cap", type = "selector", values = { "30", "60", "120", "144", "240", "Unlimited" }, currentIndex = 6 },
      { key = "msaa", label = "MSAA", type = "selector", values = { "0", "2", "4", "8", "16" }, currentIndex = 1 },
      { key = "hidpi", label = "HiDPI", type = "selector", values = { "On", "Off" }, currentIndex = flags.highdpi and 1 or 2 }
    },
    Audio = {
      { key = "master_vol", label = "Master Volume", type = "slider", min = 0, max = 100, value = 80 },
      { key = "music_vol", label = "Music Volume", type = "slider", min = 0, max = 100, value = 70 },
      { key = "sfx_vol", label = "SFX Volume", type = "slider", min = 0, max = 100, value = 90 }
    },
    Gameplay = {
      { key = "language", label = "Language", type = "selector", values = { "English", "Russian", "Spanish" }, currentIndex = 1 },
      { key = "tutorial", label = "Show Tutorials", type = "selector", values = { "Yes", "No" }, currentIndex = 1 }
    },
    Controls = {
      { key = "invert_y", label = "Invert Y Axis", type = "selector", values = { "Off", "On" }, currentIndex = 1 },
      { key = "sensitivity", label = "Mouse Sensitivity", type = "slider", min = 1, max = 100, value = 50 }
    }
  }

  -- Sync indices
  for i, v in ipairs(self.categories.Graphics[2].values) do
    if v == self.currentSettings.mode then self.categories.Graphics[2].currentIndex = i; break end
  end
  for i, v in ipairs(self.categories.Graphics[5].values) do
    if v == self.currentSettings.msaa then self.categories.Graphics[5].currentIndex = i; break end
  end

  self.options = self.categories[self.currentCategory]
end

function settingsScene:updateButtonStates()
  if self.isConfirming then
    local buttons = { self.elements.keepBtn, self.elements.revertBtn }
    for i, btn in ipairs(buttons) do
      if btn then
        local isSelected = (self.modalIndex == i)
        btn.textColor = isSelected and COLORS.HOVER or COLORS.NORMAL
        btn.backgroundColor = isSelected and COLORS.ACCENT or Color.new(0.2, 0.2, 0.2, 0.5)
        if btn._themeManager then
          btn._themeManager:setState(isSelected and "hover" or "normal")
        end
      end
    end
    return
  end

  -- Update category tabs
  if self.elements.tabs then
    for i, tab in ipairs(self.elements.tabs) do
      local isCurrent = (CATEGORIES[i].id == self.currentCategory)
      tab.backgroundColor = isCurrent and COLORS.ACCENT or Color.new(0, 0, 0, 0)
      tab.label.textColor = isCurrent and COLORS.HOVER or COLORS.NORMAL
    end
  end

  -- Update settings rows
  if self.elements.rows then
    local totalOptions = #self.options
    for i = 1, totalOptions do
      local row = self.elements.rows[i]
      local isSelected = (i == self.selectedIndex)
      if row then
        row.label.textColor = isSelected and COLORS.HOVER or COLORS.NORMAL
        -- Row highlight is now handled by smooth selectionHighlight element
      end
    end
  end

  -- Update footer buttons
  local footerBtns = { self.elements.applyBtn, self.elements.backBtn }
  local totalOptions = #self.options
  for i, btn in ipairs(footerBtns) do
    if btn then
      local isSelected = (self.selectedIndex == totalOptions + i)
      btn.textColor = isSelected and COLORS.HOVER or COLORS.NORMAL
      btn.backgroundColor = isSelected and COLORS.ACCENT or Color.new(0.1, 0.1, 0.1, 0.5)
      if btn._themeManager then
        btn._themeManager:setState(isSelected and "hover" or "normal")
      end
    end
  end
end

function settingsScene:changeValue(optionIdx, delta)
  local opt = self.options[optionIdx]
  if opt.type == "selector" then
    opt.currentIndex = opt.currentIndex + delta
    if opt.currentIndex < 1 then opt.currentIndex = #opt.values end
    if opt.currentIndex > #opt.values then opt.currentIndex = 1 end
    local newValue = opt.values[opt.currentIndex]
    self.pendingSettings[opt.key] = newValue
    if self.elements.rows[optionIdx] and self.elements.rows[optionIdx].valueText then
      self.elements.rows[optionIdx].valueText.text = newValue
    end
  elseif opt.type == "slider" then
    opt.value = math.max(opt.min, math.min(opt.max, opt.value + delta))
    self.pendingSettings[opt.key] = opt.value
    if self.elements.rows[optionIdx] and self.elements.rows[optionIdx].valueText then
      self.elements.rows[optionIdx].valueText.text = tostring(math.floor(opt.value))
    end
  end
end

function settingsScene:applySettings()
  if self.currentCategory ~= "Graphics" then
    -- For non-graphics, just save immediately
    for k, v in pairs(self.pendingSettings) do
      self.currentSettings[k] = v
    end
    return
  end

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
    self.confirmationTimer = 15 -- AAA standard is usually shorter
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

function settingsScene:switchCategory(catId)
  if self.currentCategory == catId then return end
  self.currentCategory = catId
  self.options = self.categories[self.currentCategory]
  self.selectedIndex = 1
  self:rebuildUI()
end

local function getResponsiveScale()
  local w = love.graphics.getWidth()
  if w < 1024 then return 0.6
  elseif w < 1280 then return 0.8
  elseif w < 1600 then return 0.9
  end
  return 1.0
end

function settingsScene:createUI()
  local scale = getResponsiveScale()
  local isNarrow = love.graphics.getWidth() < 1280

  -- Root Background
  self.rootElement = FlexLove.new({
    width = "100%",
    height = "100%",
    backgroundColor = COLORS.BACKGROUND,
    positioning = "flex",
    flexDirection = "column",
    justifyContent = "space-between" -- Push header and footer to edges
  })

  -- Header Section (AAA Style Tabs)
  local headerHeight = 80 * scale
  local header = FlexLove.new({
    parent = self.rootElement,
    width = "100%",
    height = headerHeight,
    backgroundColor = Color.new(0, 0, 0, 0.4),
    positioning = "flex",
    flexDirection = "row",
    alignItems = "flex-end",
    padding = { horizontal = 60 * scale }
  })

  FlexLove.new({
    parent = header,
    text = "SETTINGS",
    textSize = tostring(math.floor(36 * scale)) .. "px",
    textColor = COLORS.HOVER,
    margin = { right = 60 * scale, bottom = 15 * scale }
  })

  self.elements.tabs = {}
  for i, cat in ipairs(CATEGORIES) do
    local tab = FlexLove.new({
      parent = header,
      height = 50 * scale,
      padding = { horizontal = 30 * scale },
      margin = { right = 10 * scale },
      positioning = "flex",
      justifyContent = "center",
      alignItems = "center",
      borderRadius = { topLeft = 8, topRight = 8 },
      onEvent = function(_, event)
        if event.type == "release" then
          self.categoryOpacity = 0 -- Reset fade for transition
          self:switchCategory(cat.id)
        end
      end
    })
    tab.label = FlexLove.new({
      parent = tab,
      text = cat.id:upper(),
      textSize = tostring(math.floor(18 * scale)) .. "px"
    })
    self.elements.tabs[i] = tab
  end

  -- Main Content Area
  local mainContent = FlexLove.new({
    parent = self.rootElement,
    width = "100%",
    height = "75%", -- Fixed percentage to leave room for header/footer
    positioning = "flex",
    flexDirection = isNarrow and "column" or "row",
    padding = { horizontal = 60 * scale, vertical = 20 * scale }, -- Reduced vertical padding
    gap = 40 * scale
  })

  -- Settings List (Left Side)
  local settingsList = FlexLove.new({
    parent = mainContent,
    width = isNarrow and "100%" or "65%",
    height = isNarrow and "60%" or "100%",
    positioning = "flex",
    flexDirection = "column",
    gap = 8 * scale
  })

  -- Smooth Selection Highlight
  self.elements.selectionHighlight = FlexLove.new({
    parent = settingsList,
    width = "100%",
    height = 60 * scale,
    backgroundColor = COLORS.SELECTED,
    borderRadius = 4,
    border = { left = true },
    borderWidth = 4,
    borderColor = COLORS.ACCENT,
    positioning = "absolute",
    zIndex = -1, -- Behind the rows
    opacity = self.selectionOpacity
  })

  self.elements.rows = {}
  for i, opt in ipairs(self.options) do
    local rowHeight = 60 * scale
    local row = FlexLove.new({
      parent = settingsList,
      width = "100%",
      height = rowHeight,
      positioning = "flex",
      flexDirection = "row",
      justifyContent = "space-between",
      alignItems = "center",
      padding = { horizontal = 30 * scale },
      borderRadius = 4,
      border = { left = true },
      borderWidth = 4,
      opacity = self.categoryOpacity -- Use animation state
    })

    -- Label area (non-interactive)
    row.label = FlexLove.new({
      parent = row,
      text = opt.label,
      textSize = tostring(math.floor(20 * scale)) .. "px",
      width = "40%",
      interactive = false
    })

    -- Control area (container for interactive elements)
    local control = FlexLove.new({
      parent = row,
      width = "50%",
      height = "100%",
      positioning = "flex",
      flexDirection = "row",
      justifyContent = "center",
      alignItems = "center",
      gap = 20 * scale,
      zIndex = 10 -- Ensure children stay on top of selectionHitArea
    })

    -- Selection Hit Area - Now covers the WHOLE row but stays BEHIND the control area
    -- This ensures we can hover anywhere to select, but click through to controls
    local selectionHitArea = FlexLove.new({
      parent = row,
      width = "100%",
      height = "100%",
      positioning = "absolute",
      left = 0,
      top = 0,
      zIndex = 1, -- Behind control but covers label
      onEvent = function(_, event)
        if event.type == "hover" then
          self.selectedIndex = i
          self:updateButtonStates()
        end
      end
    })

    if opt.type == "selector" then
      -- Left Arrow
      FlexLove.new({
        parent = control,
        themeComponent = "buttonv2",
        text = "<",
        textSize = tostring(math.floor(24 * scale)) .. "px",
        textColor = COLORS.ACCENT,
        width = 40 * scale,
        height = 40 * scale,
        onEvent = function(_, event)
          if event.type == "hover" then
            self.selectedIndex = i
            self:updateButtonStates()
          elseif event.type == "release" then
            self:changeValue(i, -1)
            return true
          end
        end
      })

      row.valueText = FlexLove.new({
        parent = control,
        text = opt.values[opt.currentIndex],
        textSize = tostring(math.floor(18 * scale)) .. "px",
        textColor = COLORS.HOVER,
        textAlign = "center",
        width = "60%",
        interactive = false
      })

      -- Right Arrow
      FlexLove.new({
        parent = control,
        themeComponent = "buttonv2",
        text = ">",
        textSize = tostring(math.floor(24 * scale)) .. "px",
        textColor = COLORS.ACCENT,
        width = 40 * scale,
        height = 40 * scale,
        onEvent = function(_, event)
          if event.type == "hover" then
            self.selectedIndex = i
            self:updateButtonStates()
          elseif event.type == "release" then
            self:changeValue(i, 1)
            return true
          end
        end
      })
    elseif opt.type == "slider" then
      -- Adjust buttons for sliders
      FlexLove.new({
        parent = control,
        themeComponent = "buttonv2",
        text = "-",
        textSize = tostring(math.floor(24 * scale)) .. "px",
        textColor = COLORS.ACCENT,
        width = 40 * scale,
        height = 40 * scale,
        onEvent = function(_, event)
          if event.type == "hover" then
            self.selectedIndex = i
            self:updateButtonStates()
          elseif event.type == "release" then
            self:changeValue(i, -5)
            return true
          end
        end
      })

      local sliderBg = FlexLove.new({
        parent = control,
        width = "60%",
        height = 10 * scale,
        backgroundColor = Color.new(0.2, 0.2, 0.2, 1),
        borderRadius = 5,
        positioning = "flex",
        justifyContent = "flex-start",
        alignItems = "center",
        interactive = false
      })

      local fillWidth = (opt.value - opt.min) / (opt.max - opt.min) * 100
      FlexLove.new({
        parent = sliderBg,
        width = fillWidth .. "%",
        height = "100%",
        backgroundColor = COLORS.ACCENT,
        borderRadius = 5,
        interactive = false
      })

      row.valueText = FlexLove.new({
        parent = control,
        text = tostring(math.floor(opt.value)),
        textSize = tostring(math.floor(18 * scale)) .. "px",
        textColor = COLORS.HOVER,
        width = 60 * scale,
        textAlign = "center",
        interactive = false
      })

      FlexLove.new({
        parent = control,
        themeComponent = "buttonv2",
        text = "+",
        textSize = tostring(math.floor(24 * scale)) .. "px",
        textColor = COLORS.ACCENT,
        width = 40 * scale,
        height = 40 * scale,
        onEvent = function(_, event)
          if event.type == "hover" then
            self.selectedIndex = i
            self:updateButtonStates()
          elseif event.type == "release" then
            self:changeValue(i, 5)
            return true
          end
        end
      })
    end

    self.elements.rows[i] = row
  end

  -- Info Panel (Right Side)
  local infoPanel = FlexLove.new({
    parent = mainContent,
    width = isNarrow and "100%" or "30%",
    height = isNarrow and "30%" or "100%",
    backgroundColor = COLORS.PANEL,
    borderRadius = 8,
    padding = 40 * scale,
    positioning = "flex",
    flexDirection = "column",
    gap = 20 * scale
  })

  FlexLove.new({
    parent = infoPanel,
    text = "DESCRIPTION",
    textSize = tostring(math.floor(18 * scale)) .. "px",
    textColor = COLORS.ACCENT
  })

  self.elements.descText = FlexLove.new({
    parent = infoPanel,
    text = "Select a setting to see its description and impact on performance.",
    textSize = tostring(math.floor(16 * scale)) .. "px",
    textColor = COLORS.NORMAL,
    width = "100%"
  })

  -- Footer Navigation
  local footerHeight = 100 * scale
  local footer = FlexLove.new({
    parent = self.rootElement,
    width = "100%",
    height = footerHeight,
    backgroundColor = Color.new(0, 0, 0, 0.6),
    positioning = "flex",
    flexDirection = "row",
    justifyContent = "flex-end",
    alignItems = "center",
    padding = { horizontal = 60 * scale },
    gap = 20 * scale
  })

  self.elements.applyBtn = FlexLove.new({
    parent = footer,
    width = 180 * scale,
    height = 50 * scale,
    themeComponent = "buttonv2",
    text = "APPLY CHANGES",
    borderRadius = 4,
    onEvent = function(_, event)
      if event.type == "hover" then
        self.selectedIndex = #self.options + 1
        self:updateButtonStates()
      elseif event.type == "release" then
        self:applySettings()
      end
    end
  })

  self.elements.backBtn = FlexLove.new({
    parent = footer,
    width = 180 * scale,
    height = 50 * scale,
    themeComponent = "buttonv2",
    text = "BACK",
    borderRadius = 4,
    onEvent = function(_, event)
      if event.type == "hover" then
        self.selectedIndex = #self.options + 2
        self:updateButtonStates()
      elseif event.type == "release" then
        local menu = modSystem.getScene("main_menu")
        if menu then manager:enter(menu) end
      end
    end
  })

  -- Navigation Hints
  local hintsContainer = FlexLove.new({
    parent = self.rootElement,
    width = "100%",
    height = 40 * scale,
    backgroundColor = Color.new(0, 0, 0, 0.8),
    positioning = "flex",
    flexDirection = "row",
    justifyContent = "center",
    alignItems = "center",
    gap = 30 * scale
  })

  local hintStyle = {
    textSize = tostring(math.floor(14 * scale)) .. "px",
    textColor = Color.new(0.6, 0.6, 0.6, 1)
  }

  local hints = {
    { key = "ARROWS", action = "Navigate" },
    { key = "ENTER", action = "Select/Apply" },
    { key = "Q/E", action = "Switch Tabs" },
    { key = "ESC", action = "Back" }
  }

  for _, hint in ipairs(hints) do
    local h = FlexLove.new({
      parent = hintsContainer,
      positioning = "flex",
      flexDirection = "row",
      gap = 8 * scale
    })
    FlexLove.new({
      parent = h,
      text = hint.key,
      textSize = hintStyle.textSize,
      textColor = COLORS.ACCENT,
      backgroundColor = Color.new(0.2, 0.2, 0.2, 1),
      padding = { horizontal = 6, vertical = 2 },
      borderRadius = 4
    })
    FlexLove.new({
      parent = h,
      text = hint.action,
      textSize = hintStyle.textSize,
      textColor = hintStyle.textColor
    })
  end

  self:updateButtonStates()
end

function settingsScene:createConfirmationOverlay()
  self.confirmationOverlay = FlexLove.new({
    width = "100%",
    height = "100%",
    backgroundColor = Color.new(0, 0, 0, 0.9),
    positioning = "flex",
    flexDirection = "column",
    justifyContent = "center",
    alignItems = "center",
    zIndex = 100
  })

  local dialog = FlexLove.new({
    parent = self.confirmationOverlay,
    width = 600,
    height = 350,
    backgroundColor = COLORS.PANEL,
    borderRadius = 4,
    border = { top = true },
    borderWidth = 4,
    borderColor = COLORS.ACCENT,
    positioning = "flex",
    flexDirection = "column",
    justifyContent = "center",
    alignItems = "center",
    padding = 60,
    gap = 30
  })

  FlexLove.new({
    parent = dialog,
    text = "KEEP THESE DISPLAY SETTINGS?",
    textSize = "2xl",
    textColor = COLORS.HOVER
  })

  self.elements.timerText = FlexLove.new({
    parent = dialog,
    text = "Reverting in 15 seconds...",
    textSize = "lg",
    textColor = COLORS.NORMAL
  })

  local btnRow = FlexLove.new({
    parent = dialog,
    width = "100%",
    height = 60,
    positioning = "flex",
    flexDirection = "row",
    justifyContent = "center",
    gap = 20
  })

  self.elements.keepBtn = FlexLove.new({
    parent = btnRow,
    width = 200,
    height = 50,
    themeComponent = "buttonv2",
    text = "KEEP CHANGES",
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
    width = 200,
    height = 50,
    themeComponent = "buttonv2",
    text = "REVERT",
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
  self.categoryOpacity = 0 -- Initial fade-in
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

  -- Smooth Selection Animation
  local isOptionSelected = (self.selectedIndex <= #self.options)
  local row = isOptionSelected and self.elements.rows and self.elements.rows[self.selectedIndex]

  if row then
    self.targetSelectionY = row.y or 0
    self.selectionOpacity = math.min(1, self.selectionOpacity + dt * 10)
  else
    self.selectionOpacity = math.max(0, self.selectionOpacity - dt * 10)
  end

  -- Lerp selection Y position
  self.selectionY = self.selectionY + (self.targetSelectionY - self.selectionY) * dt * 15
  if self.elements.selectionHighlight then
    self.elements.selectionHighlight.y = self.selectionY
    self.elements.selectionHighlight.opacity = self.selectionOpacity
  end

  -- Fade in category content
  self.categoryOpacity = math.min(1, self.categoryOpacity + dt * 3)
  if self.elements.rows then
    for _, row in ipairs(self.elements.rows) do
      row.opacity = self.categoryOpacity
    end
  end

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
      if key == "left" or key == "up" then self.modalIndex = 1
      elseif key == "right" or key == "down" then self.modalIndex = 2
      elseif key == "return" or key == "space" then
        if self.modalIndex == 1 then self:confirmSettings() else self:revertSettings() end
      elseif key == "escape" then self:revertSettings() end
      self:updateButtonStates()
      return
    end

    -- Tab Navigation (LB/RB style)
    if key == "l1" or key == "q" then
       local idx = 1
       for i, c in ipairs(CATEGORIES) do if c.id == self.currentCategory then idx = i; break end end
       idx = idx - 1; if idx < 1 then idx = #CATEGORIES end
       self:switchCategory(CATEGORIES[idx].id)
       return
    elseif key == "r1" or key == "e" then
       local idx = 1
       for i, c in ipairs(CATEGORIES) do if c.id == self.currentCategory then idx = i; break end end
       idx = idx + 1; if idx > #CATEGORIES then idx = 1 end
       self:switchCategory(CATEGORIES[idx].id)
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
      if self.selectedIndex <= #self.options then self:changeValue(self.selectedIndex, -1) end
    elseif key == "right" then
      if self.selectedIndex <= #self.options then self:changeValue(self.selectedIndex, 1) end
    elseif key == "return" or key == "space" then
      if self.selectedIndex == #self.options + 1 then self:applySettings()
      elseif self.selectedIndex == #self.options + 2 then
        local menu = modSystem.getScene("main_menu")
        if menu then manager:enter(menu) end
      end
    elseif key == "escape" then
      local menu = modSystem.getScene("main_menu")
      if menu then manager:enter(menu) end
    end

    self:updateButtonStates()
  end
end

function settingsScene:keyreleased(key)
  if self.pressedKeys[key] then
    self.pressedKeys[key] = nil
  end
end

return settingsScene
