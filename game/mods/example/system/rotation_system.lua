local concord = require("libs.concord")

local RotationSystem = concord.system({
  pool = { "example.component.rotation" }
})

function RotationSystem:update(dt)
  for _, e in ipairs(self.pool) do
    local rot = e:get("example.component.rotation")
    rot.angle = rot.angle + rot.speed * dt
  end
end

return RotationSystem
