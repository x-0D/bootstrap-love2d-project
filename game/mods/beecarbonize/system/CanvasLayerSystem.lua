local concord = require("libs.concord")

local CanvasLayerSystem = concord.system({
  layers = { "beecarbonize.canvas_layer" },
  cameras = { "beecarbonize.camera" }
})

local perspectiveCode = [[
  extern float fov, y_rot, x_rot, inset, zoom;
  extern bool cull_back;
  extern vec2 u_texture_size;
  extern bool u_picking;

  varying vec2 v_o;
  varying vec3 v_p;

  #ifdef VERTEX
  vec4 position(mat4 transform_projection, vec4 vertex_pos) {
    vec2 rot = radians(vec2(y_rot, x_rot));
    vec2 s = sin(rot), c = cos(rot);

    // Rotation matrix (Y then X)
    mat3 m = mat3(
       c.x,       0.0, -s.x,
       s.x * s.y, c.y,  c.x * s.y,
       s.x * c.y, -s.y, c.x * c.y
    );

    float t = tan(radians(fov * 0.5));
    vec2 uv = VertexTexCoord.xy - 0.5;

    v_p = m * vec3(uv, 0.5 / t);
    float v = 0.5 / t + 0.5;
    v_p.xy *= v * m[2].z;
    v_o = v * m[2].xy;

    vertex_pos.xy += uv * u_texture_size * t * (1.0 - inset);
    return transform_projection * vertex_pos;
  }
  #endif

  #ifdef PIXEL
  vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
    if (cull_back && v_p.z <= 0.0) discard;
    vec2 uv = (v_p.xy / v_p.z - v_o) / zoom + 0.5;

    if (u_picking) {
      return vec4(uv, 0.0, 1.0);
    }

    vec4 tex_color = Texel(tex, uv);
    tex_color.a *= step(max(abs(uv.x - 0.5), abs(uv.y - 0.5)), 0.5);

    return tex_color * color;
  }
  #endif
]]

function CanvasLayerSystem:init()
  local fov = 90.0
  local x_rot = 25.0
  local y_rot = 0.0

  -- Calculate zoom to fill screen edges
  local t = math.tan(math.rad(fov / 2))
  local zoom = (1.02 + (math.sin(math.abs(math.rad(x_rot))) + math.sin(math.abs(math.rad(y_rot)))) * t)

  self.perspectiveShader = love.graphics.newShader(perspectiveCode)
  self.perspectiveShader:send("fov", fov)
  self.perspectiveShader:send("y_rot", y_rot)
  self.perspectiveShader:send("x_rot", x_rot)
  self.perspectiveShader:send("inset", 0.0)
  self.perspectiveShader:send("zoom", zoom)
  self.perspectiveShader:send("cull_back", true)
  self.perspectiveShader:send("u_picking", false)

  self.pickingCanvas = love.graphics.newCanvas(1, 1, {format = "rgba32f"})
  self.pickingImageData = love.image.newImageData(1, 1, "rgba32f")
  self.finalCanvas = nil
  self.lastW = 0
  self.lastH = 0
  self.sortedLayers = {}

  -- Performance Caching
  self.lastMx, self.lastMy = -1, -1
  self.cachedWx, self.cachedWy = -1, -1
  self.lastFrame = 0
end

function CanvasLayerSystem:warpMouse(mx, my)
  local targetLayer = nil
  for _, e in ipairs(self.sortedLayers) do
    local l = e:get("beecarbonize.canvas_layer")
    if l.use_shader and l.canvas then
      targetLayer = l
      break
    end
  end

  if not targetLayer then return mx, my end

  local cw, ch = targetLayer.canvas:getDimensions()

  -- Store current state
  local prevCanvas = love.graphics.getCanvas()

  -- 1x1 Readback
  love.graphics.setCanvas(self.pickingCanvas)
  love.graphics.clear(0, 0, 0, 0)

  love.graphics.push("all")
  love.graphics.origin()
  love.graphics.translate(-mx, -my)

  self.perspectiveShader:send("u_texture_size", {cw, ch})
  self.perspectiveShader:send("u_picking", true)
  love.graphics.setShader(self.perspectiveShader)

  -- Draw the target layer's canvas
  love.graphics.draw(targetLayer.canvas)

  love.graphics.setShader()
  love.graphics.pop()

  -- Restore state
  love.graphics.setCanvas(prevCanvas)

  -- Use Canvas:newImageData to get the current pixel data
  local imageData = self.pickingCanvas:newImageData()
  local r, g, b, a = imageData:getPixel(0, 0)

  if a == 0 then
    return -1000, -1000
  end

  return r * cw, g * ch
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
  self.lastFrame = self.lastFrame + 1
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

function CanvasLayerSystem:getWarpedMouse(mx, my)
  if not mx or not my then
    mx, my = love.mouse.getPosition()
  end

  if mx == self.lastMx and my == self.lastMy and self.lastWarpFrame == self.lastFrame then
    return self.cachedWx, self.cachedWy
  end

  self.cachedWx, self.cachedWy = self:warpMouse(mx, my)
  self.lastMx, self.lastMy = mx, my
  self.lastWarpFrame = self.lastFrame
  return self.cachedWx, self.cachedWy
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
      love.graphics.translate(cx, cy)
      love.graphics.scale(cam.zoom)
      love.graphics.translate(-cx - cam.x - l.depth.x, -cy - cam.y - l.depth.y)
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
        local cw, ch = l.canvas:getDimensions()
        self.perspectiveShader:send("u_texture_size", {cw, ch})
        self.perspectiveShader:send("u_picking", false) -- ENSURE NO PICKING
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
