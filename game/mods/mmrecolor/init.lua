local FlexLove = require("libs.FlexLove")
local Color = FlexLove.Color

local M = {}

function M.init(modSystem)
  print("[MMRecolor] Hooking into main_menu...")

  -- Load i18n
  if love.filesystem.getInfo("mods/mmrecolor/i18n") then
    modSystem.i18n.load("mods/mmrecolor/i18n")
  end

  local mainMenu = modSystem.getScene("main_menu")
  if not mainMenu then
    print("[MMRecolor] Error: main_menu scene not found!")
    return
  end

  -- Modify colors
  mainMenu.COLORS.NORMAL = Color.new(0.4, 0.8, 0.4, 1)   -- Greenish
  mainMenu.COLORS.HOVER = Color.new(0.6, 1.0, 0.6, 1)    -- Bright Green
  mainMenu.COLORS.PRESSED = Color.new(0.2, 0.6, 0.2, 1)  -- Dark Green

  -- Add a custom menu option
  table.insert(mainMenu.menuOptions, 1, { key = "modded_start", label = "MODDED START", action = "modded_start" })

  -- Modify title and layout (this will be used in enter())
  local originalEnter = mainMenu.enter
  mainMenu.enter = function(self, previous, ...)
    originalEnter(self, previous, ...)
    
    -- Now modify elements after they are created
    if self.rootElement then
      self.rootElement.backgroundColor = Color.new(0.05, 0.1, 0.05, 1) -- Greenish background
      
      -- Find the title element (it's the first child of rootElement)
      if self.rootElement.children and self.rootElement.children[1] then
        local title = self.rootElement.children[1]
        title.text = "MODDED Love2D"
        title.backgroundColor = Color.new(0.15, 0.25, 0.15, 1)
      end
    end
  end

  -- Hook the handleMenuAction to handle our new action
  local originalHandleMenuAction = mainMenu.handleMenuAction
  mainMenu.handleMenuAction = function(self, action)
    if action == "modded_start" then
      print("[MMRecolor] Modded start action triggered!")
      -- For now just enter gameplay
      local gameplay = modSystem.getScene("gameplay")
      if gameplay then
        manager:enter(gameplay)
      end
    else
      originalHandleMenuAction(self, action)
    end
  end

  print("[MMRecolor] Successfully hooked main_menu.")
end

return M
