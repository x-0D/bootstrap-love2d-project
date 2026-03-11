local cute = require("cute")
local overlayStats = require("libs.overlayStats")
manager = require('roomy').new()
mainMenu = require("scenes.main_menu_screen")
gameplay = require("scenes.gameplay_screen")
credits = require("scenes.credits_screen")
settings = require("scenes.settings_screen")

function love.load(args)
  cute.go(args)
  manager:hook()
  manager:enter(mainMenu)
  overlayStats.load()
end

function love.draw(dt)
  overlayStats.draw()
end

function love.update(dt)
  overlayStats.update(dt)
end

function love.keypressed(key)
  if key == "escape" and love.system.getOS() ~= "Web" then
    love.event.quit()
  else
    overlayStats.handleKeyboard(key)
  end
end
