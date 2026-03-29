local FlexLove = require("libs.FlexLove")
local concord = require("libs.concord")

-- Load Components and Systems
local CameraComponent = require("mods.beecarbonize.component.Camera")
local CanvasLayerComponent = require("mods.beecarbonize.component.CanvasLayer")
local ResourcesComponent = require("mods.beecarbonize.component.Resources")
local CardComponent = require("mods.beecarbonize.component.Card")
local SectorComponent = require("mods.beecarbonize.component.Sector")
local GameStateComponent = require("mods.beecarbonize.component.GameState")

local PanCameraSystem = require("mods.beecarbonize.system.PanCameraSystem")
local CanvasLayerSystem = require("mods.beecarbonize.system.CanvasLayerSystem")
local ResourceSystem = require("mods.beecarbonize.system.ResourceSystem")
local CardSystem = require("mods.beecarbonize.system.CardSystem")
local EventSystem = require("mods.beecarbonize.system.EventSystem")
local BoardSystem = require("mods.beecarbonize.system.BoardSystem")
local UISystem = require("mods.beecarbonize.system.UISystem")
local DragSystem = require("mods.beecarbonize.system.DragSystem")

local BeeCarbonizeSystem = concord.system({})

-- System Callbacks
function BeeCarbonizeSystem:init()
  FlexLove.init({
    theme = "metal",
    immediateMode = true,
    autoFrameManagement = false
  })

  -- Initialize World
  local world = self:getWorld()
  world:addSystems(
    DragSystem,
    PanCameraSystem,
    CanvasLayerSystem,
    ResourceSystem,
    CardSystem,
    EventSystem,
    BoardSystem,
    UISystem
  )
end

function BeeCarbonizeSystem:update(dt)
  -- The world will update PanCameraSystem and CanvasLayerSystem
end

function BeeCarbonizeSystem:draw()
  -- The world will draw CanvasLayerSystem and UISystem
end

function BeeCarbonizeSystem:leave()
  print("[BeeCarbonizeSystem] Leaving...")
end

return BeeCarbonizeSystem
