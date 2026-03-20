local cute = require("cute")
local overlayStats = require("libs.overlayStats")

-- Make systems globally accessible
modSystem = require("libs.mods")
manager = require('roomy').new()

local function loadAndApplySettings()
  local json = require("json")
  if love.filesystem.getInfo("settings.json") then
    local content = love.filesystem.read("settings.json")
    if content then
      local settings = json.decode(content)
      if settings and settings.master_vol then
        print("Restoring Master Volume: " .. settings.master_vol .. "%")
        if love.audio then
          love.audio.setVolume(settings.master_vol / 100)
        end
      end
    end
  end
end

function love.load(args)
  loadAndApplySettings()
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
