local concord = require("libs.concord")

local PanCameraSystem = concord.system({
  cameras = { "beecarbonize.camera" }
})

local function clamp(v, minv, maxv)
  if v < minv then return minv end
  if v > maxv then return maxv end
  return v
end

local function set_target(cam, x, y, lastW, lastH)
  local cx, cy = (lastW or 800) / 2, (lastH or 600) / 2
  local depth_x, depth_y = 12, 6 -- Assuming constant for now, could be component-based
  local min_x = -cx * cam.target_zoom - depth_x
  local max_x = cx * cam.target_zoom - depth_x
  local min_y = -cy * cam.target_zoom - depth_y
  local max_y = cy * cam.target_zoom - depth_y

  cam.target_x = clamp(x, min_x, max_x)
  cam.target_y = clamp(y, min_y, max_y)
end

function PanCameraSystem:update(dt)
  local w, h = love.graphics.getDimensions()
  local speed = 400 * dt

  for i = 1, self.cameras.size do
    local e = self.cameras:get(i)
    local cam = e["beecarbonize.camera"]

    -- Input
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
      set_target(cam, cam.target_x + speed, cam.target_y, w, h)
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
      set_target(cam, cam.target_x - speed, cam.target_y, w, h)
    end
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
      set_target(cam, cam.target_x, cam.target_y + speed, w, h)
    end
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
      set_target(cam, cam.target_x, cam.target_y - speed, w, h)
    end
    if love.keyboard.isDown("=") or love.keyboard.isDown("+") or love.keyboard.isDown("e") then
      cam.target_zoom = clamp(cam.target_zoom + 0.02, cam.bounds.min_zoom, cam.bounds.max_zoom)
      set_target(cam, cam.target_x, cam.target_y, w, h)
    end
    if love.keyboard.isDown("-") or love.keyboard.isDown("_") or love.keyboard.isDown("q") then
      cam.target_zoom = clamp(cam.target_zoom - 0.02, cam.bounds.min_zoom, cam.bounds.max_zoom)
      set_target(cam, cam.target_x, cam.target_y, w, h)
    end

    -- Mouse Drag
    if love.mouse.isDown(1) then
      local mx, my = love.mouse.getPosition()
      if not cam.is_dragging then
        cam.is_dragging = true
        cam.drag_start_x = mx
        cam.drag_start_y = my
        cam.drag_camera_start_x = cam.target_x
        cam.drag_camera_start_y = cam.target_y
      else
        local dx = mx - cam.drag_start_x
        local dy = my - cam.drag_start_y
        set_target(cam, cam.drag_camera_start_x + dx, cam.drag_camera_start_y + dy, w, h)
      end
    else
      cam.is_dragging = false
    end

    -- Smoothing
    local dx = cam.target_x - cam.x
    local dy = cam.target_y - cam.y
    cam.x = cam.x + dx * cam.smoothing
    cam.y = cam.y + dy * cam.smoothing

    local dz = cam.target_zoom - cam.zoom
    cam.zoom = cam.zoom + dz * cam.zoom_smoothing
  end
end

function PanCameraSystem:wheelmoved(x, y)
  local w, h = love.graphics.getDimensions()
  for i = 1, self.cameras.size do
    local e = self.cameras:get(i)
    local cam = e["beecarbonize.camera"]
    cam.target_zoom = clamp(cam.target_zoom + y * 0.1, cam.bounds.min_zoom, cam.bounds.max_zoom)
    set_target(cam, cam.target_x, cam.target_y, w, h)
  end
end

return PanCameraSystem
