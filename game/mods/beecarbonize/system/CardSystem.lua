local concord = require("libs.concord")

local CardSystem = concord.system({
  cards = {"beecarbonize.card"},
  resources = {"beecarbonize.resources"},
  sectors = {"beecarbonize.sector"},
  cameras = {"beecarbonize.camera"}
})

local CARD_W = 90

local CARD_H = 120

function CardSystem:update(dt)
  local resourcesEntity = self.resources:get(1)
  if not resourcesEntity then return end
  local res = resourcesEntity:get("beecarbonize.resources")

  -- Get Mouse position for tilt
  local mx, my = love.mouse.getPosition()

  -- Get Camera for bounds repulsion
  local camEntity = self.cameras:get(1)
  local cam = camEntity and camEntity:get("beecarbonize.camera")

  -- 0. Pre-calculate which cards are in sectors
  local cardsInSectors = {}
  for _, sectorEntity in ipairs(self.sectors) do
    local sector = sectorEntity:get("beecarbonize.sector")
    for i = 1, 8 do
      local ce = sector.cards[i]
      if ce then cardsInSectors[ce] = true end
    end
  end

  for _, cardEntity in ipairs(self.cards) do
    local card = cardEntity:get("beecarbonize.card")

    -- 1. Animation & Juice Update
    self:updateAnimations(card, dt)

    -- 2. Push Logic for free-floating cards
    if not cardsInSectors[cardEntity] and not card.is_dragging then
      self:applyRepulsion(cardEntity, card, cardsInSectors, dt, cam)
    end

    -- 3. Z-Index Management
    self:updateZIndex(cardEntity, card, cardsInSectors)

    -- 4. Upgrade logic (existing)
    if card.status == "upgrading" then
      local data = card.data
      if not data or not card.upgrade_target_id then
        card.status = "idle"
        goto continue
      end

      local upgradeTime = data.UpgradeTime or 0
      if upgradeTime <= 0 then
        -- Immediate upgrade
        self:completeUpgrade(cardEntity, card.upgrade_target_id)
      else
        card.upgrade_progress = card.upgrade_progress + dt
        if card.upgrade_progress >= upgradeTime then
          self:completeUpgrade(cardEntity, card.upgrade_target_id)
        end
      end
    end

    ::continue::
  end
end

function CardSystem:applyRepulsion(cardEntity, card, cardsInSectors, dt, cam)
  local push_force = 8000 -- Strong base force
  local friction = 15 -- High friction for immediate settling
  local max_velocity = CARD_H * 4 -- Cap velocity to prevent "explosions"

  -- 1. Card-to-Card Repulsion (Free-floating cards only)
  for _, otherEntity in ipairs(self.cards) do
    if otherEntity ~= cardEntity and not cardsInSectors[otherEntity] then
      local other = otherEntity:get("beecarbonize.card")

      if not other.is_dragging then
        local dx = card.x - other.x
        local dy = card.y - other.y

        -- AABB Overlap depths
        local overlapX = CARD_W - math.abs(dx)
        local overlapY = CARD_H - math.abs(dy)

        if overlapX > 0 and overlapY > 0 then
          -- Proportional force: normalize overlap by dimensions
          local pctX = overlapX / CARD_W
          local pctY = overlapY / CARD_H

          -- Use the smaller overlap percentage for directional push (standard AABB resolution)
          local nx, ny = 0, 0
          local magnitude = 0

          if pctX < pctY then
            nx = dx > 0 and 1 or -1
            magnitude = pctX
          else
            ny = dy > 0 and 1 or -1
            magnitude = pctY
          end

          -- Randomize if perfectly overlapping
          if math.abs(dx) < 0.1 and math.abs(dy) < 0.1 then
            nx, ny = love.math.random() > 0.5 and 1 or -1, 0
            magnitude = 0.5
          end

          local force = magnitude * push_force
          card.repulsion_x = card.repulsion_x + nx * force * dt
          card.repulsion_y = card.repulsion_y + ny * force * dt
        end
      end
    end
  end

  -- 2. Sector-to-Card Repulsion (Sectors push free-floating cards out)
  for _, sectorEntity in ipairs(self.sectors) do
    local sector = sectorEntity:get("beecarbonize.sector")
    if sector.x and sector.w > 0 then
      -- Sector AABB
      local sMinX, sMaxX = sector.x, sector.x + sector.w
      local sMinY, sMaxY = sector.y, sector.y + sector.h

      -- Card AABB
      local cMinX, cMaxX = card.x, card.x + CARD_W
      local cMinY, cMaxY = card.y, card.y + CARD_H

      -- Calculate overlap depths
      local overlapX = math.min(cMaxX, sMaxX) - math.max(cMinX, sMinX)
      local overlapY = math.min(cMaxY, sMaxY) - math.max(cMinY, sMinY)

      if overlapX > 0 and overlapY > 0 then
        -- Find center of both
        local sCX, sCY = sector.x + sector.w/2, sector.y + sector.h/2
        local cCX, cCY = card.x + CARD_W/2, card.y + CARD_H/2

        -- Direction from sector center to card
        local dx, dy = cCX - sCX, cCY - sCY

        -- Push out along the shallowest axis
        local nx, ny = 0, 0
        local pct = 0

        if overlapX/sector.w < overlapY/sector.h then
          nx = dx > 0 and 1 or -1
          pct = overlapX / CARD_W
        else
          ny = dy > 0 and 1 or -1
          pct = overlapY / CARD_H
        end

        local force = pct * push_force * 2.0 -- Sectors push very hard
        card.repulsion_x = card.repulsion_x + nx * force * dt
        card.repulsion_y = card.repulsion_y + ny * force * dt
      end
    end
  end

  -- 3. UI-to-Card Repulsion (Stats UI pushes free-floating cards away)
  local ui_elements = {
    { x = 110 - 10, y = 80 - 10, w = 1200 + 20, h = 20 + 20 }, -- Emissions Bar
    { x = 125 - 4, y = 20 - 4, w = 56, h = 56 }, -- Round Counter
    { x = 125 + 160, y = 20, w = 100, h = 48 }, -- Production Coin + Text
    { x = 125 + 2*160, y = 20, w = 100, h = 48 }, -- People Coin + Text
    { x = 125 + 3*160, y = 20, w = 100, h = 48 } -- Science Coin + Text
  }

  for _, ui in ipairs(ui_elements) do
    local uMinX, uMaxX = ui.x, ui.x + ui.w
    local uMinY, uMaxY = ui.y, ui.y + ui.h
    local cMinX, cMaxX = card.x, card.x + CARD_W
    local cMinY, cMaxY = card.y, card.y + CARD_H

    local overlapX = math.min(cMaxX, uMaxX) - math.max(cMinX, uMinX)
    local overlapY = math.min(cMaxY, uMaxY) - math.max(cMinY, uMinY)

    if overlapX > 0 and overlapY > 0 then
      local uCX, uCY = ui.x + ui.w/2, ui.y + ui.h/2
      local cCX, cCY = card.x + CARD_W/2, card.y + CARD_H/2
      local dx, dy = cCX - uCX, cCY - uCY

      local nx, ny = 0, 0
      local pct = 0

      if overlapX/ui.w < overlapY/ui.h then
        nx = dx > 0 and 1 or -1
        pct = overlapX / CARD_W
      else
        ny = dy > 0 and 1 or -1
        pct = overlapY / CARD_H
      end

      local force = pct * push_force * 3.0 -- UI pushes even harder to protect visibility
      card.repulsion_x = card.repulsion_x + nx * force * dt
      card.repulsion_y = card.repulsion_y + ny * force * dt
    end
  end

  -- 4. Camera Bounds Repulsion (Keep free-floating cards within playable area)
  if cam then
    local w, h = love.graphics.getDimensions()
    local cx, cy = w / 2, h / 2

    -- Playable world bounds (Entire area reachable by the camera)
    -- These are defined by the camera's movement limits (cam.bounds)
    -- The center of the screen (cx, cy) can move to any (cx + cam.x, cy + cam.y)
    -- where cam.x/y are restricted by cam.bounds.
    -- At zoom=1, the visible world area ranges from (cx + min_x - cx) to (cx + max_x + cx)
    local worldMinX = cam.bounds.min_x
    local worldMaxX = cam.bounds.max_x + w
    local worldMinY = cam.bounds.min_y
    local worldMaxY = cam.bounds.max_y + h

    -- Card bounds (AABB)
    local cardMinX, cardMaxX = card.x, card.x + CARD_W
    local cardMinY, cardMaxY = card.y, card.y + CARD_H

    local margin = 10 -- Extra margin to push before hitting edge
    local bounds_push = push_force * 2.5 -- Stronger than other forces

    -- Left
    if cardMinX < worldMinX + margin then
      local depth = (worldMinX + margin) - cardMinX
      card.repulsion_x = card.repulsion_x + depth * bounds_push * dt
    end
    -- Right
    if cardMaxX > worldMaxX - margin then
      local depth = cardMaxX - (worldMaxX - margin)
      card.repulsion_x = card.repulsion_x - depth * bounds_push * dt
    end
    -- Top
    if cardMinY < worldMinY + margin then
      local depth = (worldMinY + margin) - cardMinY
      card.repulsion_y = card.repulsion_y + depth * bounds_push * dt
    end
    -- Bottom
    if cardMaxY > worldMaxY - margin then
      local depth = cardMaxY - (worldMaxY - margin)
      card.repulsion_y = card.repulsion_y - depth * bounds_push * dt
    end
  end

  -- Clamp repulsion velocity
  local current_vel = math.sqrt(card.repulsion_x^2 + card.repulsion_y^2)
  if current_vel > max_velocity then
    card.repulsion_x = (card.repulsion_x / current_vel) * max_velocity
    card.repulsion_y = (card.repulsion_y / current_vel) * max_velocity
  end

  -- Apply accumulated repulsion to position
  card.x = card.x + card.repulsion_x * dt
  card.y = card.y + card.repulsion_y * dt

  -- Apply friction to repulsion velocity
  card.repulsion_x = card.repulsion_x * (1 - dt * friction)
  card.repulsion_y = card.repulsion_y * (1 - dt * friction)

  -- Hard stop
  if math.abs(card.repulsion_x) < 0.1 then card.repulsion_x = 0 end
  if math.abs(card.repulsion_y) < 0.1 then card.repulsion_y = 0 end
end

function CardSystem:updateZIndex(cardEntity, card, cardsInSectors)
  if card.is_dragging then
    card.z = 100
    card.is_placed_on_top = false
  elseif card.is_placed_on_top then
    -- Check if still overlapping anything
    local stillOverlapping = false
    for _, otherEntity in ipairs(self.cards) do
      if otherEntity ~= cardEntity then
        local other = otherEntity:get("beecarbonize.card")
        if math.abs(card.x - other.x) < CARD_W and math.abs(card.y - other.y) < CARD_H then
          stillOverlapping = true
          break
        end
      end
    end

    if stillOverlapping then
      card.z = 50 -- Lower than dragging, higher than calm
    else
      card.z = 0
      card.is_placed_on_top = false
    end
  else
    card.z = 0
  end
end

function CardSystem:updateAnimations(card, dt)
  -- Velocity tracking for drag rotation (Kinetic Effect)
  if card.is_dragging then
    card.velocity_x = (card.x - card.prev_x) / dt
    card.velocity_y = (card.y - card.prev_y) / dt
    card.prev_x = card.x
    card.prev_y = card.y

    -- Target rotation based on horizontal velocity (Leaning while moving)
    local velocity_rotation = card.velocity_x * 0.0005
    card.target_rotation = math.max(-0.25, math.min(0.25, velocity_rotation))
    card.target_scale = 1.1
  else
    card.velocity_x = 0
    card.velocity_y = 0
    card.prev_x = card.x
    card.prev_y = card.y
    card.target_rotation = 0
    card.target_scale = 1.0
  end

  -- Juice decay (Pick-up, Drop, and Swap pulses)
  if card.juice.scale > 0.001 or math.abs(card.juice.rotation) > 0.001 then
    card.juice.scale = card.juice.scale * (1 - dt * card.juice.decay_speed)
    card.juice.rotation = card.juice.rotation * (1 - dt * card.juice.decay_speed)

    if math.abs(card.juice.scale) < 0.001 then card.juice.scale = 0 end
    if math.abs(card.juice.rotation) < 0.001 then card.juice.rotation = 0 end
  end

  -- Smoothly interpolate scale and rotation
  local scale_speed = 12
  local rot_speed = 10

  card.scale = card.scale + (card.target_scale + card.juice.scale - card.scale) * dt * scale_speed

  local target_rot = card.target_rotation + card.juice.rotation
  card.rotation = card.rotation + (target_rot - card.rotation) * dt * rot_speed

  -- Reset tilt/distortion values (Remove static tilt)
  card.tilt.amt = 0
  card.tilt.angle = 0
  card.tilt.skewX = 0
  card.tilt.skewY = 0
end

function CardSystem:startUpgrade(cardEntity, targetId)
  local card = cardEntity:get("beecarbonize.card")
  local resourcesEntity = self.resources:get(1)
  if not resourcesEntity then return end
  local res = resourcesEntity:get("beecarbonize.resources")

  -- Load target card data
  -- Assuming card set mod is accessible via modSystem
  local cardSet = modSystem.getEnabledModByType("card_set")
  if not cardSet then return end

  local targetData
  -- Search in all categories
  for _, category in pairs(cardSet) do
    if type(category) == "table" and category[tostring(targetId)] then
      targetData = category[tostring(targetId)]
      break
    end
  end

  if not targetData then return end

  -- Check costs
  local cost = targetData.UpgradeCostBase or {}
  if res.production >= (cost.Production or 0) and
     res.people >= (cost.People or 0) and
     res.science >= (cost.Science or 0) then

    -- Deduct costs
    res.production = res.production - (cost.Production or 0)
    res.people = res.people - (cost.People or 0)
    res.science = res.science - (cost.Science or 0)

    card.status = "upgrading"
    card.upgrade_progress = 0
    card.upgrade_target_id = targetId
  end
end

function CardSystem:completeUpgrade(cardEntity, targetId)
  local card = cardEntity:get("beecarbonize.card")

  -- Load target card data
  local cardSet = modSystem.getEnabledModByType("card_set")
  if not cardSet then return end

  local targetData
  for _, category in pairs(cardSet) do
    if type(category) == "table" and category[tostring(targetId)] then
      targetData = category[tostring(targetId)]
      break
    end
  end

  if targetData then
    card.data = targetData
    card.status = "idle"
    card.upgrade_progress = 0
    card.upgrade_target_id = nil

    -- Emit event
    self:getWorld():emit("card_upgraded", cardEntity)
  end
end

return CardSystem
