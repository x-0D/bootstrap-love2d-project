local concord = require("libs.concord")
local modSystem = {
  scenes = {},
  globalWorld = nil,
  modLoader = require("libs.mods.mod_loader"),
  i18n = require("libs.i18n")
}

function modSystem.initialize()
  -- Collect all modules to clear first to avoid issues with modifying table during iteration
  local modulesToClear = {}
  local modsDir = "mods"
  local modEntries = love.filesystem.getDirectoryItems(modsDir)
  local libsToClear = {
    "libs.concord",
    "libs.FlexLove",
    "libs.roomy",
    "libs.i18n"
  }

  for k, _ in pairs(package.loaded) do
    local shouldClear = false

    -- Check if it's a mod module (but NOT the mod system itself)
    if k:sub(1, 5) == "mods." then
      local modNamePart = k:sub(6):match("^([^%.]+)")
      if modNamePart then
        for _, entry in ipairs(modEntries) do
          if entry == modNamePart then
            shouldClear = true
            break
          end
        end
      end
    end

    -- Check if it's one of the libraries we want to reset
    if not shouldClear then
      for _, lib in ipairs(libsToClear) do
        if k == lib or k:sub(1, #lib + 1) == lib .. "." then
          shouldClear = true
          break
        end
      end
    end

    -- Special case for FlexLove sub-modules that might be required directly
    if not shouldClear and (k:sub(1, 13) == "libs.modules." or k:sub(1, 12) == "libs.themes.") then
      shouldClear = true
    end

    if shouldClear then
      table.insert(modulesToClear, k)
    end
  end

  -- Perform the actual clearing
  for _, k in ipairs(modulesToClear) do
    print(string.format("[ModSystem] Clearing package.loaded['%s']", k))
    package.loaded[k] = nil
  end

  -- Re-require core libraries to get fresh instances
  local concord = require("libs.concord")
  modSystem.i18n = require("libs.i18n")

  -- Reset mod loader state instead of clearing its code
  modSystem.modLoader.mods = {}

  -- Reset internal state
  modSystem.scenes = {}

  -- Create global ECS world
  modSystem.globalWorld = concord.world()

  -- Scan for mods
  modSystem.scan()

  -- 1. Ensure Core mod is loaded
  local core = modSystem.loadMod("core")

  if core then
    if core.init then
      core.init(modSystem)
    else
      print("[ModSystem] Warning: Core mod has no init function!")
    end
  else
    print("[ModSystem] Error: CRITICAL - Core mod not found. Game functionality may be limited.")
  end

  -- 2. Load other enabled mods
  local mods = modSystem.getMods()
  for name, info in pairs(mods) do
    if name ~= "core" and info.enabled then
      local modModule = modSystem.loadMod(name)
      if modModule and modModule.init then
        modModule.init(modSystem)
      end
    end
  end

  -- 3. Sanity check: ensure at least one scene is registered
  if next(modSystem.scenes) == nil then
    print("[ModSystem] Warning: No scenes registered! Mods might not have initialized correctly.")
  end
end

function modSystem.reload()
  print("[ModSystem] Reloading all mods...")

  -- 1. Unload all loaded mods
  local mods = modSystem.getMods()
  for name, info in pairs(mods) do
    if info.loaded then
      modSystem.modLoader.unloadMod(name)
    end
  end

  -- 2. Re-initialize the whole system
  modSystem.initialize()

  -- 3. Transition to the main menu (restarting the game state)
  local mainMenu = modSystem.getScene("main_menu")
  if mainMenu then
    manager:enter(mainMenu)
  else
    print("[ModSystem] Error: Failed to find main_menu scene after reload!")
  end
end

function modSystem.getEnabledModByType(modType)
  local mods = modSystem.getMods()
  for name, info in pairs(mods) do
    if info.enabled and info.type == modType then
      return modSystem.loadMod(name)
    end
  end
  return nil
end

function modSystem.getEnabledModInfoByType(modType)
  local mods = modSystem.getMods()
  for name, info in pairs(mods) do
    if info.enabled and info.type == modType then
      return info
    end
  end
  return nil
end

function modSystem.registerScene(name, scene)
  modSystem.scenes[name] = scene
end

function modSystem.getScene(name)
  return modSystem.scenes[name]
end

function modSystem.getMods()
  return modSystem.modLoader.getMods()
end

function modSystem.loadMod(name)
  return modSystem.modLoader.loadMod(name)
end

function modSystem.setEnabled(name, enabled)
  return modSystem.modLoader.setEnabled(name, enabled)
end

function modSystem.scan()
  modSystem.modLoader.scanMods()
end

return modSystem
