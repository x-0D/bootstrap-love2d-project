local concord = require("libs.concord")
local modSystem = {
  scenes = {},
  globalWorld = nil,
  modLoader = require("mods.mod_loader")
}

function modSystem.initialize()
  -- Create global ECS world
  modSystem.globalWorld = concord.world()
  
  -- Scan for mods
  modSystem.modLoader.scanMods()
  
  -- Load core mod first
  local core = modSystem.modLoader.loadMod("core")
  if core then
    if core.init then
      core.init(modSystem)
    else
      print("[ModSystem] Warning: Core mod has no init function!")
    end
  else
    print("[ModSystem] Error: Failed to load Core mod!")
  end
  
  -- Load other enabled mods
  local mods = modSystem.getMods()
  for name, info in pairs(mods) do
    if name ~= "core" and info.enabled then
      local modModule = modSystem.loadMod(name)
      if modModule and modModule.init then
        modModule.init(modSystem)
      end
    end
  end
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
