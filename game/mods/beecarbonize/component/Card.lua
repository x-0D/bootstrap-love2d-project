local concord = require("libs.concord")

local Card = concord.component("beecarbonize.card", function(c, options)
  c.data = options.data or {}
  c.status = options.status or "idle" -- "idle", "upgrading", "destroyed"
  c.upgrade_progress = 0
  c.upgrade_target_id = nil
  c.is_active = options.is_active ~= false
  c.is_endangered = false
  c.endangered_by = {} -- List of IDs

  -- Transform
  c.x = options.x or 0
  c.y = options.y or 0
  c.z = options.z or 0
  c.scale = options.scale or 1
  c.rotation = options.rotation or 0

  -- Animation & Juice
  c.target_scale = 1
  c.target_rotation = 0
  c.prev_x = c.x
  c.prev_y = c.y
  c.velocity_x = 0
  c.velocity_y = 0
  c.repulsion_x = 0
  c.repulsion_y = 0

  c.juice = {
    scale = 0,
    rotation = 0,
    decay_speed = 8
  }

  -- Tilt (3D effect)
  c.tilt = {
    mx = 0,
    my = 0,
    amt = 0,
    angle = 0,
    skewX = 0,
    skewY = 0
  }

  -- Drag State
  c.is_dragging = false
  c.is_placed_on_top = false
  c.is_event = options.is_event or false
end)

return Card
