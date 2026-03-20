package.path = package.path .. ";libs/?.lua"
package.path = package.path .. ";libs/?/init.lua"
package.cpath = package.cpath .. ";libs/?.so"

package.path = package.path .. ";mods/?.lua"
package.path = package.path .. ";mods/?/init.lua"
package.cpath = package.cpath .. ";mods/?.so"

local IS_DEBUG = os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" and arg[2] == "debug"
if IS_DEBUG then
  require("lldebugger").start()

  function love.errorhandler(msg)
    error(msg, 2)
  end
end

-- Read product configuration
-- Shared between the game and CI
product_config = {}
for line in love.filesystem.lines("product.env") do
  -- Skip comment lines and blank lines
  if not (line:match("^%s*#") or line:match("^%s*$")) then
    local key, value = line:match("([^=]+)=(.*)")
    if key then
      product_config[key] = value:match('^"?(.-)"?$')
    end
  end
end

-- https://love2d.org/wiki/Config_Files
function love.conf(t)
  t.identity              = product_config["PRODUCT_ID"]
  t.appendidentity        = false
  t.version               = product_config["LOVE_VERSION"]

  -- Ensure identity is set for love.filesystem to access save directory
  love.filesystem.setIdentity(t.identity)

  -- Load saved settings if they exist
  local json = require("json")
  local saved_settings = {}
  if love.filesystem.getInfo("settings.json") then
    local content, _ = love.filesystem.read("settings.json")
    if content then
      local ok, decoded = pcall(json.decode, content)
      if ok and decoded then
        saved_settings = decoded
      end
    end
  end

  -- Optimization: If settings exist, apply them immediately to the config table
  -- Note: love.system is not yet available in love.conf, use love._os
  local isMac = (love._os == "OS X")
  if saved_settings.resolution then
    local w, h = saved_settings.resolution:match("(%d+)x(%d+)")
    if w and h then
      t.window.width = tonumber(w)
      t.window.height = tonumber(h)
    end
  end
  if saved_settings.mode then
    if saved_settings.mode == "Fullscreen" then
      t.window.fullscreen = true
      t.window.fullscreentype = isMac and "desktop" or "exclusive"
    elseif saved_settings.mode == "Borderless" then
      t.window.fullscreen = false
      t.window.borderless = true
    else
      t.window.fullscreen = false
      t.window.borderless = false
    end
  end
  if saved_settings.vsync then
    t.window.vsync = (saved_settings.vsync == "On" and 1 or 0)
  end
  if saved_settings.msaa then
    t.window.msaa = tonumber(saved_settings.msaa) or 0
  end
  if saved_settings.hidpi then
    t.window.highdpi = (saved_settings.hidpi == "On")
  end

  -- If t.console is set to true, then the debugger won't work.
  t.console               = false
  t.accelerometerjoystick = false
  t.externalstorage       = false
  t.gammacorrect          = false

  t.audio.mic             = product_config["AUDIO_MIC"]
  t.audio.mixwithsystem   = false

  t.window.title          = product_config["PRODUCT_NAME"]
  t.window.icon           = nil

  -- Default values if not set by saved settings
  t.window.width          = t.window.width or 800
  t.window.height         = t.window.height or 600
  t.window.resizable      = false
  t.window.minwidth       = 1
  t.window.minheight      = 1
  t.window.fullscreentype = "desktop"
  t.window.display        = 1
  t.window.usedpiscale    = true
  t.window.x              = nil
  t.window.y              = nil

  t.modules.audio         = true
  t.modules.data          = true
  t.modules.event         = true
  t.modules.font          = true
  t.modules.graphics      = true
  t.modules.image         = true
  t.modules.joystick      = true
  t.modules.keyboard      = true
  t.modules.math          = true
  t.modules.mouse         = true
  t.modules.physics       = true
  t.modules.sound         = true
  t.modules.system        = true
  t.modules.thread        = true
  t.modules.timer         = true
  t.modules.touch         = true
  t.modules.video         = true
  t.modules.window        = true
end
