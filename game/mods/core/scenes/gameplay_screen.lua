local concord = require("libs.concord")

local gameplay = {
  pressedKeys = {},
  world = nil
}

function gameplay:enter(previous, ...)
  print("Entering gameplay scene")
  self.pressedKeys = {}

  -- Create Concord World (local world for gameplay)
  self.world = concord.world()

  -- Load and initialize enabled mods (already initialized in main.lua)
  local mods = modSystem.getMods()
  self.loadedMods = {}
  for name, info in pairs(mods) do
    if info.enabled then
      local modModule = modSystem.loadMod(name)
      if modModule then
        table.insert(self.loadedMods, name)
        if modModule.main then
          print(string.format("[Gameplay] Initializing mod '%s' for scene...", name))
          modModule.main(self.world)
        end
      end
    end
  end
end

function gameplay:leave(next, ...)
  print("Leaving gameplay scene")

  -- Properly dispose of all systems
  if self.world then
    print("[Gameplay] Emitting leave to world...")
    self.world:emit("leave")
    print("[Gameplay] Clearing world entities...")
    self.world:clear()
  end
  self.world = nil

  if self.loadedMods then
    for _, name in ipairs(self.loadedMods) do
      _G[name] = nil
    end
  end
  self.loadedMods = nil
end

function gameplay:update(dt)
  self.world:emit("update", dt)
end

function gameplay:draw()
  love.graphics.clear(0.1, 0.1, 0.1)

  -- Check for camera in world or just use defaults
  -- (Removing modAPI.getGameState for now, as it should be handled by systems)

  self.world:emit("draw")

  -- Note: Per user request, all UI should be handled via FlexLove in mods
  -- or a dedicated UI system. Removing the direct graphics call.
end

function gameplay:keypressed(key)
  if not self.pressedKeys[key] then
    self.pressedKeys[key] = true
    if key == "escape" then
      local menu = modSystem.getScene("main_menu")
      if menu then
        manager:enter(menu)
      end
    end
  end
end

function gameplay:keyreleased(key)
  if self.pressedKeys[key] then
    self.pressedKeys[key] = nil
    if key == "escape" then
      local menu = modSystem.getScene("main_menu")
      if menu then
        manager:enter(menu)
      end
    end
  end
end

function gameplay:wheelmoved(x, y)
  self.world:emit("wheelmoved", x, y)
end

return gameplay
