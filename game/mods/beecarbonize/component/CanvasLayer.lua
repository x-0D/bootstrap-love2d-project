local concord = require("libs.concord")

local CanvasLayer = concord.component("beecarbonize.canvas_layer", function(c, options)
  c.name = options.name or "layer"
  c.priority = options.priority or 0
  c.draw = options.draw or function() end
  c.canvas = nil -- To be managed by CanvasLayerSystem
  c.is_camera_applied = options.is_camera_applied or false
  c.depth = options.depth or { x = 0, y = 0 }
  c.use_shader = options.use_shader or false
end)

return CanvasLayer
