local roomy = require "libs.roomy"
local json = require "libs.json"
local FlexLove = require "libs.FlexLove"
local Color = require "libs.modules.Color"

local settingsScene = {}

local CATEGORIES = {
  { id = "Gameplay", label = "GAMEPLAY" },
  { id = "Graphics", label = "GRAPHICS" },
  { id = "Audio", label = "AUDIO" },
  { id = "Controls", label = "CONTROLS" }
}

local OPTIONS = {
  Gameplay = {
    { key = "difficulty", label = "Difficulty", type = "selector", values = { "Easy", "Normal", "Hard", "Insane" }, currentIndex = 2 },
    { key = "language", label = "Language", type = "language_selector", values = { "en", "ru", "fr", "de", "es" }, currentIndex = 1 },
    { key = "subtitles", label = "Subtitles", type = "selector", values = { "On", "Off" }, currentIndex = 1 },
    { key = "hints", label = "Hints", type = "selector", values = { "On", "Off" }, currentIndex = 1 },
    { key = "speedrun_timer", label = "Speedrun Timer", type = "selector", values = { "Off", "On" }, currentIndex = 1 },
    { key = "auto_save", label = "Auto-Save", type = "selector", values = { "On", "Off" }, currentIndex = 1 }
  },
  Graphics = {
    { key = "resolution", label = "Resolution", type = "selector", values = { "1280x720", "1920x1080", "2560x1440", "3840x2160" }, currentIndex = 2 },
    { key = "mode", label = "Display Mode", type = "selector", values = { "Windowed", "Borderless", "Fullscreen" }, currentIndex = 1 },
    { key = "vsync", label = "VSync", type = "selector", values = { "On", "Off" }, currentIndex = 1 },
    { key = "msaa", label = "Anti-Aliasing", type = "selector", values = { "0", "2", "4", "8" }, currentIndex = 2 },
    { key = "hidpi", label = "High DPI", type = "selector", values = { "On", "Off" }, currentIndex = 1 },
    { key = "brightness", label = "Brightness", type = "slider", min = 0, max = 100, value = 50 }
  },
  Audio = {
    { key = "master_vol", label = "Master Volume", type = "slider", min = 0, max = 100, value = 80 },
    { key = "music_vol", label = "Music Volume", type = "slider", min = 0, max = 100, value = 70 },
    { key = "sfx_vol", label = "SFX Volume", type = "slider", min = 0, max = 100, value = 90 },
    { key = "voice_vol", label = "Voice Volume", type = "slider", min = 0, max = 100, value = 80 },
    { key = "mute_unfocused", label = "Mute when Unfocused", type = "selector", values = { "On", "Off" }, currentIndex = 1 }
  },
  Controls = {
    { key = "invert_y", label = "Invert Y-Axis", type = "selector", values = { "Off", "On" }, currentIndex = 1 },
    { key = "sensitivity", label = "Mouse Sensitivity", type = "slider", min = 1, max = 20, value = 10 },
    { key = "rumble", label = "Controller Rumble", type = "selector", values = { "On", "Off" }, currentIndex = 1 },
    { key = "hold_to_aim", label = "Hold to Aim", type = "selector", values = { "On", "Off" }, currentIndex = 1 }
  }
}

local COLORS = {
  BACKGROUND = Color.new(0.05, 0.05, 0.07, 1),
  PANEL = Color.new(0.12, 0.12, 0.15, 0.95),
  ACCENT = Color.new(0.2, 0.6, 1, 1),
  HOVER = Color.new(1, 1, 1, 1),
  NORMAL = Color.new(0.6, 0.6, 0.6, 1),
  SELECTED = Color.new(1, 1, 1, 0.15),
  SUCCESS = Color.new(0.2, 0.8, 0.2, 1)
}

local function getResponsiveScale()
  local w = love.graphics.getWidth()
  if w < 1024 then return 0.6
  elseif w < 1280 then return 0.8
  elseif w < 1600 then return 0.9
  end
  return 1.0
end

function settingsScene:initSettings()
  self.currentSettings = {
    difficulty = "Normal",
    language = "en",
    availableLocales = { "en", "ru", "fr", "de", "es" },
    chosenLocales = { "en" },
    subtitles = "On",
    hints = "On",
    speedrun_timer = "Off",
    auto_save = "On",
    resolution = "1920x1080",
    mode = "Windowed",
    vsync = "On",
    msaa = "2",
    hidpi = "On",
    brightness = 50,
    master_vol = 80,
    music_vol = 70,
    sfx_vol = 90,
    voice_vol = 80,
    mute_unfocused = "On",
    invert_y = "Off",
    sensitivity = 10,
    rumble = "On",
    hold_to_aim = "On"
  }

  local info = love.filesystem.getInfo("settings.json")
  if info then
    local content = love.filesystem.read("settings.json")
    local saved = json.decode(content)
    for k, v in pairs(saved) do
      self.currentSettings[k] = v
    end
  end

  self.pendingSettings = {}
  for k, v in pairs(self.currentSettings) do
    if type(v) == "table" then
      self.pendingSettings[k] = {}
      for i, val in ipairs(v) do self.pendingSettings[k][i] = val end
    else
      self.pendingSettings[k] = v
    end
  end

  self.categories = {}
  for catId, opts in pairs(OPTIONS) do
    self.categories[catId] = {}
    for i, opt in ipairs(opts) do
      local cloned = {}
      for k, v in pairs(opt) do cloned[k] = v end

      local currentVal = self.pendingSettings[opt.key]
      if opt.type == "selector" or opt.type == "language_selector" then
        for idx, val in ipairs(opt.values) do
          if val == currentVal then cloned.currentIndex = idx; break end
        end
      elseif opt.type == "slider" then
        cloned.value = currentVal or opt.value
      end
      table.insert(self.categories[catId], cloned)
    end
  end

  self.currentCategory = "Gameplay"
  self.options = self.categories[self.currentCategory]
  self.selectedIndex = 1
  self.selectionY = 0
  self.targetSelectionY = 0
  self.targetSelectionHeight = 70
  self.selectionOpacity = 1
  self.categoryOpacity = 0
  self.langSelectionPane = "available"
  self.langSelectedIndex = 1
  self.isEditingLanguage = false
end

function settingsScene:changeValue(optionIdx, delta)
  local opt = self.options[optionIdx]
  if not opt then return end

  if opt.type == "selector" or opt.type == "language_selector" then
    opt.currentIndex = opt.currentIndex + delta
    if opt.currentIndex < 1 then opt.currentIndex = #opt.values
    elseif opt.currentIndex > #opt.values then opt.currentIndex = 1 end

    local newValue = opt.values[opt.currentIndex]
    self.pendingSettings[opt.key] = newValue
  elseif opt.type == "slider" then
    opt.value = math.max(opt.min, math.min(opt.max, opt.value + delta))
    self.pendingSettings[opt.key] = opt.value
  end
end

function settingsScene:moveLanguage(fromPane, idx)
  if fromPane == "available" then
    local lang = table.remove(self.pendingSettings.availableLocales, idx)
    table.insert(self.pendingSettings.chosenLocales, lang)
    self.langSelectionPane = "chosen"
    self.langSelectedIndex = #self.pendingSettings.chosenLocales
  else
    if #self.pendingSettings.chosenLocales <= 1 then return end
    local lang = table.remove(self.pendingSettings.chosenLocales, idx)
    table.insert(self.pendingSettings.availableLocales, lang)
    self.langSelectionPane = "available"
    self.langSelectedIndex = #self.pendingSettings.availableLocales
  end
end

function settingsScene:reorderLanguage(idx, delta)
  local list = self.pendingSettings.chosenLocales
  local newIdx = idx + delta
  if newIdx < 1 or newIdx > #list then return end
  list[idx], list[newIdx] = list[newIdx], list[idx]
  self.langSelectedIndex = newIdx
end

function settingsScene:applySettings()
  if #self.pendingSettings.chosenLocales > 0 then
    self.pendingSettings.language = self.pendingSettings.chosenLocales[1]
    local fallbacks = {}
    for i = 2, #self.pendingSettings.chosenLocales do
      table.insert(fallbacks, self.pendingSettings.chosenLocales[i])
    end
    self.pendingSettings.fallbacks = fallbacks
  end

  if self.currentCategory ~= "Graphics" then
    for k, v in pairs(self.pendingSettings) do
      self.currentSettings[k] = v
    end
    self:saveSettings()
    return
  end

  local w, h = self.pendingSettings.resolution:match("(%d+)x(%d+)")
  w, h = tonumber(w), tonumber(h)

  local isMac = (love.system.getOS() == "OS X")
  local fullscreentype = "desktop"
  if self.pendingSettings.mode == "Fullscreen" and not isMac then
    fullscreentype = "exclusive"
  end

  local flags = {
    fullscreen = (self.pendingSettings.mode ~= "Windowed"),
    fullscreentype = fullscreentype,
    vsync = (self.pendingSettings.vsync == "On" and 1 or 0),
    msaa = tonumber(self.pendingSettings.msaa),
    highdpi = (self.pendingSettings.hidpi == "On"),
    display = 1
  }

  if self.pendingSettings.mode == "Borderless" then
    flags.fullscreen = false
    flags.borderless = true
  end

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
    self.isConfirming = true
    self.confirmationTimer = 10
    self.modalIndex = 1
    self:rebuildUI()
  end
end

function settingsScene:saveSettings()
  local success, err = love.filesystem.write("settings.json", json.encode(self.currentSettings))
  if success then
    if love.audio then
      love.audio.setVolume(self.currentSettings.master_vol / 100)
    end
    if self.currentSettings.language then
      modSystem.i18n.setLocale(self.currentSettings.language)
      if self.currentSettings.fallbacks then
        modSystem.i18n.setFallbackLocale(self.currentSettings.fallbacks)
      end
    end
  end
end

function settingsScene:confirmSettings()
  self.isConfirming = false
  for k, v in pairs(self.pendingSettings) do
    self.currentSettings[k] = v
  end
  self:saveSettings()
  self:rebuildUI()
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
end

function settingsScene:switchCategory(catId)
  if self.currentCategory == catId then return end
  self.currentCategory = catId
  self.options = self.categories[self.currentCategory]
  self.selectedIndex = 1
  self.categoryOpacity = 0
end

function settingsScene:createUI()
  local scale = getResponsiveScale()
  local isNarrow = love.graphics.getWidth() < 1280

  -- Root Background
  self.elements.root = FlexLove.new({
    id = "settings_root",
    width = "100%",
    height = "100%",
    backgroundColor = COLORS.BACKGROUND,
    positioning = "flex",
    flexDirection = "column"
  })

  -- Header Section
  local headerHeight = 100 * scale
  local header = FlexLove.new({
    id = "settings_header",
    parent = self.elements.root,
    width = "100%",
    height = headerHeight,
    backgroundColor = Color.new(0, 0, 0, 0.6),
    positioning = "flex",
    flexDirection = "row",
    alignItems = "center",
    padding = { horizontal = 80 * scale },
    border = { bottom = true },
    borderWidth = 1,
    borderColor = Color.new(1, 1, 1, 0.1)
  })

  FlexLove.new({
    id = "settings_title",
    parent = header,
    text = modSystem.i18n.t("settings/title", nil, nil, "SETTINGS"),
    textSize = tostring(math.floor(42 * scale)) .. "px",
    textColor = COLORS.HOVER,
    margin = { right = 80 * scale }
  })

  local tabContainer = FlexLove.new({
    id = "settings_tab_container",
    parent = header,
    height = "100%",
    positioning = "flex",
    flexDirection = "row",
    alignItems = "center",
    gap = 20 * scale
  })

  self.elements.tabs = {}
  for i, cat in ipairs(CATEGORIES) do
    local isTabSelected = (self.currentCategory == cat.id)
    local tab = FlexLove.new({
      id = "settings_tab_" .. cat.id,
      parent = tabContainer,
      height = 60 * scale,
      padding = { horizontal = 40 * scale },
      positioning = "flex",
      justifyContent = "center",
      alignItems = "center",
      backgroundColor = isTabSelected and Color.new(1, 1, 1, 0.1) or nil,
      borderRadius = 30 * scale,
      border = isTabSelected and { bottom = true } or nil,
      borderWidth = 2,
      borderColor = COLORS.ACCENT,
      onEvent = function(_, event)
        if event.type == "hover" then
          if self.currentCategory ~= cat.id then
            self.isEditingLanguage = false
            self:switchCategory(cat.id)
            self:rebuildUI()
          end
        elseif event.type == "release" then
          self:switchCategory(cat.id)
          self:rebuildUI()
        end
      end
    })
    tab.label = FlexLove.new({
      id = "settings_tab_label_" .. cat.id,
      parent = tab,
      text = modSystem.i18n.t("settings/category/" .. cat.id:lower(), nil, nil, cat.id:upper()),
      textSize = tostring(math.floor(20 * scale)) .. "px",
      textColor = isTabSelected and COLORS.HOVER or COLORS.NORMAL
    })
    self.elements.tabs[i] = tab
  end

  -- Main Content Area
  local mainContent = FlexLove.new({
    id = "settings_main_content",
    parent = self.elements.root,
    width = "100%",
    flex = 1,
    positioning = "flex",
    flexDirection = isNarrow and "column" or "row",
    padding = { horizontal = 80 * scale, vertical = 40 * scale },
    gap = 60 * scale
  })

  -- Settings List
  local rowHeight = 70 * scale
  local rowGap = 12 * scale
  local listHeight = (#self.options * rowHeight) + ((#self.options - 1) * rowGap)
  self.elements.settings_list = FlexLove.new({
    id = "settings_list",
    parent = mainContent,
    width = isNarrow and "100%" or "60%",
    height = listHeight, -- Fixed height to prevent parent auto-sizing issues
    positioning = "flex",
    flexDirection = "column",
    gap = rowGap,
    opacity = self.categoryOpacity
  })

  -- Animation Targets
  if self.selectedIndex <= #self.options and not self.isConfirming then
    self.targetSelectionY = (self.selectedIndex - 1) * (rowHeight + rowGap)
    self.targetSelectionHeight = rowHeight
  else
    self.targetSelectionHeight = rowHeight
  end

  -- Selection Highlight
  self.elements.selectionHighlight = FlexLove.new({
    id = "settings_selection_highlight",
    parent = self.elements.settings_list,
    width = "100%",
    height = self.selectionHeight,
    y = self.selectionY,
    backgroundColor = COLORS.SELECTED,
    borderRadius = 8,
    border = { left = true },
    borderWidth = 6,
    borderColor = COLORS.ACCENT,
    positioning = "absolute",
    left = 0,
    top = 0,
    z = -1,
    opacity = (self.isEditingLanguage or self.isConfirming) and 0 or self.selectionOpacity
  })

  self.elements.rows = {}
  for i, opt in ipairs(self.options) do
    local row = FlexLove.new({
      id = "settings_row_" .. opt.key,
      parent = self.elements.settings_list,
      width = "100%",
      height = rowHeight,
      positioning = "flex",
      flexDirection = "row",
      justifyContent = "space-between",
      alignItems = "center",
      padding = { horizontal = 40 * scale },
      borderRadius = 8,
      interactive = false -- Row itself doesn't need to be interactive, handled by buttons and update()
    })
    self.elements.rows[i] = row

    self.elements["settings_row_label_" .. opt.key] = FlexLove.new({
      id = "settings_row_label_" .. opt.key,
      parent = row,
      text = modSystem.i18n.t("settings/option/" .. opt.key, nil, nil, opt.label),
      textSize = tostring(math.floor(22 * scale)) .. "px",
      textColor = (self.selectedIndex == i) and COLORS.HOVER or COLORS.NORMAL,
      width = "40%",
      interactive = false
    })

    local control = FlexLove.new({
      id = "settings_row_control_" .. opt.key,
      parent = row,
      width = "50%",
      height = "100%",
      positioning = "flex",
      flexDirection = "row",
      justifyContent = "center",
      alignItems = "center",
      gap = 30 * scale,
      z = 20 -- Ensure controls are above row background
    })

    if opt.type == "selector" then
      FlexLove.new({
        id = "settings_row_left_" .. opt.key,
        parent = control,
        themeComponent = "buttonv2",
        text = "<",
        textSize = tostring(math.floor(24 * scale)) .. "px",
        textAlign = "center",
        width = 50 * scale,
        height = 50 * scale,
        positioning = "flex",
        z = 21,
        onEvent = function(_, event)
          if event.type == "press" then
            return true
          elseif event.type == "release" then
            self:changeValue(i, -1)
            return true
          end
        end
      })

      local function getTranslatedValue(val)
        if opt.key == "language" or opt.key == "resolution" or tonumber(val) then return val end
        return modSystem.i18n.t("settings/value/" .. val:lower(), nil, nil, val)
      end

      self.elements["settings_row_value_" .. opt.key] = FlexLove.new({
        id = "settings_row_value_" .. opt.key,
        parent = control,
        text = getTranslatedValue(opt.values[opt.currentIndex]),
        textSize = tostring(math.floor(20 * scale)) .. "px",
        textColor = COLORS.HOVER,
        textAlign = "center",
        width = "50%",
        positioning = "flex",
        z = 21
      })

      FlexLove.new({
        id = "settings_row_right_" .. opt.key,
        parent = control,
        themeComponent = "buttonv2",
        text = ">",
        textSize = tostring(math.floor(24 * scale)) .. "px",
        textAlign = "center",
        width = 50 * scale,
        height = 50 * scale,
        positioning = "flex",
        z = 21,
        onEvent = function(_, event)
          if event.type == "press" then
            return true
          elseif event.type == "release" then
            self:changeValue(i, 1)
            return true
          end
        end
      })
    elseif opt.type == "slider" then
      FlexLove.new({
        id = "settings_row_minus_" .. opt.key,
        parent = control,
        themeComponent = "buttonv2",
        text = "-",
        textSize = tostring(math.floor(24 * scale)) .. "px",
        textAlign = "center",
        width = 50 * scale,
        height = 50 * scale,
        positioning = "flex",
        z = 21,
        onEvent = function(_, event)
          if event.type == "press" then
            return true
          elseif event.type == "release" then
            self:changeValue(i, -5)
            return true
          end
        end
      })

      local sliderBg = FlexLove.new({
        id = "settings_row_slider_bg_" .. opt.key,
        parent = control,
        width = "50%",
        height = 12 * scale,
        backgroundColor = Color.new(0.2, 0.2, 0.2, 1),
        borderRadius = 6,
        positioning = "flex",
        justifyContent = "flex-start",
        alignItems = "center",
        z = 21
      })

      local fillWidth = (opt.value - opt.min) / (opt.max - opt.min) * 100
      self.elements["settings_row_slider_fill_" .. opt.key] = FlexLove.new({
        id = "settings_row_slider_fill_" .. opt.key,
        parent = sliderBg,
        width = fillWidth .. "%",
        height = "100%",
        backgroundColor = COLORS.ACCENT,
        borderRadius = 6,
        positioning = "absolute",
        left = 0,
        top = 0,
        z = 22
      })

      FlexLove.new({
        id = "settings_row_plus_" .. opt.key,
        parent = control,
        themeComponent = "buttonv2",
        text = "+",
        textSize = tostring(math.floor(24 * scale)) .. "px",
        textAlign = "center",
        width = 50 * scale,
        height = 50 * scale,
        positioning = "flex",
        z = 21,
        onEvent = function(_, event)
          if event.type == "press" then
            return true
          elseif event.type == "release" then
            self:changeValue(i, 5)
            return true
          end
        end
      })
    elseif opt.type == "language_selector" then
      FlexLove.new({
        id = "settings_row_manage_" .. opt.key,
        parent = control,
        themeComponent = "buttonv2",
        text = modSystem.i18n.t("settings/language/manage", nil, nil, "MANAGE"),
        textSize = tostring(math.floor(20 * scale)) .. "px",
        textAlign = "center",
        width = 180 * scale,
        height = 50 * scale,
        positioning = "flex",
        z = 21,
        onEvent = function(_, event)
          if event.type == "press" then
            return true
          elseif event.type == "release" then
            self.isEditingLanguage = true
            self:rebuildUI()
            return true
          end
        end
      })
    end
  end

  -- Description Area
  self.elements.descriptionArea = FlexLove.new({
    id = "settings_description_area",
    parent = mainContent,
    width = isNarrow and "100%" or "30%",
    flex = 1, -- Fill remaining space (height in column, width in row)
    backgroundColor = Color.new(0, 0, 0, 0.4),
    borderRadius = 12,
    border = { left = true },
    borderWidth = 4,
    borderColor = Color.new(1, 1, 1, 0.05),
    padding = 40 * scale,
    positioning = "flex",
    flexDirection = "column",
    gap = 30 * scale
  })

  self.elements.descTitle = FlexLove.new({
    id = "settings_desc_title",
    parent = self.elements.descriptionArea,
    text = modSystem.i18n.t("settings/option/" .. (self.options[self.selectedIndex] and self.options[self.selectedIndex].key or "default"), nil, nil, self.options[self.selectedIndex] and self.options[self.selectedIndex].label or ""),
    textSize = tostring(math.floor(28 * scale)) .. "px",
    textColor = COLORS.ACCENT,
    margin = { bottom = 10 * scale }
  })

  self.elements.descText = FlexLove.new({
    id = "settings_desc_text",
    parent = self.elements.descriptionArea,
    text = modSystem.i18n.t("settings/description/" .. (self.options[self.selectedIndex] and self.options[self.selectedIndex].key or "default"), nil, nil, "Select an option to see details."),
    textSize = tostring(math.floor(18 * scale)) .. "px",
    textColor = COLORS.NORMAL,
    textWrap = true,
    width = "100%",
    lineHeight = 1.4
  })

  -- Footer
  local footerHeight = 120 * scale
  local footer = FlexLove.new({
    id = "settings_footer",
    parent = self.elements.root,
    width = "100%",
    height = footerHeight,
    backgroundColor = Color.new(0, 0, 0, 0.6),
    positioning = "flex",
    flexDirection = "row",
    justifyContent = "space-between",
    alignItems = "center",
    padding = { horizontal = 80 * scale },
    border = { top = true },
    borderWidth = 1,
    borderColor = Color.new(1, 1, 1, 0.1)
  })

  local navHelp = FlexLove.new({
    id = "settings_nav_help",
    parent = footer,
    positioning = "flex",
    flexDirection = "row",
    gap = 40 * scale
  })

  local function addHelp(icon, text, callback)
    local box = FlexLove.new({
      parent = navHelp,
      positioning = "flex",
      flexDirection = "row",
      alignItems = "center",
      gap = 15 * scale,
      interactive = callback ~= nil,
      onEvent = function(_, event)
        if callback and event.type == "release" then
          callback()
          return true
        end
      end
    })
    local iconNode = FlexLove.new({ parent = box, text = icon, textSize = "24px", textColor = COLORS.ACCENT, backgroundColor = Color.new(1,1,1,0.05), padding = 10 * scale, borderRadius = 8, interactive = false })
    local textNode = FlexLove.new({ parent = box, text = text, textSize = "18px", textColor = COLORS.NORMAL, interactive = false })

    if callback then
      local originalOnEvent = box.onEvent
      box.onEvent = function(s, event)
        if event.type == "hover" then
          iconNode.textColor = COLORS.HOVER
          textNode.textColor = COLORS.HOVER
        elseif event.type == "blur" then
          iconNode.textColor = COLORS.ACCENT
          textNode.textColor = COLORS.NORMAL
        end
        return originalOnEvent(s, event)
      end
    end
  end

  addHelp("UD", modSystem.i18n.t("settings/help/navigate", nil, nil, "NAVIGATE"))
  addHelp("LR", modSystem.i18n.t("settings/help/change", nil, nil, "CHANGE"))
  addHelp("Y", modSystem.i18n.t("settings/help/apply", nil, nil, "APPLY CHANGES"), function() self:applySettings() end)
  addHelp("ESC", modSystem.i18n.t("settings/help/back", nil, nil, "BACK"), function()
    local menu = modSystem.getScene("main_menu")
    if menu then manager:enter(menu) end
  end)
end

function settingsScene:createConfirmationOverlay()
  local scale = getResponsiveScale()
  self.elements.confirmationOverlay = FlexLove.new({
    id = "confirmation_overlay",
    width = "100%",
    height = "100%",
    z = 1000,
    positioning = "flex",
    justifyContent = "center",
    alignItems = "center"
  })

  FlexLove.new({
    id = "confirmation_bg",
    parent = self.elements.confirmationOverlay,
    width = "100%",
    height = "100%",
    backgroundColor = Color.new(0, 0, 0, 0.9),
    interactive = true,
    onEvent = function() return true end,
    z = 1001,
    positioning = "absolute",
    left = 0,
    top = 0
  })

  local dialog = FlexLove.new({
    id = "confirmation_dialog",
    parent = self.elements.confirmationOverlay,
    width = 600 * scale,
    height = 350 * scale,
    backgroundColor = COLORS.PANEL,
    borderRadius = 8,
    border = { top = true },
    borderWidth = 4,
    borderColor = COLORS.ACCENT,
    positioning = "flex",
    flexDirection = "column",
    justifyContent = "center",
    alignItems = "center",
    padding = 40 * scale,
    gap = 30 * scale,
    z = 1010,
    interactive = true,
    onEvent = function() return true end
  })

  FlexLove.new({
    id = "confirmation_title",
    parent = dialog,
    text = "KEEP THESE DISPLAY SETTINGS?",
    textSize = tostring(math.floor(32 * scale)) .. "px",
    textColor = COLORS.HOVER,
    z = 1011
  })

  self.elements.timerText = FlexLove.new({
    id = "confirmation_timer",
    parent = dialog,
    text = string.format("Reverting in %d seconds...", math.max(0, math.ceil(self.confirmationTimer))),
    textSize = tostring(math.floor(20 * scale)) .. "px",
    textColor = COLORS.NORMAL,
    z = 1011
  })

  local btnRow = FlexLove.new({
    id = "confirmation_btn_row",
    parent = dialog,
    width = "100%",
    height = 60 * scale,
    positioning = "flex",
    flexDirection = "row",
    justifyContent = "center",
    gap = 40 * scale,
    z = 1011
  })

  local function addModalBtn(icon, text, callback)
    local box = FlexLove.new({
      parent = btnRow,
      positioning = "flex",
      flexDirection = "row",
      alignItems = "center",
      gap = 15 * scale,
      interactive = true,
      z = 1020,
      onEvent = function(_, event)
        if event.type == "release" then
          callback()
          return true
        end
      end
    })
    local iconNode = FlexLove.new({ parent = box, text = icon, textSize = "24px", textColor = COLORS.ACCENT, backgroundColor = Color.new(1,1,1,0.05), padding = 10 * scale, borderRadius = 8, interactive = false, z = 1021 })
    local textNode = FlexLove.new({ parent = box, text = text, textSize = "18px", textColor = COLORS.NORMAL, interactive = false, z = 1021 })

    local originalOnEvent = box.onEvent
    box.onEvent = function(s, event)
      if event.type == "hover" then
        iconNode.textColor = COLORS.HOVER
        textNode.textColor = COLORS.HOVER
      elseif event.type == "blur" then
        iconNode.textColor = COLORS.ACCENT
        textNode.textColor = COLORS.NORMAL
      end
      return originalOnEvent(s, event)
    end
  end

  addModalBtn("ENTER", "KEEP CHANGES", function() self:confirmSettings() end)
  addModalBtn("ESC", "REVERT", function() self:revertSettings() end)
end

function settingsScene:createLanguageModal()
  local scale = getResponsiveScale()
  self.elements.languageModal = FlexLove.new({
    id = "language_modal",
    width = "100%",
    height = "100%",
    z = 1000,
    positioning = "flex",
    justifyContent = "center",
    alignItems = "center"
  })

  FlexLove.new({
    id = "language_modal_bg",
    parent = self.elements.languageModal,
    width = "100%",
    height = "100%",
    backgroundColor = Color.new(0, 0, 0, 0.8),
    interactive = true,
    onEvent = function() return true end,
    z = 1001,
    positioning = "absolute",
    left = 0,
    top = 0
  })

  local dialog = FlexLove.new({
    id = "language_dialog",
    parent = self.elements.languageModal,
    width = 900 * scale,
    height = 650 * scale,
    backgroundColor = COLORS.PANEL,
    borderRadius = 8,
    border = { top = true },
    borderWidth = 4,
    borderColor = COLORS.ACCENT,
    positioning = "flex",
    flexDirection = "column",
    padding = 40 * scale,
    gap = 20 * scale,
    z = 1010,
    interactive = true,
    onEvent = function() return true end
  })

  FlexLove.new({
    id = "language_title",
    parent = dialog,
    text = modSystem.i18n.t("settings/language/title", nil, nil, "LANGUAGE SETTINGS"),
    textSize = tostring(math.floor(28 * scale)) .. "px",
    textColor = COLORS.HOVER,
    textAlign = "center",
    width = "100%",
    z = 1011
  })

  local content = FlexLove.new({
    id = "language_content",
    parent = dialog,
    width = "100%",
    height = "75%",
    positioning = "flex",
    flexDirection = "row",
    justifyContent = "space-between",
    gap = 20 * scale,
    z = 1011
  })

  local availablePane = FlexLove.new({
    id = "lang_available_pane",
    parent = content,
    width = "45%",
    height = "100%",
    backgroundColor = Color.new(0, 0, 0, 0.3),
    borderRadius = 4,
    padding = 20 * scale,
    positioning = "flex",
    flexDirection = "column",
    gap = 10 * scale,
    z = 1012
  })

  FlexLove.new({ parent = availablePane, text = modSystem.i18n.t("settings/language/available", nil, nil, "AVAILABLE"), textSize = "18px", textColor = COLORS.ACCENT, z = 1013 })

  local availableList = FlexLove.new({
    id = "lang_available_list",
    parent = availablePane,
    width = "100%",
    flex = 1,
    positioning = "flex",
    flexDirection = "column",
    gap = 5 * scale,
    overflow = "auto",
    z = 1013
  })

  for idx, lang in ipairs(self.pendingSettings.availableLocales) do
    local isSelected = (self.langSelectionPane == "available" and self.langSelectedIndex == idx)
    local item = FlexLove.new({
      id = "lang_avail_item_" .. lang,
      parent = availableList,
      width = "100%",
      height = 40 * scale,
      backgroundColor = isSelected and COLORS.SELECTED or Color.new(0, 0, 0, 0),
      borderRadius = 2,
      positioning = "flex",
      flexDirection = "row",
      alignItems = "center",
      padding = { horizontal = 15 * scale },
      interactive = true,
      z = 1015,
      onEvent = function(_, event)
        if event.type == "hover" then
          if self.langSelectionPane ~= "available" or self.langSelectedIndex ~= idx then
            self.langSelectionPane = "available"
            self.langSelectedIndex = idx
            self:rebuildUI()
          end
        elseif event.type == "release" then
          self:moveLanguage("available", idx)
          self:rebuildUI()
        end
      end
    })
    FlexLove.new({ id = "lang_avail_text_" .. lang, parent = item, text = lang, textSize = "18px", textColor = isSelected and COLORS.HOVER or COLORS.NORMAL, interactive = false, z = 1016 })
  end

  local chosenPane = FlexLove.new({
    id = "lang_chosen_pane",
    parent = content,
    width = "45%",
    height = "100%",
    backgroundColor = Color.new(0, 0, 0, 0.3),
    borderRadius = 4,
    padding = 20 * scale,
    positioning = "flex",
    flexDirection = "column",
    gap = 10 * scale,
    z = 1012
  })

  FlexLove.new({ parent = chosenPane, text = modSystem.i18n.t("settings/language/chosen", nil, nil, "CHOSEN (ORDER)"), textSize = "18px", textColor = COLORS.ACCENT, z = 1013 })

  local chosenList = FlexLove.new({
    id = "lang_chosen_list",
    parent = chosenPane,
    width = "100%",
    flex = 1,
    positioning = "flex",
    flexDirection = "column",
    gap = 5 * scale,
    overflow = "auto",
    z = 1013
  })

  for idx, lang in ipairs(self.pendingSettings.chosenLocales) do
    local isSelected = (self.langSelectionPane == "chosen" and self.langSelectedIndex == idx)
    local item = FlexLove.new({
      id = "lang_chosen_item_" .. lang,
      parent = chosenList,
      width = "100%",
      height = 40 * scale,
      backgroundColor = isSelected and COLORS.SELECTED or Color.new(0, 0, 0, 0),
      borderRadius = 2,
      positioning = "flex",
      flexDirection = "row",
      justifyContent = "space-between",
      alignItems = "center",
      padding = { horizontal = 15 * scale },
      interactive = true,
      z = 1015,
      onEvent = function(_, event)
        if event.type == "hover" then
          if self.langSelectionPane ~= "chosen" or self.langSelectedIndex ~= idx then
            self.langSelectionPane = "chosen"
            self.langSelectedIndex = idx
            self:rebuildUI()
          end
        elseif event.type == "release" then
          -- On click, if it's already selected, move it back to available
          if isSelected then
            self:moveLanguage("chosen", idx)
            self:rebuildUI()
          end
        end
      end
    })
    FlexLove.new({ id = "lang_chosen_text_" .. lang, parent = item, text = (idx == 1 and "* " or idx .. ". ") .. lang, textSize = "18px", textColor = isSelected and COLORS.HOVER or COLORS.NORMAL, interactive = false, z = 1016 })

    if isSelected then
      local btnBox = FlexLove.new({ id = "lang_chosen_btns_" .. lang, parent = item, height = "100%", positioning = "flex", flexDirection = "row", gap = 10 * scale, z = 1017 })
      if idx > 1 then
        FlexLove.new({
          id = "lang_up_" .. lang, parent = btnBox, text = "^", themeComponent = "buttonv2", width = 30 * scale, height = 30 * scale, z = 1018,
          positioning = "flex", justifyContent = "center", alignItems = "center",
          textAlign = "center",
          textSize = tostring(math.floor(20 * scale)) .. "px",
          onEvent = function(_, e)
            if e.type == "press" then return true
            elseif e.type == "release" then self:reorderLanguage(idx, -1) self:rebuildUI() return true end
          end
        })
      end
      if idx < #self.pendingSettings.chosenLocales then
        FlexLove.new({
          id = "lang_down_" .. lang, parent = btnBox, text = "v", themeComponent = "buttonv2", width = 30 * scale, height = 30 * scale, z = 1018,
          positioning = "flex", justifyContent = "center", alignItems = "center",
          textAlign = "center",
          textSize = tostring(math.floor(20 * scale)) .. "px",
          onEvent = function(_, e)
            if e.type == "press" then return true
            elseif e.type == "release" then self:reorderLanguage(idx, 1) self:rebuildUI() return true end
          end
        })
      end
      FlexLove.new({
        id = "lang_rem_" .. lang, parent = btnBox, text = "X", themeComponent = "buttonv2", width = 30 * scale, height = 30 * scale, z = 1018,
        positioning = "flex", justifyContent = "center", alignItems = "center",
        textAlign = "center",
        textSize = tostring(math.floor(18 * scale)) .. "px",
        onEvent = function(_, e)
          if e.type == "press" then return true
          elseif e.type == "release" then self:moveLanguage("chosen", idx) self:rebuildUI() return true end
        end
      })
    end
  end

  local btnRow = FlexLove.new({
    id = "lang_btn_row",
    parent = dialog,
    width = "100%",
    height = 80 * scale,
    positioning = "flex",
    flexDirection = "row",
    justifyContent = "space-between",
    alignItems = "center",
    z = 1011,
    padding = { horizontal = 20 * scale },
    border = { top = true },
    borderColor = Color.new(1, 1, 1, 0.1),
    borderWidth = 1
  })

  local navHelp = FlexLove.new({
    id = "lang_nav_help",
    parent = btnRow,
    positioning = "flex",
    flexDirection = "row",
    gap = 30 * scale
  })

  local function addHelp(icon, text, callback)
    local box = FlexLove.new({
      parent = navHelp,
      positioning = "flex",
      flexDirection = "row",
      alignItems = "center",
      gap = 10 * scale,
      interactive = callback ~= nil,
      onEvent = function(_, event)
        if callback and event.type == "release" then
          callback()
          return true
        end
      end
    })
    local iconNode = FlexLove.new({ parent = box, text = icon, textSize = "20px", textColor = COLORS.ACCENT, backgroundColor = Color.new(1,1,1,0.05), padding = 8 * scale, borderRadius = 6, interactive = false })
    local textNode = FlexLove.new({ parent = box, text = text, textSize = "16px", textColor = COLORS.NORMAL, interactive = false })

    if callback then
      local originalOnEvent = box.onEvent
      box.onEvent = function(s, event)
        if event.type == "hover" then
          iconNode.textColor = COLORS.HOVER
          textNode.textColor = COLORS.HOVER
        elseif event.type == "blur" then
          iconNode.textColor = COLORS.ACCENT
          textNode.textColor = COLORS.NORMAL
        end
        return originalOnEvent(s, event)
      end
    end
  end

  addHelp("UDLR", modSystem.i18n.t("settings/help/navigate", nil, nil, "NAVIGATE"))
  addHelp("ENTER", modSystem.i18n.t("settings/help/move", nil, nil, "MOVE"))
  addHelp("WS", modSystem.i18n.t("settings/help/reorder", nil, nil, "REORDER"))
  addHelp("ESC", modSystem.i18n.t("settings/language/close", nil, nil, "CLOSE"), function() self.isEditingLanguage = false self:rebuildUI() end)
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
  self.categoryOpacity = 0
  self.selectedIndex = 1
  self.selectionHeight = 70 * (getResponsiveScale() or 1)
  self.isConfirming = false
  self.isEditingLanguage = false
  self.elements = {}
  self.lastMouseX = -1
  self.lastMouseY = -1

  self:createUI()
  self:rebuildUI()
end

function settingsScene:leave(next, ...)
  FlexLove.destroy()
  self.elements = {}
end

function settingsScene:rebuildUI()
  self.needsRebuild = true
end

function settingsScene:performRebuildUI()
  if self.elements.root then self.elements.root:destroy() end
  if self.elements.confirmationOverlay then self.elements.confirmationOverlay:destroy() end
  if self.elements.languageModal then self.elements.languageModal:destroy() end
  self.elements = {}

  self:createUI()

  if self.isConfirming then
    self:createConfirmationOverlay()
  end
  if self.isEditingLanguage then
    self:createLanguageModal()
  end
end

function settingsScene:resize(w, h)
  FlexLove.resize()
  self:rebuildUI()
end

function settingsScene:update(dt)
  if self.needsRebuild then
    self.needsRebuild = false
    self:performRebuildUI()
  end

  FlexLove.update(dt)

  local scale = getResponsiveScale()
  local rowHeight = 70 * scale
  local rowGap = 12 * scale

  -- Update target values for animation based on current selectedIndex
  local totalRows = #self.options
  if self.selectedIndex <= totalRows and not self.isConfirming and not self.isEditingLanguage then
    self.targetSelectionY = (self.selectedIndex - 1) * (rowHeight + rowGap)
    self.targetSelectionHeight = rowHeight
    self.selectionOpacity = math.min(1, self.selectionOpacity + dt * 10)
  else
    self.selectionOpacity = math.max(0, self.selectionOpacity - dt * 10)
  end

  -- Smoothly animate selection highlight properties
  local listY = self.elements.settings_list and self.elements.settings_list.y or 0
  if self.selectionY == 0 and listY > 0 then
    self.selectionY = self.targetSelectionY + listY
  end
  local newSelectionY = self.selectionY + (self.targetSelectionY + listY - self.selectionY) * dt * 15
  local newSelectionHeight = (self.selectionHeight or rowHeight) + (self.targetSelectionHeight - (self.selectionHeight or rowHeight)) * dt * 15

  if self.elements.selectionHighlight then
    if math.abs(newSelectionY - self.selectionY) > 0.01 or math.abs(newSelectionHeight - (self.selectionHeight or rowHeight)) > 0.01 then
      self.selectionY = newSelectionY
      self.selectionHeight = newSelectionHeight
      if self.elements.selectionHighlight.y ~= self.selectionY then
        self.elements.selectionHighlight.y = self.selectionY
      end
      if self.elements.selectionHighlight.height ~= self.selectionHeight then
        self.elements.selectionHighlight.height = self.selectionHeight
      end
    end

    if self.elements.selectionHighlight.opacity ~= self.selectionOpacity then
      self.elements.selectionHighlight.opacity = self.selectionOpacity
    end
  end

  -- Update row text colors based on selectedIndex without full rebuild
  if self.elements.rows then
    local mouseX, mouseY = love.mouse.getPosition()
    local mouseMoved = (mouseX ~= self.lastMouseX or mouseY ~= self.lastMouseY)
    if mouseMoved then
      self.lastMouseX, self.lastMouseY = mouseX, mouseY
    end

    for i, opt in ipairs(self.options) do
      local row = self.elements.rows[i]
      if row and not self.isConfirming and not self.isEditingLanguage and mouseMoved then
        -- Check if mouse is over this row to update selection only if mouse moved
        if row:contains(mouseX, mouseY) then
          if self.selectedIndex ~= i then
            self.selectedIndex = i
          end
        end
      end

      local label = self.elements["settings_row_label_" .. opt.key]
      if label then
        local targetColor = (self.selectedIndex == i) and COLORS.HOVER or COLORS.NORMAL
        if label.textColor ~= targetColor then
          label.textColor = targetColor
        end
      end

      -- Update selector values and slider fills only if they changed
      if opt.type == "selector" then
        local valueLabel = self.elements["settings_row_value_" .. opt.key]
        if valueLabel then
          local val = opt.values[opt.currentIndex]
          local translated = (opt.key == "language" or opt.key == "resolution" or tonumber(val)) and val or modSystem.i18n.t("settings/value/" .. val:lower(), nil, nil, val)
          if valueLabel.text ~= translated then
            valueLabel.text = translated
          end
        end
      elseif opt.type == "slider" then
        local fill = self.elements["settings_row_slider_fill_" .. opt.key]
        if fill then
          local fillWidthPercent = (opt.value - opt.min) / (opt.max - opt.min) * 100
          local fillWidthStr = fillWidthPercent .. "%"
          if fill.width ~= fillWidthStr then
            fill.width = fillWidthStr
          end
        end
      end
    end
  end

  -- Update description area content dynamically only if selectedIndex changed
  if self.lastSelectedIndex ~= self.selectedIndex then
    self.lastSelectedIndex = self.selectedIndex
    if self.elements.descTitle and self.options[self.selectedIndex] then
      local opt = self.options[self.selectedIndex]
      local titleText = modSystem.i18n.t("settings/option/" .. opt.key, nil, nil, opt.label)
      local descText = modSystem.i18n.t("settings/description/" .. opt.key, nil, nil, "Select an option to see details.")

      if self.elements.descTitle.text ~= titleText then
        self.elements.descTitle.text = titleText
      end
      if self.elements.descText.text ~= descText then
        self.elements.descText.text = descText
      end
    end
  end

  -- Animate category transitions with dirty checks
  if self.categoryOpacity < 1 then
    self.categoryOpacity = math.min(1, self.categoryOpacity + dt * 3)
    if self.elements.settings_list and self.elements.settings_list.opacity ~= self.categoryOpacity then
      self.elements.settings_list.opacity = self.categoryOpacity
    end
  end

  -- Update modal timer if visible with dirty checks
  if self.isConfirming then
    self.confirmationTimer = self.confirmationTimer - dt
    if self.elements.timerText then
      local newText = string.format("Reverting in %d seconds...", math.max(0, math.ceil(self.confirmationTimer)))
      if self.elements.timerText.text ~= newText then
        self.elements.timerText.text = newText
      end
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
      elseif key == "return" or key == "space" or key == "y" then
        if self.modalIndex == 1 or key == "y" then self:confirmSettings() else self:revertSettings() end
      elseif key == "escape" then self:revertSettings() end
      return
    end

    if key == "l1" or key == "q" then
       local idx = 1
       for i, c in ipairs(CATEGORIES) do if c.id == self.currentCategory then idx = i; break end end
       idx = idx - 1; if idx < 1 then idx = #CATEGORIES end
       self:switchCategory(CATEGORIES[idx].id)
       self:rebuildUI()
       return
    elseif key == "r1" or key == "e" then
       local idx = 1
       for i, c in ipairs(CATEGORIES) do if c.id == self.currentCategory then idx = i; break end end
       idx = idx + 1; if idx > #CATEGORIES then idx = 1 end
       self:switchCategory(CATEGORIES[idx].id)
       self:rebuildUI()
       return
    end

    local totalItems = #self.options + 2

    if self.isEditingLanguage then
      if key == "escape" or key == "backspace" then
        self.isEditingLanguage = false
        self:rebuildUI()
      elseif key == "up" then
        self.langSelectedIndex = self.langSelectedIndex - 1
        local list = (self.langSelectionPane == "available") and self.pendingSettings.availableLocales or self.pendingSettings.chosenLocales
        if self.langSelectedIndex < 1 then self.langSelectedIndex = #list end
        self:rebuildUI()
      elseif key == "down" then
        self.langSelectedIndex = self.langSelectedIndex + 1
        local list = (self.langSelectionPane == "available") and self.pendingSettings.availableLocales or self.pendingSettings.chosenLocales
        if self.langSelectedIndex > #list then self.langSelectedIndex = 1 end
        self:rebuildUI()
      elseif key == "left" or key == "right" then
        self.langSelectionPane = (self.langSelectionPane == "available") and "chosen" or "available"
        local list = (self.langSelectionPane == "available") and self.pendingSettings.availableLocales or self.pendingSettings.chosenLocales
        self.langSelectedIndex = math.min(self.langSelectedIndex, #list)
        if self.langSelectedIndex < 1 then self.langSelectedIndex = 1 end
        self:rebuildUI()
      elseif key == "return" or key == "space" then
        self:moveLanguage(self.langSelectionPane, self.langSelectedIndex)
        self:rebuildUI()
      elseif key == "w" then
        if self.langSelectionPane == "chosen" then self:reorderLanguage(self.langSelectedIndex, -1) self:rebuildUI() end
      elseif key == "s" then
        if self.langSelectionPane == "chosen" then self:reorderLanguage(self.langSelectedIndex, 1) self:rebuildUI() end
      end
      return
    end

    if key == "up" then
      self.selectedIndex = self.selectedIndex - 1
      if self.selectedIndex < 1 then self.selectedIndex = totalItems end
    elseif key == "down" then
      self.selectedIndex = self.selectedIndex + 1
      if self.selectedIndex > totalItems then self.selectedIndex = 1 end
    elseif key == "left" then
      if self.selectedIndex <= #self.options then
        local opt = self.options[self.selectedIndex]
        local delta = (opt.type == "slider") and -5 or -1
        self:changeValue(self.selectedIndex, delta)
      end
    elseif key == "right" then
       if self.selectedIndex <= #self.options then
         local opt = self.options[self.selectedIndex]
         local delta = (opt.type == "slider") and 5 or 1
         self:changeValue(self.selectedIndex, delta)
       end
    elseif key == "return" or key == "space" then
      if self.selectedIndex <= #self.options then
        local opt = self.options[self.selectedIndex]
        if opt.type == "language_selector" then
          self.isEditingLanguage = true
          self:rebuildUI()
        end
      elseif self.selectedIndex == #self.options + 2 then
        local menu = modSystem.getScene("main_menu")
        if menu then manager:enter(menu) end
      end
    elseif key == "y" then
      self:applySettings()
    elseif key == "escape" then
      local menu = modSystem.getScene("main_menu")
      if menu then manager:enter(menu) end
    end
  end
end

function settingsScene:keyreleased(key)
  if self.pressedKeys[key] then
    self.pressedKeys[key] = nil
  end
end

return settingsScene
