local concord = require("libs.concord")
local FlexLove = require("libs.FlexLove")

local M = {}

-- Expose components/systems for other mods
M.component = {}
M.system = {
  BeeCarbonizeSystem = require("mods.beecarbonize.system.BeeCarbonizeSystem")
}
M.entity = {}

local TILT_FACTOR = 0.2
local function screenToTable(x, y, cam)
  local w, h = love.graphics.getDimensions()
  local tx = x / w
  local ty = y / h
  local scale = 1.0 - TILT_FACTOR * ty
  local px_norm = (tx - 0.5) / scale + 0.5
  local py_norm = ty
  local px = px_norm * w
  local py = py_norm * h
  local cx, cy = w / 2, h / 2
  local z_cam = cam.zoom
  local depth_x, depth_y = 12, 6
  return cx + (px - cx - cam.x - depth_x) / z_cam, cy + (py - cy - cam.y - depth_y) / z_cam
end

function M.main(world)
  print("[BeeCarbonize] Initializing ECS...")

  -- Ensure components are loaded
  require("mods.beecarbonize.component.Camera")
  require("mods.beecarbonize.component.CanvasLayer")

  -- Register systems
  world:addSystem(M.system.BeeCarbonizeSystem)

  -- Create Camera Entity
  local cameraEntity = concord.entity(world)
  cameraEntity:give("beecarbonize.camera", {
    x = 0, y = 0,
    target_x = 0, target_y = 0,
    zoom = 1.0, target_zoom = 1.0,
    smoothing = 0.2,
    zoom_smoothing = 0.2,
    bounds = { min_x = -math.huge, max_x = math.huge, min_y = -math.huge, max_y = math.huge, min_zoom = 0.5, max_zoom = 2.0 }
  })
  M.entity.camera = cameraEntity

  -- Create Background Layer Entity
  local bgLayer = concord.entity(world)
  bgLayer:give("beecarbonize.canvas_layer", {
    name = "Background",
    priority = 10,
    is_camera_applied = true,
    use_shader = true,
    draw = function(e)
      local cam = M.entity.camera["beecarbonize.camera"]
      local w, h = love.graphics.getDimensions()
      love.graphics.clear(0.5, 0.5, 0.5, 1)
      love.graphics.setColor(0.4, 0.4, 0.45, 1)
      love.graphics.rectangle("fill", 0, 0, w, h)
      FlexLove.beginFrame()
      FlexLove.new({
        text = string.format("BG canvas • cam=(%.1f,%.1f) zoom=%.2f", cam.x, cam.y, cam.zoom),
        x = 8, y = 8,
        textColor = FlexLove.Color.new(1, 1, 1, 1)
      })
      FlexLove.endFrame()
      FlexLove.draw()
    end
  })
  M.entity.bgLayer = bgLayer

  -- Create Table Layer Entity
  local tableLayer = concord.entity(world)
  tableLayer:give("beecarbonize.canvas_layer", {
    name = "Table",
    priority = 20,
    is_camera_applied = true,
    depth = { x = 12, y = 6 },
    use_shader = true,
    draw = function(e)
      local cam = M.entity.camera["beecarbonize.camera"]
      local w, h = love.graphics.getDimensions()
      local origGetPos = love.mouse.getPosition
      love.mouse.getPosition = function()
        local x, y = origGetPos()
        return screenToTable(x, y, cam)
      end
      FlexLove.beginFrame()
      local root = FlexLove.new({
        width = "100%", height = "100%", positioning = "flex",
        flexDirection = "column", justifyContent = "center", alignItems = "center"
      })
      FlexLove.new({ parent = root, text = "BeeCarbonize", textSize = "xl", themeComponent = "buttonv1" })
      FlexLove.new({ parent = root, width = 320, height = 200, themeComponent = "framev1", backgroundColor = FlexLove.Color.new(0.2, 0.2, 0.25, 0.6) })
      FlexLove.new({ text = string.format("TABLE canvas • cam=(%.1f,%.1f) depth=(12,6) zoom=%.2f", cam.x, cam.y, cam.zoom), x = 8, y = 28, textColor = FlexLove.Color.new(1, 1, 1, 1) })
      FlexLove.endFrame()
      FlexLove.draw()
      love.mouse.getPosition = origGetPos
    end
  })
  M.entity.tableLayer = tableLayer

  -- Create HUD Layer Entity
  local hudLayer = concord.entity(world)
  hudLayer:give("beecarbonize.canvas_layer", {
    name = "HUD",
    priority = 30,
    is_camera_applied = false,
    draw = function(e)
      FlexLove.beginFrame()
      local hudRoot = FlexLove.new({ padding = 10, gap = 5, themeComponent = "framev2", backgroundColor = FlexLove.Color.new(0, 0, 0, 0.5) })
      FlexLove.new({ parent = hudRoot, text = "HUD • Left-click drag or WASD/Arrows to pan • Wheel or +/- to zoom", textColor = FlexLove.Color.new(1, 1, 1, 1) })
      FlexLove.new({ parent = hudRoot, text = "Press ESC to return to main menu", textColor = FlexLove.Color.new(0.7, 0.7, 0.7, 1) })
      FlexLove.new({ parent = hudRoot, text = "HUD canvas (static)", textColor = FlexLove.Color.new(1, 1, 1, 1) })
      FlexLove.endFrame()
      FlexLove.draw()
    end
  })
  M.entity.hudLayer = hudLayer

  -- Create Composite Overlay Layer Entity
  local compositeOverlay = concord.entity(world)
  compositeOverlay:give("beecarbonize.canvas_layer", {
    name = "CompositeOverlay",
    priority = 40,
    is_camera_applied = false,
    draw = function(e)
      FlexLove.draw(function()
        FlexLove.new({ text = "FINAL composite", x = 10, y = 50, textColor = FlexLove.Color.new(1, 1, 1, 1) })
      end)
    end
  })
  M.entity.compositeOverlay = compositeOverlay
end

return M
