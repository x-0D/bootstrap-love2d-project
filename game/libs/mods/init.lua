local modSystem = {}

modSystem.modLoader = require("mods.mod_loader")

function modSystem.initialize()
  modSystem.modLoader.scanMods()
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
