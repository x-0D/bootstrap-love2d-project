local modSystem = {}

modSystem.modLoader = require("mods.mod_loader")
modSystem.modAPI = require("mods.mod_api")

function modSystem.initialize(world, gameState, scenes, concord)
  modSystem.modAPI.initialize(world, gameState, scenes, concord)
  modSystem.modLoader.initialize(modSystem.modAPI)
  modSystem.modLoader.scanMods()
end

function modSystem.scan()
  modSystem.modLoader.scanMods()
end

function modSystem.loadAllMods()
  print("[Mods] Loading enabled mods...")
  for modName, modInfo in pairs(modSystem.modLoader.getMods()) do
    if modInfo.enabled then
      local success, message = modSystem.modLoader.loadMod(modName)
      if success then
        print("[Mods] Loaded mod: " .. modName)
      else
        print("[Mods] Failed to load mod " .. modName .. ": " .. message)
      end
    else
      print(string.format("[Mods] Skipping mod '%s' (enabled=false)", modName))
    end
  end
end

function modSystem.unloadAllMods()
  for modName, modInfo in pairs(modSystem.modLoader.getMods()) do
    if modInfo.loaded then
      local success, message = modSystem.modLoader.unloadMod(modName)
      if success then
        print("Unloaded mod: " .. modName)
      else
        print("Failed to unload mod " .. modName .. ": " .. message)
      end
    end
  end
end

function modSystem.update(dt)
  modSystem.modLoader.update(dt)
end

function modSystem.draw()
  modSystem.modLoader.draw()
end

function modSystem.getMods()
  return modSystem.modLoader.getMods()
end

function modSystem.getMod(modName)
  return modSystem.modLoader.getMod(modName)
end

function modSystem.loadMod(modName)
  return modSystem.modLoader.loadMod(modName)
end

function modSystem.unloadMod(modName)
  return modSystem.modLoader.unloadMod(modName)
end

function modSystem.enableMod(modName)
  return modSystem.modLoader.enableMod(modName)
end

function modSystem.disableMod(modName)
  return modSystem.modLoader.disableMod(modName)
end

function modSystem.isModLoaded(modName)
  return modSystem.modLoader.isModLoaded(modName)
end

function modSystem.isModEnabled(modName)
  return modSystem.modLoader.isModEnabled(modName)
end

return modSystem
