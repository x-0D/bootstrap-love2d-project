local concord = require("libs.concord")
local modSystem = {
  scenes = {},
  globalWorld = nil,
  modLoader = require("libs.mods.mod_loader")
}

function modSystem.initialize()
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
