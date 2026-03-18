local mod = {}

-- Expose components for other mods
mod.component = {
  rotation = require("mods.example.component.rotation")
}

-- Expose systems
mod.system = {
  rotation_system = require("mods.example.system.rotation_system")
}

function mod.main(world)
  print("[Example Mod] Running main...")

  -- Add systems to the world
  world:addSystem(mod.system.rotation_system)

  -- Add a component to the world's test entity
  local entities = world:query({ "position" })
  local e = entities[1]
  if e then
    e:give("example.component.rotation", { angle = 0, speed = 1 })
    e:get("velocity").x = 50 -- Give it some speed
  end
end

return mod
