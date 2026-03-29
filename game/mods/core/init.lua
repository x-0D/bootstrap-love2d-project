local M = {}

function M.init(modSystem)
  print("[Core] Initializing Core Mod...")

  -- Initialize i18n
  if love.filesystem.getInfo("mods/core/i18n") then
    modSystem.i18n.load("mods/core/i18n")
  end

  -- Add global systems
  local GlobalInputSystem = require("mods.core.system.GlobalInputSystem")
  modSystem.globalWorld:addSystem(GlobalInputSystem)

  -- Register scenes
  modSystem.registerScene("main_menu", require("mods.core.scenes.main_menu_screen"))
  modSystem.registerScene("gameplay", require("mods.core.scenes.gameplay_screen"))
  modSystem.registerScene("settings", require("mods.core.scenes.settings_screen"))
  modSystem.registerScene("credits", require("mods.core.scenes.credits_screen"))
  modSystem.registerScene("mods_manager", require("mods.core.scenes.mods_manager_screen"))

  print("[Core] Registered core scenes.")
end

return M
