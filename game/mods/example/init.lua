local mod = {}
local concord = require("libs.concord")

function mod.init(api)
  api.log("Example mod initialized as layer!")

  -- Add a component to the world's test entity
  local world = api.getWorld()
  local e = world:filter({ "position" }):get(1)
  if e then
    e:give("rotation", { angle = 0, speed = 1 })
    e:get("velocity").x = 50 -- Give it some speed
  end
end

-- Define and register component early (must exist before system creation)
concord.component("rotation", function(self, data)
  self.angle = (data and data.angle) or 0
  self.speed = (data and data.speed) or 0
end)

-- Also expose component defaults for mods API bookkeeping
mod.components = {
  rotation = { angle = 0, speed = 0 }
}

local RotationSystem = concord.system({
  pool = { "rotation" }
})

function RotationSystem:update(dt)
  for _, e in ipairs(self.pool) do
    local rot = e:get("rotation")
    rot.angle = rot.angle + rot.speed * dt
  end
end

mod.systems = {
  RotationSystem
}

-- Define mixins
mod.mixins = {
  -- Modify RenderSystem to draw with rotation
  [require("mods.mod_api").RenderSystem] = {
    draw = function(original, self)
      for _, e in ipairs(self.pool) do
        local pos = e:get("position")
        local color = e:get("color")
        local rot = e:get("rotation")

        love.graphics.push()
        love.graphics.translate(pos.x + 16, pos.y + 16)
        if rot then
          love.graphics.rotate(rot.angle)
        end
        love.graphics.setColor(color.r, color.g, color.b, color.a)
        love.graphics.rectangle("fill", -16, -16, 32, 32)
        love.graphics.pop()
      end
      -- Note: we are NOT calling original() because we are replacing the drawing logic
      -- If we wanted to keep it, we would call original(self)
    end
  }
}

return mod
