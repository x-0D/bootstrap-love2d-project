local FlexLove = require("libs.FlexLove")
local concord = require("libs.concord")

local BeeCarbonizeSystem = concord.system({})

-- Local State
local camera = {
  x = 0, y = 0,
  target_x = 0, target_y = 0,
  zoom = 1.0, target_zoom = 1.0,
  smoothing = 0.2,
  zoom_smoothing = 0.2,
  is_dragging = false,
  drag_start_x = 0, drag_start_y = 0,
  drag_camera_start_x = 0, drag_camera_start_y = 0,
  bounds = { min_x = -math.huge, max_x = math.huge, min_y = -math.huge, max_y = math.huge, min_zoom = 0.5, max_zoom = 2.0 }
}
local depth = { x = 12, y = 6 }

local bgCanvas
local tableCanvas
local hudCanvas
local finalCanvas
local perspectiveShader
local lastW, lastH
local _debugAccum = 0
local DEBUG = false
local TILT_FACTOR = 0.2

-- Perspective shader for Game Table Layer
local perspectiveCode = [[
  extern float tilt; // Amount of tilt (0 to 1)
  vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
    // We want the top (tc.y=0) to be the "original" width
    // and the bottom (tc.y=1) to be wider.
    // However, LÖVE shaders are fragment shaders: we are at screen-coordinate tc,
    // and we want to know which point in the texture maps to this screen point.

    // To make the bottom look WIDER on screen, we need to sample from a NARROWER part of the texture.
    // Scale factor: 1.0 at top, and (1.0 - tilt) at bottom.
    float scale = 1.0 - tilt * tc.y;
    float x_tex = (tc.x - 0.5) * scale + 0.5;

    if (x_tex < 0.0 || x_tex > 1.0) {
      return vec4(0.0);
    }

    return Texel(tex, vec2(x_tex, tc.y)) * color;
  }
]]

-- Helpers
local function clamp(v, minv, maxv)
  if v < minv then return minv end
  if v > maxv then return maxv end
  return v
end

local function set_target(x, y)
  local cx, cy = (lastW or 800) / 2, (lastH or 600) / 2
  local min_x = -cx * camera.target_zoom - depth.x
  local max_x = cx * camera.target_zoom - depth.x
  local min_y = -cy * camera.target_zoom - depth.y
  local max_y = cy * camera.target_zoom - depth.y

  camera.target_x = clamp(x, min_x, max_x)
  camera.target_y = clamp(y, min_y, max_y)
end

local function ensureCanvases()
  local w, h = love.graphics.getDimensions()
  if not finalCanvas or w ~= lastW or h ~= lastH then
    bgCanvas = love.graphics.newCanvas(w, h)
    tableCanvas = love.graphics.newCanvas(w, h)
    hudCanvas = love.graphics.newCanvas(w, h)
    finalCanvas = love.graphics.newCanvas(w, h)
    lastW, lastH = w, h
    -- Re-clamp camera targets to new screen dimensions
    set_target(camera.target_x, camera.target_y)
  end
end

local function pan(dx, dy)
  set_target(camera.target_x + dx, camera.target_y + dy)
end

local function set_zoom(level)
  camera.target_zoom = clamp(level, camera.bounds.min_zoom, camera.bounds.max_zoom)
  set_target(camera.target_x, camera.target_y)
end

local function adjust_zoom(delta)
  set_zoom(camera.target_zoom + delta)
end

local function start_drag(mx, my)
  camera.is_dragging = true
  camera.drag_start_x = mx
  camera.drag_start_y = my
  camera.drag_camera_start_x = camera.target_x
  camera.drag_camera_start_y = camera.target_y
end

local function update_drag(mx, my)
  if not camera.is_dragging then return end
  local dx = mx - camera.drag_start_x
  local dy = my - camera.drag_start_y
  set_target(camera.drag_camera_start_x + dx, camera.drag_camera_start_y + dy)
end

local function end_drag()
  camera.is_dragging = false
end

local function screenToTable(x, y)
  local tx = x / lastW
  local ty = y / lastH

  -- Perspective Inverse (Bottom-Expanding Trapezoid)
  -- scale = 1.0 - TILT_FACTOR * ty
  -- tx = (px_norm - 0.5) * scale + 0.5
  -- (tx - 0.5) / scale = px_norm - 0.5
  -- px_norm = (tx - 0.5) / (1.0 - TILT_FACTOR * ty) + 0.5

  local scale = 1.0 - TILT_FACTOR * ty
  local px_norm = (tx - 0.5) / scale + 0.5
  local py_norm = ty

  local px = px_norm * lastW
  local py = py_norm * lastH

  local cx, cy = lastW / 2, lastH / 2
  local z_cam = camera.zoom
  return cx + (px - cx - camera.x - depth.x) / z_cam, cy + (py - cy - camera.y - depth.y) / z_cam
end

-- System Callbacks
function BeeCarbonizeSystem:init()
  -- Use metal theme as requested
  FlexLove.init({
    theme = "metal",
    immediateMode = true,
    autoFrameManagement = false -- We will manage frames manually for multiple pipelines
  })
  perspectiveShader = love.graphics.newShader(perspectiveCode)
  perspectiveShader:send("tilt", TILT_FACTOR)
end

function BeeCarbonizeSystem:update(dt)
  ensureCanvases()
  local speed = 400 * dt
  if love.keyboard.isDown("left") or love.keyboard.isDown("a") then pan(speed, 0) end
  if love.keyboard.isDown("right") or love.keyboard.isDown("d") then pan(-speed, 0) end
  if love.keyboard.isDown("up") or love.keyboard.isDown("w") then pan(0, speed) end
  if love.keyboard.isDown("down") or love.keyboard.isDown("s") then pan(0, -speed) end
  if love.keyboard.isDown("=") or love.keyboard.isDown("+") or love.keyboard.isDown("e") then adjust_zoom(0.02) end
  if love.keyboard.isDown("-") or love.keyboard.isDown("_") or love.keyboard.isDown("q") then adjust_zoom(-0.02) end
  if love.mouse.isDown(1) then
    local mx, my = love.mouse.getPosition()
    if not camera.is_dragging then
      start_drag(mx, my)
    else
      update_drag(mx, my)
    end
  elseif camera.is_dragging then
    end_drag()
  end
  local dx = camera.target_x - camera.x
  local dy = camera.target_y - camera.y
  camera.x = camera.x + dx * camera.smoothing
  camera.y = camera.y + dy * camera.smoothing
  local dz = camera.target_zoom - camera.zoom
  camera.zoom = camera.zoom + dz * camera.zoom_smoothing

  if DEBUG then
    _debugAccum = _debugAccum + dt
    if _debugAccum >= 0.5 then
      print(string.format("[BeeCarbonize] cam=(%.1f, %.1f) tgt=(%.1f, %.1f) zoom=%.2f dragging=%s",
        camera.x, camera.y, camera.target_x, camera.target_y, camera.zoom, tostring(camera.is_dragging)))
      _debugAccum = 0
    end
  end
end

function BeeCarbonizeSystem:wheelmoved(x, y)
  -- Each wheel step is usually 1, so adjust zoom by a reasonable amount
  adjust_zoom(y * 0.1)
end

function BeeCarbonizeSystem:draw()
  ensureCanvases()

  -- 1. Background Pipeline
  love.graphics.setCanvas(bgCanvas)
  love.graphics.clear(0.5, 0.5, 0.5, 1)
  love.graphics.push()
  local cx, cy = lastW / 2, lastH / 2
  love.graphics.translate(camera.x + cx, camera.y + cy)
  love.graphics.scale(camera.zoom)
  love.graphics.translate(-cx, -cy)
  love.graphics.setColor(0.4, 0.4, 0.45, 1)
  love.graphics.rectangle("fill", 0, 0, lastW, lastH)

  -- Use FlexLove for BG UI
  FlexLove.beginFrame()
  FlexLove.new({
    text = string.format("BG canvas • cam=(%.1f,%.1f) zoom=%.2f", camera.x, camera.y, camera.zoom),
    x = 8, y = 8,
    textColor = FlexLove.Color.new(1, 1, 1, 1)
  })
  FlexLove.endFrame()
  FlexLove.draw()

  love.graphics.pop()
  love.graphics.setCanvas()

  -- 2. Table Pipeline
  love.graphics.setCanvas(tableCanvas)
  love.graphics.clear(0, 0, 0, 0)
  love.graphics.push()
  local cx, cy = lastW / 2, lastH / 2
  love.graphics.translate(camera.x + depth.x + cx, camera.y + depth.y + cy)
  love.graphics.scale(camera.zoom)
  love.graphics.translate(-cx, -cy)

  local origGetPos = love.mouse.getPosition
  love.mouse.getPosition = function()
    local x, y = origGetPos()
    return screenToTable(x, y)
  end

  -- Use FlexLove for main table UI
  FlexLove.beginFrame()
  local root = FlexLove.new({
    width = "100%",
    height = "100%",
    positioning = "flex",
    flexDirection = "column",
    justifyContent = "center",
    alignItems = "center"
  })
  FlexLove.new({
    parent = root,
    text = "BeeCarbonize",
    textSize = "xl",
    themeComponent = "buttonv1" -- Use a metal theme component
  })
  FlexLove.new({
    parent = root,
    width = 320,
    height = 200,
    themeComponent = "framev1", -- Use a metal theme component
    backgroundColor = FlexLove.Color.new(0.2, 0.2, 0.25, 0.6)
  })
  FlexLove.new({
    text = string.format("TABLE canvas • cam=(%.1f,%.1f) depth=(%.1f,%.1f) zoom=%.2f", camera.x, camera.y, depth.x, depth.y, camera.zoom),
    x = 8, y = 28,
    textColor = FlexLove.Color.new(1, 1, 1, 1)
  })
  FlexLove.endFrame()
  FlexLove.draw()

  love.mouse.getPosition = origGetPos
  love.graphics.pop()
  love.graphics.setCanvas()

  -- 3. HUD Pipeline
  love.graphics.setCanvas(hudCanvas)
  love.graphics.clear(0, 0, 0, 0)

  -- Use FlexLove for HUD UI
  FlexLove.beginFrame()
  local hudRoot = FlexLove.new({
    padding = 10,
    gap = 5,
    themeComponent = "framev2",
    backgroundColor = FlexLove.Color.new(0, 0, 0, 0.5)
  })
  FlexLove.new({
    parent = hudRoot,
    text = "HUD • Left-click drag or WASD/Arrows to pan • Wheel or +/- to zoom",
    textColor = FlexLove.Color.new(1, 1, 1, 1)
  })
  FlexLove.new({
    parent = hudRoot,
    text = "Press ESC to return to main menu",
    textColor = FlexLove.Color.new(0.7, 0.7, 0.7, 1)
  })
  FlexLove.new({
    parent = hudRoot,
    text = "HUD canvas (static)",
    textColor = FlexLove.Color.new(1, 1, 1, 1)
  })
  FlexLove.endFrame()
  FlexLove.draw()

  love.graphics.setCanvas()

  -- 4. Composition Pipeline
  love.graphics.setCanvas(finalCanvas)
  love.graphics.clear(0, 0, 0, 0)
  love.graphics.setColor(1, 1, 1, 1)

  -- Apply perspective shader for Game Table Layer
  love.graphics.setShader(perspectiveShader)
  love.graphics.draw(bgCanvas)
  love.graphics.draw(tableCanvas)
  love.graphics.setShader()

  love.graphics.draw(hudCanvas)

  -- Final overlay UI with FlexLove
  FlexLove.draw(
    function ()
      FlexLove.new({
        text = "FINAL composite",
        x = 10, y = 50,
        textColor = FlexLove.Color.new(1, 1, 1, 1)
      })
    end
  )

  love.graphics.setCanvas()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(finalCanvas)
end

return BeeCarbonizeSystem
