local concord = require("libs.concord")
local modSystem = require("libs.mods")

-- Register basic components early
concord.component("position", function(self, data)
  self.x = (data and data.x) or 0
  self.y = (data and data.y) or 0
end)
concord.component("velocity", function(self, data)
  self.x = (data and data.x) or 0
  self.y = (data and data.y) or 0
end)
concord.component("color", function(self, data)
  self.r = (data and data.r) or 1
  self.g = (data and data.g) or 1
  self.b = (data and data.b) or 1
  self.a = (data and data.a) or 1
end)

local MovementSystem = concord.system({
  pool = { "position", "velocity" }
})

function MovementSystem:update(dt)
  for _, e in ipairs(self.pool) do
    local pos = e:get("position")
    local vel = e:get("velocity")
    pos.x = pos.x + vel.x * dt
    pos.y = pos.y + vel.y * dt
  end
end

local RenderSystem = concord.system({
  pool = { "position", "color" }
})

function RenderSystem:draw()
  for _, e in ipairs(self.pool) do
    local pos = e:get("position")
    local color = e:get("color")
    love.graphics.setColor(color.r, color.g, color.b, color.a)
    love.graphics.rectangle("fill", pos.x, pos.y, 32, 32)
  end
end

local gameplay = {
  pressedKeys = {},
  world = nil
}

function gameplay:enter(previous, ...)
  print("Entering gameplay scene")
  self.pressedKeys = {}

  -- Create Concord World
  self.world = concord.world()

  -- Add systems
  self.world:addSystems(MovementSystem, RenderSystem)

  -- Initialize mod system
  modSystem.initialize()

  -- Load and initialize enabled mods
  local mods = modSystem.getMods()
  self.loadedMods = {}
  for name, info in pairs(mods) do
    if info.enabled then
      local modModule = modSystem.loadMod(name)
      if modModule then
        _G[name] = modModule
        table.insert(self.loadedMods, name)
        if modModule.main then
          print(string.format("[Gameplay] Initializing mod '%s'...", name))
          modModule.main(self.world)
        end
      end
    end
  end

  -- Create a test entity
  local e = self.world:newEntity()
  e:give("position", { x = 400, y = 300 })
  e:give("velocity", { x = 0, y = 0 })
  e:give("color", { r = 1, g = 0, b = 0, a = 1 })
end

function gameplay:leave(next, ...)
  print("Leaving gameplay scene")
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
      manager:enter(mainMenu)
    end
  end
end

function gameplay:keyreleased(key)
  if self.pressedKeys[key] then
    self.pressedKeys[key] = nil
    if key == "escape" then
      manager:enter(mainMenu)
    end
  end
end

function gameplay:wheelmoved(x, y)
  self.world:emit("wheelmoved", x, y)
end

return gameplay
