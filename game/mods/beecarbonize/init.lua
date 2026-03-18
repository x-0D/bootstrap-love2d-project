local M = {}

-- Expose components/systems for other mods
M.component = {}
M.system = {
  BeeCarbonizeSystem = require("beecarbonize.system.BeeCarbonizeSystem")
}
M.entity = {}

function M.main(world)
  print("[BeeCarbonize] Initializing ECS...")

  -- Register systems
  world:addSystem(M.system.BeeCarbonizeSystem)

  -- Logic to initialize entities if needed could go here
end

return M
