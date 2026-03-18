local concord = require("libs.concord")

local Camera = concord.component("beecarbonize.camera", function(c, options)
  c.x = options.x or 0
  c.y = options.y or 0
  c.target_x = options.target_x or 0
  c.target_y = options.target_y or 0
  c.zoom = options.zoom or 1.0
  c.target_zoom = options.target_zoom or 1.0
  c.smoothing = options.smoothing or 0.2
  c.zoom_smoothing = options.zoom_smoothing or 0.2
  c.is_dragging = false
  c.drag_start_x = 0
  c.drag_start_y = 0
  c.drag_camera_start_x = 0
  c.drag_camera_start_y = 0
  c.bounds = options.bounds or {
    min_x = -math.huge, max_x = math.huge,
    min_y = -math.huge, max_y = math.huge,
    min_zoom = 0.5, max_zoom = 2.0
  }
end)

return Camera
