local concord = require("libs.concord")

local M = {}

-- Expose components/systems for other mods
M.component = {}
M.system = {
  BeeCarbonizeSystem = require("mods.beecarbonize.system.BeeCarbonizeSystem")
}
M.entity = {}


function M.main(world)
  print("[BeeCarbonize] Initializing ECS...")

  -- Initialize i18n
  modSystem.i18n.configure({
    fallbackLocale = "en",
    currentLocale = "en"
  })

  -- Ensure components are loaded
  require("mods.beecarbonize.component.Camera")
  require("mods.beecarbonize.component.CanvasLayer")
  require("mods.beecarbonize.component.Resources")
  require("mods.beecarbonize.component.Card")
  require("mods.beecarbonize.component.Sector")
  require("mods.beecarbonize.component.GameState")

  -- Register systems
  world:addSystem(M.system.BeeCarbonizeSystem)

  -- Create Game State Entity
  local gameState = concord.entity(world)
  gameState:give("beecarbonize.game_state", {
    round = 1,
    time = 0,
    event_pool = {},
    waiting_for_event_pool = {}
  })
  M.entity.gameState = gameState

  -- Create Resources Entity
  local startingResources = { production = 0, people = 0, science = 0 }
  local maxEmissions = 3000

  local cardSet = modSystem.getEnabledModByType("card_set")
  local cardSetInfo = modSystem.getEnabledModInfoByType("card_set")

  if cardSet and cardSetInfo then
    print(string.format("[BeeCarbonize] Using card set: %s (%s)", cardSetInfo.title or cardSetInfo.name, cardSetInfo.name))
    -- Load translations from card set
    if love.filesystem.getInfo(cardSetInfo.path .. "/i18n") then
      modSystem.i18n.load(cardSetInfo.path .. "/i18n")
    end

    if cardSet.sectors and cardSet.sectors.init then
      local initData = cardSet.sectors.init
      if initData.StartingResources then
        startingResources.production = initData.StartingResources.Production or 0
        startingResources.people = initData.StartingResources.People or 0
        startingResources.science = initData.StartingResources.Science or 0
      end
      maxEmissions = initData.MaxEmissions or 3000
    end
  else
    print("[BeeCarbonize] Warning: No enabled card set found!")
  end

  local resources = concord.entity(world)
  resources:give("beecarbonize.resources", {
    production = startingResources.production,
    people = startingResources.people,
    science = startingResources.science,
    emissions = 0,
    max_emissions = maxEmissions
  })
  M.entity.resources = resources

  -- Create Camera Entity
  local w, h = love.graphics.getDimensions()
  local cx, cy = w / 2, h / 2
  local cameraEntity = concord.entity(world)
  cameraEntity:give("beecarbonize.camera", {
    x = 0, y = 0,
    target_x = 0, target_y = 0,
    zoom = 1.0, target_zoom = 1.0,
    smoothing = 0.2,
    zoom_smoothing = 0.2,
    bounds = { 
      min_x = -cx, max_x = cx, 
      min_y = -cy, max_y = cy, 
      min_zoom = 0.5, max_zoom = 2.0 
    }
  })
  M.entity.camera = cameraEntity

  -- Create Sectors and Starting Cards
  if cardSet and cardSet.sectors then
    for key, sData in pairs(cardSet.sectors) do
      -- Skip non-sector metadata
      if key ~= "init" and key ~= "card_manager" and type(sData) == "table" then
        local sectorEntity = concord.entity(world)
        sectorEntity:give("beecarbonize.sector", {
          type = key,
          name = sData.m_Name or key,
          cards = {}
        })

        -- Add starting card
        local startCardId = sData.StartingCard
        if startCardId then
          local cardData
          -- Search for card in all categories
          local categories = {key, "ecosystem", "industry", "people", "science", "social"}
          for _, cat in ipairs(categories) do
            if cardSet[cat] and cardSet[cat][startCardId] then
              cardData = cardSet[cat][startCardId]
              break
            end
          end

          if cardData then
            local cardEntity = concord.entity(world)
            cardEntity:give("beecarbonize.card", {
              data = cardData,
              status = "idle",
              is_active = true
            })
            local sector = sectorEntity:get("beecarbonize.sector")
            -- Find first empty slot
            for i = 1, 8 do
              if not sector.cards[i] then
                sector.cards[i] = cardEntity
                break
              end
            end
          end
        end
      end
    end
  end

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
    end
  })
  M.entity.bgLayer = bgLayer

  -- Create Table Layer Entity (Sectors and Cards)
  local tableLayer = concord.entity(world)
  tableLayer:give("beecarbonize.canvas_layer", {
    name = "Table",
    priority = 20,
    is_camera_applied = true,
    depth = { x = 12, y = 6 },
    use_shader = true,
    draw = function(e)
      local world = e:getWorld()
      local uiSystem = world:getSystem(require("mods.beecarbonize.system.UISystem"))
      if uiSystem then
        uiSystem:drawBoard()
      end
    end
  })
  M.entity.tableLayer = tableLayer

  -- Create HUD Layer Entity (HUD and Overlays)
  local hudLayer = concord.entity(world)
  hudLayer:give("beecarbonize.canvas_layer", {
    name = "HUD",
    priority = 100,
    is_camera_applied = false,
    use_shader = false,
    draw = function(e)
      local world = e:getWorld()
      local uiSystem = world:getSystem(require("mods.beecarbonize.system.UISystem"))
      if uiSystem then
        uiSystem:drawHUD()
      end
    end
  })
  M.entity.hudLayer = hudLayer
end

return M
