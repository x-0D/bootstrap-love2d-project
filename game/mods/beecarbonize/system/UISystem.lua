local FlexLove = require("libs.FlexLove")
local concord = require("libs.concord")

local UISystem = concord.system({
  resources = {"beecarbonize.resources"},
  gameState = {"beecarbonize.game_state"},
  sectors = {"beecarbonize.sector"},
  cards = {"beecarbonize.card"},
  cameras = {"beecarbonize.camera"},
  layers = {"beecarbonize.canvas_layer"}
})

local CARD_W = 90
local CARD_H = 120
local MAX_SLOTS = 8

local function screenToTable(x, y, cam, self)
  local cls = self:getWorld():getSystem(require("mods.beecarbonize.system.CanvasLayerSystem"))
  if cls and cls.getWarpedMouse then
    local wx, wy = cls:getWarpedMouse(x, y)
    if wx < -500 then return -1000, -1000 end -- Offscreen

    local w, h = love.graphics.getDimensions()
    local cx, cy = w / 2, h / 2
    local z_cam = cam.zoom

    -- Get the Table layer depth for accurate inverse transform
    local depth_x, depth_y = 12, 6
    for i = 1, self.layers.size do
      local e = self.layers:get(i)
      local l = e:get("beecarbonize.canvas_layer")
      if l and l.name == "Table" and l.depth then
        depth_x, depth_y = l.depth.x, l.depth.y
        break
      end
    end

    -- Inverse camera transform with high precision
    return (wx - cx) / z_cam + cx + cam.x + depth_x, (wy - cy) / z_cam + cy + cam.y + depth_y
  end
  return x, y
end

local function renderCard(parent, cardEntity, onClick)
  local card = cardEntity:get("beecarbonize.card")
  local cUI = FlexLove.new({
    id = "card_" .. tostring(cardEntity), -- Add ID for tracking
    parent = parent,
    width = CARD_W,
    height = CARD_H,
    padding = 5,
    themeComponent = "buttonv1", -- Changed from buttonv2 to buttonv1
    flexDirection = "column",
    justifyContent = "space-between",
    alignItems = "center",
    onClick = onClick,
    z = card.z or 0, -- Respect card's dynamic z-index
    transform = {
      rotate = card.rotation,
      scaleX = card.scale,
      scaleY = card.scale,
      translateX = 0,
      translateY = 0,
      skewX = card.tilt and card.tilt.skewX or 0,
      skewY = card.tilt and card.tilt.skewY or 0,
      originX = 0.5,
      originY = 0.5
    }
  })

  FlexLove.new({
    parent = cUI,
    text = modSystem.i18n.t(card.data.NameLocKey or "Card"),
    textAlign = "center",
    textSize = "sm",
    width = "100%",
    textColor = FlexLove.Color.new(0.9, 0.9, 0.9, 1)
  })

  if card.status == "upgrading" then
    FlexLove.new({
      parent = cUI,
      text = string.format("%.0f%%", (card.upgrade_progress / (card.data.UpgradeTime or 1)) * 100),
      textAlign = "center",
      textSize = "xs",
      textColor = FlexLove.Color.new(0.3, 0.8, 1.0, 1)
    })
  end

  return cUI
end

local function renderCardGrid(parent, cards, onCardClick, sectorEntity)
  local grid = FlexLove.new({
    parent = parent,
    width = "100%",
    height = 0, -- Set height to 0 with flexGrow to fill space correctly
    flexGrow = 1,
    positioning = "grid",
    gridColumns = 2,
    gridRows = 4, -- Explicitly set rows for MAX_SLOTS = 8
    columnGap = 15,
    rowGap = 15,
    padding = 15, -- Increased padding for better slot layout
    alignItems = "start"
  })

  -- Fill grid with a fixed number of slots
  for i = 1, MAX_SLOTS do
    local slot = FlexLove.new({
      id = "slot_" .. tostring(sectorEntity) .. "_" .. i,
      parent = grid,
      width = CARD_W,
      height = CARD_H,
      padding = 0,
      themeComponent = "framev4", -- Changed from framev2 to framev4 for a more distinct slot look
      justifyContent = "center",
      alignItems = "center"
    })

    -- If there's a card for this slot, render it
    local cardEntity = cards[i]
    if cardEntity then
      local card = cardEntity:get("beecarbonize.card")
      if not card.is_dragging then
        renderCard(slot, cardEntity, function() onCardClick(cardEntity) end)
      end
    end
  end

  return grid
end

function UISystem:init()
  -- UI state
  self.selected_card = nil
end

-- HUD Drawing: Drawn on HUD Layer (priority 100, no perspective)
function UISystem:drawHUD()
  FlexLove.beginFrame()

  -- Selected Card Panel (drawn on top)
  if self.selected_card then
    local card = self.selected_card:get("beecarbonize.card")
    local panel = FlexLove.new({
      width = 320, height = 480, positioning = "absolute",
      right = 20, top = 100, themeComponent = "framev1",
      flexDirection = "column", gap = 15, padding = 20,
      z = 100 -- Ensure it's on top
    })

    -- Background click to close
    FlexLove.new({
      positioning = "absolute",
      width = "100%", height = "100%",
      z = -1, -- Behind the panel content
      onClick = function()
        self.selected_card = nil
      end
    })

    FlexLove.new({ parent = panel, text = modSystem.i18n.t(card.data.NameLocKey or "Card Info"), textSize = "lg", textAlign = "center" })
    FlexLove.new({ parent = panel, text = string.format("%s: %d", modSystem.i18n.t("ui/emissions"), card.data.Emissions or 0) })

    if card.data.UpgradesTo then
      local upgrades = FlexLove.new({ parent = panel, width = "100%", flexDirection = "column", gap = 8 })
      for _, upgradeId in ipairs(card.data.UpgradesTo) do
        FlexLove.new({
          parent = upgrades, text = "Upgrade to " .. upgradeId,
          width = "100%", height = 40,
          themeComponent = "buttonv1",
          onClick = function()
            self:getWorld():getSystem(require("mods.beecarbonize.system.CardSystem")):startUpgrade(self.selected_card, upgradeId)
          end
        })
      end
    end

    FlexLove.new({
      parent = panel, text = "Close",
      width = "100%", height = 40,
      themeComponent = "buttonv1",
      onClick = function()
        self.selected_card = nil
      end
    })
  end

  FlexLove.endFrame()
  FlexLove.draw()
end

-- Helper to draw a resource "coin" with text value
local function drawResourceCoin(parent, x, y, value, color, letter)
  local coinSize = 48
  local coin = FlexLove.new({
    parent = parent,
    positioning = "absolute",
    x = x, y = y,
    width = coinSize, height = coinSize,
    cornerRadius = coinSize / 2,
    backgroundColor = color,
    borderColor = FlexLove.Color.new(0, 0, 0, 0.4),
    border = { width = 2 },
    justifyContent = "center",
    alignItems = "center",
    z = -10 -- Same z-index as sectors
  })

  -- 3D Effect: subtle shadow highlight
  FlexLove.new({
    parent = coin,
    width = coinSize - 4, height = coinSize - 4,
    cornerRadius = (coinSize - 4) / 2,
    backgroundColor = FlexLove.Color.new(1, 1, 1, 0.2),
    positioning = "absolute", x = 0, y = 0,
    z = -1
  })

  FlexLove.new({
    parent = coin,
    text = letter,
    textSize = "lg",
    textColor = FlexLove.Color.new(0, 0, 0, 0.6),
    textAlign = "center"
  })

  -- Value text next to coin
  FlexLove.new({
    parent = parent,
    positioning = "absolute",
    x = x + coinSize + 10, y = y + coinSize / 2 - 12,
    text = tostring(math.floor(value)),
    textSize = "md",
    textColor = color,
    z = -10 -- Same z-index as sectors
  })
end

-- Board Drawing: Drawn on Table Layer (priority 20, with perspective)
function UISystem:drawBoard()
  local cameraEntity = self.cameras:get(1)
  local cam = cameraEntity and cameraEntity:get("beecarbonize.camera")

  local resourcesEntity = self.resources:get(1)
  local res = resourcesEntity and resourcesEntity:get("beecarbonize.resources")

  local gameStateEntity = self.gameState:get(1)
  local gs = gameStateEntity and gameStateEntity:get("beecarbonize.game_state")

  local origGetPos = love.mouse.getPosition
  if cam then
    love.mouse.getPosition = function()
      local x, y = origGetPos()
      return screenToTable(x, y, cam, self)
    end
  end

  FlexLove.beginFrame()

  -- Root container for everything on the board
  local root = FlexLove.new({
    width = "100%", height = "100%", positioning = "absolute"
  })

  -- TABLE UI: Resources and Emissions Bar (visually matching reference)
  if res and gs then
    -- Container for all absolute UI elements
    local tableUI = FlexLove.new({
      parent = root,
      positioning = "absolute",
      width = "100%", height = "100%",
      z = 0 -- Default z-index
    })

    -- Emissions Bar Panel
    local barWidth = 1200
    local barHeight = 20
    local barX = 110
    local barY = 80 -- Moved up from 130

    local barContainer = FlexLove.new({
      parent = tableUI,
      positioning = "absolute",
      x = barX - 10, y = barY - 10,
      width = barWidth + 20, height = barHeight + 20,
      backgroundColor = FlexLove.Color.new(0.25, 0.25, 0.28, 0.95),
      borderColor = FlexLove.Color.new(0.5, 0.5, 0.55, 1),
      border = { width = 2 },
      cornerRadius = 8,
      z = -10 -- Same z-index as sectors
    })

    -- Background of the bar
    local barBg = FlexLove.new({
      parent = barContainer,
      positioning = "absolute",
      x = 10, y = 10,
      width = barWidth, height = barHeight,
      backgroundColor = FlexLove.Color.new(0.2, 0.2, 0.2, 1),
      cornerRadius = 5
    })

    -- Filled portion
    local percentage = math.min(1, res.emissions / res.max_emissions)
    local fillW = barWidth * percentage
    local color = FlexLove.Color.new(0.5, 0.5, 0.5, 1)
    if percentage > 0.8 then
      color = FlexLove.Color.new(1, 0.2, 0.2, 1)
    elseif percentage > 0.5 then
      color = FlexLove.Color.new(1, 0.8, 0.2, 1)
    else
      color = FlexLove.Color.new(0.4, 1, 0.6, 1)
    end

    FlexLove.new({
      parent = barBg,
      positioning = "absolute",
      x = 0, y = 0,
      width = fillW, height = barHeight,
      backgroundColor = color,
      cornerRadius = 5
    })

    -- Text on top of bar
    FlexLove.new({
      parent = barContainer,
      width = "100%", height = "100%",
      text = string.format("%s: %d / %d", modSystem.i18n.t("resources/emissions"), math.floor(res.emissions), res.max_emissions),
      textAlign = "center",
      textSize = "sm",
      textColor = FlexLove.Color.new(1, 1, 1, 1),
      z = 1
    })

    -- Resource Coins and Round Counter
    local coinX = 125
    local coinY = 20 -- Moved up from 50
    local coinGap = 160

    -- Round Counter (Gray)
    local roundSize = 56
    local roundContainer = FlexLove.new({
      parent = tableUI,
      positioning = "absolute",
      x = coinX - 4, y = coinY - 4,
      width = roundSize, height = roundSize,
      cornerRadius = roundSize / 2,
      backgroundColor = FlexLove.Color.new(0.12, 0.12, 0.15, 1),
      borderColor = FlexLove.Color.new(0.35, 0.35, 0.4, 1),
      border = { width = 2 },
      justifyContent = "center",
      alignItems = "center",
      z = -10 -- Same z-index as sectors
    })
    FlexLove.new({
      parent = roundContainer,
      text = tostring(gs.round),
      textSize = "lg",
      textColor = FlexLove.Color.new(0.9, 0.9, 0.95, 1)
    })

    -- Coins
    drawResourceCoin(tableUI, coinX + coinGap, coinY, res.production, FlexLove.Color.new(1, 0.4, 0.4, 1), "$")
    drawResourceCoin(tableUI, coinX + 2*coinGap, coinY, res.people, FlexLove.Color.new(1, 0.6, 0.2, 1), "P")
    drawResourceCoin(tableUI, coinX + 3*coinGap, coinY, res.science, FlexLove.Color.new(0.4, 0.6, 0.9, 1), "S")
  end

  local board = FlexLove.new({
    parent = root,
    width = "100%", height = "100%", positioning = "flex",
    flexDirection = "row", justifyContent = "center", alignItems = "center",
    paddingTop = 160, -- Increased from 80 to avoid overlap with emissions bar
    gap = 20
  })

  for _, sectorEntity in ipairs(self.sectors) do
    local sector = sectorEntity:get("beecarbonize.sector")
    local sUI = FlexLove.new({
      id = "sector_" .. tostring(sectorEntity),
      parent = board, width = 280, height = "75%", -- Reduced from 85% to accommodate top padding
      positioning = "flex", flexDirection = "vertical", alignItems = "center",
      padding = 15, gap = 15,
      themeComponent = "framev1",
      z = -10 -- Ensure sectors are visually behind all cards
    })

    FlexLove.new({ parent = sUI, text = modSystem.i18n.t(sector.name), textSize = "lg", marginBottom = 15 })

    -- Display cards in sector using the new CardGrid and Card components
    renderCardGrid(sUI, sector.cards, function(cardEntity)
      self.selected_card = cardEntity
    end, sectorEntity)
  end

  -- Render free-floating cards (cards not in any sector)
  local cardsInSectors = {}
  for _, sectorEntity in ipairs(self.sectors) do
    local sector = sectorEntity:get("beecarbonize.sector")
    for i = 1, MAX_SLOTS do
      local cardEntity = sector.cards[i]
      if cardEntity then
        cardsInSectors[cardEntity] = true
      end
    end
  end

  for _, cardEntity in ipairs(self.cards) do
    if not cardsInSectors[cardEntity] then
      local card = cardEntity:get("beecarbonize.card")
      if not card.is_dragging then
        FlexLove.new({
          id = "card_" .. tostring(cardEntity),
          parent = board,
          positioning = "absolute",
          left = card.x,
          top = card.y,
          width = CARD_W,
          height = CARD_H,
          padding = 5,
          themeComponent = "buttonv1",
          flexDirection = "column",
          justifyContent = "space-between",
          alignItems = "center",
          onClick = function() self.selected_card = cardEntity end,
          text = modSystem.i18n.t(card.data.NameLocKey or "Card"),
          textAlign = "center",
          textSize = "sm",
          textColor = FlexLove.Color.new(0.9, 0.9, 0.9, 1),
          z = card.z or 0, -- Use card's dynamic z-index
          transform = {
            rotate = card.rotation,
            scaleX = card.scale,
            scaleY = card.scale,
            translateX = 0,
            translateY = 0,
            skewX = card.tilt and card.tilt.skewX or 0,
            skewY = card.tilt and card.tilt.skewY or 0,
            originX = 0.5,
            originY = 0.5
          }
        })
      end
    end
  end

  -- Render dragged card on top
  local gameStateEntity = self.gameState:get(1)
  local gs = gameStateEntity and gameStateEntity:get("beecarbonize.game_state")
  if gs and gs.drag.active and gs.drag.entity_id then
    local card = gs.drag.entity_id:get("beecarbonize.card")
    FlexLove.new({
      parent = board, -- Add parent to keep in world space
      positioning = "absolute",
      left = card.x,
      top = card.y,
      width = CARD_W,
      height = CARD_H,
      padding = 5,
      themeComponent = "buttonv1",
      flexDirection = "column",
      justifyContent = "space-between",
      alignItems = "center",
      text = modSystem.i18n.t(card.data.NameLocKey or "Card"),
      textAlign = "center",
      textSize = "sm",
      textColor = FlexLove.Color.new(0.9, 0.9, 0.9, 1),
      z = card.z or 1000, -- Render on top of everything
      disabled = true, -- Don't block clicks while dragging
      transform = {
        rotate = card.rotation,
        scaleX = card.scale,
        scaleY = card.scale,
        translateX = 0,
        translateY = 0,
        skewX = card.tilt and card.tilt.skewX or 0,
        skewY = card.tilt and card.tilt.skewY or 0,
        originX = 0.5,
        originY = 0.5
      }
    })
  end

  FlexLove.endFrame()

  -- After layout solve, update component positions for DragSystem
  for _, sectorEntity in ipairs(self.sectors) do
    local sector = sectorEntity:get("beecarbonize.sector")
    local sUI = FlexLove.getById("sector_" .. tostring(sectorEntity))
    if sUI then
      local r = sUI:getBounds()
      if r.width > 0 then
        sector.x = r.x
        sector.y = r.y
        sector.w = r.width
      sector.h = r.height

      -- Update slot positions
      for i = 1, MAX_SLOTS do
        local slotUI = FlexLove.getById("slot_" .. tostring(sectorEntity) .. "_" .. i)
        if slotUI then
          local sr = slotUI:getBounds()
          if sr.width > 0 then
            sector.slots[i].x = sr.x
            sector.slots[i].y = sr.y
          end
        end
      end

      -- Update card positions
        for i = 1, MAX_SLOTS do
          local cardEntity = sector.cards[i]
          if cardEntity then
            local card = cardEntity:get("beecarbonize.card")
            if not card.is_dragging then
              local cUI = FlexLove.getById("card_" .. tostring(cardEntity))
              if cUI then
                local cr = cUI:getBounds()
                if cr.width > 0 then
                  card.x = cr.x
                  card.y = cr.y
                end
              end
            end
          end
        end
      end
    end
  end

  -- Sync free-floating cards
  for _, cardEntity in ipairs(self.cards) do
    if not cardsInSectors[cardEntity] then
      local card = cardEntity:get("beecarbonize.card")
      if not card.is_dragging then
        local cUI = FlexLove.getById("card_" .. tostring(cardEntity))
        if cUI then
          local cr = cUI:getBounds()
          if cr.width > 0 then
            card.x = cr.x
            card.y = cr.y
          end
        end
      end
    end
  end

  FlexLove.draw()

  if cam then
    love.mouse.getPosition = origGetPos
  end
end

-- Empty draw to satisfy concord world update if needed
function UISystem:draw()
end

return UISystem
