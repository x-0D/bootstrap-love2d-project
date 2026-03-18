local FlexLove = require("libs.FlexLove")
local concord = require("libs.concord")

-- Load Components and Systems
local CameraComponent = require("mods.beecarbonize.component.Camera")
local CanvasLayerComponent = require("mods.beecarbonize.component.CanvasLayer")
local PanCameraSystem = require("mods.beecarbonize.system.PanCameraSystem")
local CanvasLayerSystem = require("mods.beecarbonize.system.CanvasLayerSystem")

local BeeCarbonizeSystem = concord.system({})

-- Local State (for helper functions)
local lastW, lastH
local TILT_FACTOR = 0.2

-- Helpers
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

-- System Callbacks
function BeeCarbonizeSystem:init()
  FlexLove.init({
    theme = "metal",
    immediateMode = true,
    autoFrameManagement = false
  })

  -- Initialize World
  local world = self:getWorld()
  world:addSystems(PanCameraSystem, CanvasLayerSystem)
end

function BeeCarbonizeSystem:update(dt)
  -- The world will update PanCameraSystem and CanvasLayerSystem
end

function BeeCarbonizeSystem:draw()
  -- The world will draw CanvasLayerSystem
end

function BeeCarbonizeSystem:leave()
  print("[BeeCarbonizeSystem] Leaving...")
end

return BeeCarbonizeSystem
