local cute = require("cute")
local overlayStats = require("libs.overlayStats")

-- Make systems globally accessible
modSystem = require("libs.mods")
manager = require('roomy').new()

function love.load(args)
  cute.go(args)

  -- Initialize mod system (loads core and other mods)
  modSystem.initialize()

  -- Hook roomy manager
  manager:hook()

  -- Start with the main menu from core
  local mainMenu = modSystem.getScene("main_menu")
  if mainMenu then
    manager:enter(mainMenu)
  else
    error("Core main_menu scene not found!")
  end

  overlayStats.load()
end

function love.draw()
  if modSystem.globalWorld then
    modSystem.globalWorld:emit("draw")
  end
  overlayStats.draw()
end

function love.update(dt)
  -- Update global ECS world if needed
  if modSystem.globalWorld then
    modSystem.globalWorld:emit("update", dt)
  end
  overlayStats.update(dt)
end

function love.keypressed(key)
  if modSystem.globalWorld then
    modSystem.globalWorld:emit("keypressed", key)
  end
  overlayStats.handleKeyboard(key)
end
