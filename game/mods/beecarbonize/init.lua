local FlexLove = require("libs.FlexLove")

local M = {}

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
local lastW, lastH
local _debugAccum = 0
local DEBUG = false

local function ensureCanvases()
  local w, h = love.graphics.getDimensions()
  if not finalCanvas or w ~= lastW or h ~= lastH then
    bgCanvas = love.graphics.newCanvas(w, h)
    tableCanvas = love.graphics.newCanvas(w, h)
    hudCanvas = love.graphics.newCanvas(w, h)
    finalCanvas = love.graphics.newCanvas(w, h)
    lastW, lastH = w, h
  end
end

local function clamp(v, minv, maxv)
  if v < minv then return minv end
  if v > maxv then return maxv end
  return v
end

local function set_target(x, y)
  camera.target_x = clamp(x, camera.bounds.min_x, camera.bounds.max_x)
  camera.target_y = clamp(y, camera.bounds.min_y, camera.bounds.max_y)
end

local function pan(dx, dy)
  set_target(camera.target_x + dx, camera.target_y + dy)
end

local function set_zoom(level)
  camera.target_zoom = clamp(level, camera.bounds.min_zoom, camera.bounds.max_zoom)
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
  local tx = camera.x + depth.x
  local ty = camera.y + depth.y
  local z = camera.zoom
  return (x - tx) / z, (y - ty) / z
end

function M.init(api)
  M.api = api
end

function M.enable(api)
  FlexLove.init({
    theme = "space",
    immediateMode = false,
    autoFrameManagement = true
  })
end

function M.disable(api)
  FlexLove.destroy()
end

function M.destroy(api)
  FlexLove.destroy()
end

function M.update(dt, api)
  ensureCanvases()
  local speed = 400 * dt
  if love.keyboard.isDown("left") or love.keyboard.isDown("a") then pan(speed, 0) end
  if love.keyboard.isDown("right") or love.keyboard.isDown("d") then pan(-speed, 0) end
  if love.keyboard.isDown("up") or love.keyboard.isDown("w") then pan(0, speed) end
  if love.keyboard.isDown("down") or love.keyboard.isDown("s") then pan(0, -speed) end
  if love.keyboard.isDown("=") or love.keyboard.isDown("+") or love.keyboard.isDown("e") then adjust_zoom(0.02) end
  if love.keyboard.isDown("-") or love.keyboard.isDown("_") or love.keyboard.isDown("q") then adjust_zoom(-0.02) end
  if love.mouse.isDown(2) then
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

  if api and api.setGameState then
    api.setGameState("camera", { x = camera.x, y = camera.y, depth = depth, zoom = camera.zoom })
  end

  if DEBUG then
    _debugAccum = _debugAccum + dt
    if _debugAccum >= 0.5 then
      print(string.format("[BeeCarbonize] cam=(%.1f, %.1f) tgt=(%.1f, %.1f) zoom=%.2f dragging=%s",
        camera.x, camera.y, camera.target_x, camera.target_y, camera.zoom, tostring(camera.is_dragging)))
      _debugAccum = 0
    end
  end
end

function M.draw(api)
  ensureCanvases()

  love.graphics.setCanvas(bgCanvas)
  love.graphics.clear(0.5, 0.5, 0.5, 1)
  love.graphics.push()
  love.graphics.translate(camera.x, camera.y)
  love.graphics.scale(camera.zoom)
  love.graphics.setColor(0.4, 0.4, 0.45, 1)
  love.graphics.rectangle("fill", 0, 0, lastW, lastH)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print(string.format("BG canvas • cam=(%.1f,%.1f) zoom=%.2f", camera.x, camera.y, camera.zoom), 8, 8)
  love.graphics.pop()
  love.graphics.setCanvas()

  love.graphics.setCanvas(tableCanvas)
  love.graphics.clear(0, 0, 0, 0)
  love.graphics.push()
  love.graphics.translate(camera.x + depth.x, camera.y + depth.y)
  love.graphics.scale(camera.zoom)

  local origGetPos = love.mouse.getPosition
  love.mouse.getPosition = function()
    local x, y = origGetPos()
    return screenToTable(x, y)
  end

  FlexLove.draw(function()
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
      textSize = "xl"
    })
    FlexLove.new({
      parent = root,
      width = 320,
      height = 200,
      backgroundColor = FlexLove.Color.new(0.2, 0.2, 0.25, 0.6)
    })
  end)

  love.mouse.getPosition = origGetPos
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print(string.format("TABLE canvas • cam=(%.1f,%.1f) depth=(%.1f,%.1f) zoom=%.2f", camera.x, camera.y, depth.x, depth.y, camera.zoom), 8, 28)
  love.graphics.pop()
  love.graphics.setCanvas()

  love.graphics.setCanvas(hudCanvas)
  love.graphics.clear(0, 0, 0, 0)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("HUD • Right-click drag or WASD/Arrows to pan • +/- to zoom", 10, 10)
  love.graphics.print("HUD canvas (static)", 10, 30)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setCanvas()

  love.graphics.setCanvas(finalCanvas)
  love.graphics.clear(0, 0, 0, 0)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(bgCanvas)
  love.graphics.draw(tableCanvas)
  love.graphics.draw(hudCanvas)
  love.graphics.print("FINAL composite", 10, 50)
  love.graphics.setCanvas()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(finalCanvas)
end

function M.screenToTable(x, y)
  return screenToTable(x, y)
end

return M
