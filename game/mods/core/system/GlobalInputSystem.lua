local concord = require("libs.concord")

local GlobalInputSystem = concord.system({})

function GlobalInputSystem:init()
  print("[GlobalInputSystem] Initialized")
end

function GlobalInputSystem:update(dt)
  -- This runs every frame regardless of the current scene
end

function GlobalInputSystem:keypressed(key)
  -- Global shortcuts
  if key == "f12" then
    print("[GlobalInputSystem] F12 pressed - taking screenshot (mock)")
  end
end

return GlobalInputSystem
