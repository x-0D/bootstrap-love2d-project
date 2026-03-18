local concord = require("libs.concord")
local FlexLove = require("libs.FlexLove")

local CanvasLayerSystem = concord.system({
  layers = { "beecarbonize.canvas_layer" },
  cameras = { "beecarbonize.camera" }
})

local TILT_FACTOR = 0.2
local perspectiveCode = [[
  extern float tilt;
  vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
    float scale = 1.0 - tilt * tc.y;
    float x_tex = (tc.x - 0.5) * scale + 0.5;
    if (x_tex < 0.0 || x_tex > 1.0) {
      return vec4(0.0);
    }
    return Texel(tex, vec2(x_tex, tc.y)) * color;
  }
]]

function CanvasLayerSystem:init()
  self.perspectiveShader = love.graphics.newShader(perspectiveCode)
  self.perspectiveShader:send("tilt", TILT_FACTOR)
  self.finalCanvas = nil
  self.lastW = 0
  self.lastH = 0
  self.sortedLayers = {}
end

function CanvasLayerSystem:ensureCanvases()
  local w, h = love.graphics.getDimensions()
  if not self.finalCanvas or w ~= self.lastW or h ~= self.lastH then
    self.finalCanvas = love.graphics.newCanvas(w, h)
    self.lastW, self.lastH = w, h
    -- Force recreate canvases for all layers
    for i = 1, self.layers.size do
      local e = self.layers:get(i)
      local l = e["beecarbonize.canvas_layer"]
      l.canvas = love.graphics.newCanvas(w, h)
    end
  end
end

function CanvasLayerSystem:update(dt)
  self:ensureCanvases()
  -- Sort layers by priority
  self.sortedLayers = {}
  for i = 1, self.layers.size do
    local e = self.layers:get(i)
    table.insert(self.sortedLayers, e)
  end
  table.sort(self.sortedLayers, function(a, b)
    local la = a["beecarbonize.canvas_layer"]
    local lb = b["beecarbonize.canvas_layer"]
    return la.priority < lb.priority
  end)
end

function CanvasLayerSystem:draw()
  self:ensureCanvases()
  if not self.finalCanvas then return end

  local w, h = love.graphics.getDimensions()
  local cx, cy = w / 2, h / 2
  local cam = self.cameras.size > 0 and self.cameras:get(1)["beecarbonize.camera"]

  -- 1. Draw each layer into its canvas
  for _, e in ipairs(self.sortedLayers) do
    local l = e["beecarbonize.canvas_layer"]
    if not l.canvas then
      l.canvas = love.graphics.newCanvas(w, h)
    end

    love.graphics.setCanvas(l.canvas)
    love.graphics.clear(0, 0, 0, 0)

    if l.is_camera_applied and cam then
      love.graphics.push()
      love.graphics.translate(cam.x + l.depth.x + cx, cam.y + l.depth.y + cy)
      love.graphics.scale(cam.zoom)
      love.graphics.translate(-cx, -cy)
    end

    if type(l.draw) == "function" then
      l.draw(e) -- Pass the entity to the draw function
    end

    if l.is_camera_applied and cam then
      love.graphics.pop()
    end
    love.graphics.setCanvas()
  end

  -- 2. Composition Pipeline
  love.graphics.setCanvas(self.finalCanvas)
  love.graphics.clear(0, 0, 0, 0)
  love.graphics.setColor(1, 1, 1, 1)

  for _, e in ipairs(self.sortedLayers) do
    local l = e["beecarbonize.canvas_layer"]
    if l.canvas then -- EXTRA CHECK HERE
      if l.use_shader then
        love.graphics.setShader(self.perspectiveShader)
      end
      love.graphics.draw(l.canvas)
      if l.use_shader then
        love.graphics.setShader()
      end
    end
  end

  love.graphics.setCanvas()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(self.finalCanvas)
end

function CanvasLayerSystem:leave()
  print("[CanvasLayerSystem] Disposing canvases...")
  if self.finalCanvas then
    self.finalCanvas:release()
    self.finalCanvas = nil
  end
  for i = 1, self.layers.size do
    local e = self.layers:get(i)
    local l = e["beecarbonize.canvas_layer"]
    if l.canvas then
      l.canvas:release()
      l.canvas = nil
    end
  end
end

return CanvasLayerSystem
