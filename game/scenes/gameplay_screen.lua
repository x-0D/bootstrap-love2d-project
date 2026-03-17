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

  -- Initialize mod API
  local gameState = { score = 0 }
  local scenes = { mainMenu = mainMenu, settings = settings }
  modSystem.initialize(self.world, gameState, scenes, concord)

  -- Expose systems to mod API
  modSystem.modAPI.MovementSystem = MovementSystem
  modSystem.modAPI.RenderSystem = RenderSystem

  -- Load mods
  modSystem.loadAllMods()
  local mods = modSystem.getMods()
  for name, info in pairs(mods) do
    print(string.format("[Gameplay] Mod '%s': enabled=%s loaded=%s", name, tostring(info.enabled), tostring(info.loaded)))
  end

  -- Create a test entity
  local e = self.world:newEntity()
  e:give("position", { x = 400, y = 300 })
  e:give("velocity", { x = 0, y = 0 })
  e:give("color", { r = 1, g = 0, b = 0, a = 1 })
end

function gameplay:leave(next, ...)
  print("Leaving gameplay scene")
  modSystem.unloadAllMods()
end

function gameplay:update(dt)
  self.world:emit("update", dt)
  modSystem.update(dt)
end

function gameplay:draw()
  love.graphics.clear(0.1, 0.1, 0.1)
  local cam = modSystem.modAPI.getGameState and modSystem.modAPI.getGameState("camera") or nil
  love.graphics.push()
  if cam then
    love.graphics.translate((cam.x or 0) + ((cam.depth and cam.depth.x) or 0), (cam.y or 0) + ((cam.depth and cam.depth.y) or 0))
    if cam.zoom then love.graphics.scale(cam.zoom) end
  end
  self.world:emit("draw")
  love.graphics.pop()
  modSystem.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("Gameplay Screen - Press ESC to return to menu", 10, 10)
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

return gameplay
