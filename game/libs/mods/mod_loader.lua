local modLoader = {}

modLoader.mods = {}
modLoader.modPaths = {}
modLoader.api = nil

function modLoader.initialize(api)
  modLoader.api = api
  modLoader.scanMods()
end

local function isDir(path)
  local info = love.filesystem.getInfo(path)
  return info and info.type == "directory"
end

local function isFile(path)
  local info = love.filesystem.getInfo(path)
  return info and info.type == "file"
end

function modLoader.scanMods()
  modLoader.mods = {}
  modLoader.modPaths = {}

  local modsDir = "mods"
  print("[ModLoader] Scanning mods in '" .. modsDir .. "'")
  if not isDir(modsDir) then
    print("[ModLoader] Mods directory not found")
    return
  end

  local entries = love.filesystem.getDirectoryItems(modsDir)
  for _, entry in ipairs(entries) do
    local modPath = modsDir .. "/" .. entry
    if isDir(modPath) then
      local manifestPath = modPath .. "/modinfo.lua"
      if isFile(manifestPath) then
        local success, modInfo = pcall(function()
          local modInfo = dofile(manifestPath)
          return modInfo
        end)

        if success and modInfo then
          modInfo.path = modPath
          modInfo.name = entry
          modLoader.mods[entry] = modInfo
          modLoader.modPaths[entry] = modPath
          print(string.format("[ModLoader] Found mod '%s' (enabled=%s)", entry, tostring(modInfo.enabled)))
        end
      end
    end
  end
  local count = 0
  for _ in pairs(modLoader.mods) do count = count + 1 end
  print("[ModLoader] Total mods found: " .. count)
end

function modLoader.loadMod(modName)
  local modInfo = modLoader.mods[modName]
  if not modInfo then
    return false, "Mod not found"
  end

  if modInfo.loaded then
    return true, "Mod already loaded"
  end

  local initPath = modInfo.path .. "/init.lua"
  if not isFile(initPath) then
    return false, "Init file not found"
  end

  local success, modModule = pcall(function()
    return dofile(initPath)
  end)

  if not success then
    local msg = "Failed to load mod: " .. tostring(modModule)
    print("[ModLoader] " .. msg)
    return false, msg
  end

  modInfo.loaded = true
  modInfo.module = modModule
  print(string.format("[ModLoader] Loaded mod '%s'", modName))

  -- Treat the mod module as a Concord ECS layer
  local layerSuccess, layerError = pcall(function()
    modLoader.api.registerLayer(modModule)
  end)

  if not layerSuccess then
    print("Warning: Mod " .. modName .. " failed to register as layer: " .. tostring(layerError))
  end

  return true, "Mod loaded successfully"
end

function modLoader.unloadMod(modName)
  local modInfo = modLoader.mods[modName]
  if not modInfo or not modInfo.loaded then
    return false, "Mod not loaded"
  end

  local modModule = modInfo.module
  if modModule and modModule.destroy then
    local destroySuccess, destroyError = pcall(function()
      modModule.destroy(modLoader.api)
    end)

    if not destroySuccess then
      return false, "Mod destroy failed: " .. tostring(destroyError)
    end
  end

  modInfo.loaded = false
  modInfo.module = nil

  return true, "Mod unloaded successfully"
end

function modLoader.enableMod(modName)
  local modInfo = modLoader.mods[modName]
  if not modInfo or not modInfo.loaded then
    return false, "Mod not loaded"
  end

  if modInfo.enabled then
    return true, "Mod already enabled"
  end

  local modModule = modInfo.module
  if modModule and modModule.enable then
    local enableSuccess, enableError = pcall(function()
      modModule.enable(modLoader.api)
    end)

    if not enableSuccess then
      return false, "Mod enable failed: " .. tostring(enableError)
    end
  end

  modInfo.enabled = true

  return true, "Mod enabled successfully"
end

function modLoader.disableMod(modName)
  local modInfo = modLoader.mods[modName]
  if not modInfo or not modInfo.loaded then
    return false, "Mod not loaded"
  end

  if not modInfo.enabled then
    return true, "Mod already disabled"
  end

  local modModule = modInfo.module
  if modModule and modModule.disable then
    local disableSuccess, disableError = pcall(function()
      modModule.disable(modLoader.api)
    end)

    if not disableSuccess then
      return false, "Mod disable failed: " .. tostring(disableError)
    end
  end

  modInfo.enabled = false

  return true, "Mod disabled successfully"
end

function modLoader.update(dt)
  for modName, modInfo in pairs(modLoader.mods) do
    if modInfo.loaded and modInfo.enabled and modInfo.module and modInfo.module.update then
      local success, error = pcall(function()
        modInfo.module.update(dt, modLoader.api)
      end)

      if not success then
        print("Mod " .. modName .. " update error: " .. tostring(error))
      else
        -- print(string.format("[ModLoader] Updated mod '%s'", modName))
      end
    end
  end
end

function modLoader.draw()
  for modName, modInfo in pairs(modLoader.mods) do
    if modInfo.loaded and modInfo.enabled and modInfo.module and modInfo.module.draw then
      local success, error = pcall(function()
        modInfo.module.draw(modLoader.api)
      end)

      if not success then
        print("Mod " .. modName .. " draw error: " .. tostring(error))
      end
    end
  end
end

function modLoader.getMods()
  return modLoader.mods
end

function modLoader.getMod(modName)
  return modLoader.mods[modName]
end

function modLoader.isModLoaded(modName)
  local modInfo = modLoader.mods[modName]
  return modInfo and modInfo.loaded
end

function modLoader.isModEnabled(modName)
  local modInfo = modLoader.mods[modName]
  return modInfo and modInfo.loaded and modInfo.enabled
end

return modLoader
