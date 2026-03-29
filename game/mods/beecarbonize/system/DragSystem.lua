local concord = require("libs.concord")

local DragSystem = concord.system({
  gameState = {"beecarbonize.game_state"},
  cards = {"beecarbonize.card"},
  sectors = {"beecarbonize.sector"},
  cameras = {"beecarbonize.camera"},
  layers = {"beecarbonize.canvas_layer"}
})

local CARD_W = 90
local CARD_H = 120

function DragSystem:init()
  self.mouse_pressed = false
end

function DragSystem:update(dt)
  local gameStateEntity = self.gameState:get(1)
  if not gameStateEntity then return end
  local gs = gameStateEntity:get("beecarbonize.game_state")

  if gs.is_paused or gs.game_over then return end

  local mx, my = love.mouse.getPosition()
  local wx, wy = self:getWarpedMouse(mx, my)

  -- Handle Mouse Pressed
  if love.mouse.isDown(1) then
    if not self.mouse_pressed then
      self.mouse_pressed = true
      if wx > -500 then
        self:handleMousePressed(wx, wy, mx, my, gs)
      end
    else
      self:handleMouseMoved(wx, wy, mx, my, gs)
    end
  else
    if self.mouse_pressed then
      self.mouse_pressed = false
      self:handleMouseReleased(wx, wy, gs)
    end
  end

  -- Update dragged card position
  if gs.drag.active and gs.drag.entity_id then
    local cardEntity = gs.drag.entity_id
    local card = cardEntity:get("beecarbonize.card")
    if card and wx > -500 then
      card.x = wx - gs.drag.offset_x
      card.y = wy - gs.drag.offset_y

      -- Update drag target (which sector/slot we are hovering over)
      self:updateDragTarget(card.x + CARD_W/2, card.y + CARD_H/2, gs)
    end
  end
end

function DragSystem:handleMousePressed(world_x, world_y, screen_x, screen_y, gs)
  -- Don't start drag if UI is blocking (handled by UISystem usually, but we check here too)
  -- For now, find which card is at world_x, world_y
  local clicked_card = self:getCardAt(world_x, world_y)

  if clicked_card then
    local card = clicked_card:get("beecarbonize.card")
    if card.is_event then return end -- Event cards cannot be dragged

    gs.drag.pending_entity = clicked_card
    gs.drag.pending_x = screen_x
    gs.drag.pending_y = screen_y
  end
end

function DragSystem:handleMouseMoved(world_x, world_y, screen_x, screen_y, gs)
  if gs.drag.pending_entity and not gs.drag.active then
    local dx = screen_x - gs.drag.pending_x
    local dy = screen_y - gs.drag.pending_y
    local dist = math.sqrt(dx*dx + dy*dy)

    if dist > 5 then
      self:startDrag(gs.drag.pending_entity, world_x, world_y, gs)
      gs.drag.pending_entity = nil
    end
  end
end

function DragSystem:handleMouseReleased(world_x, world_y, gs)
  if gs.drag.active then
    -- If dropped offscreen, return to source
    if world_x < -500 then
      self:returnToSource(gs.drag.entity_id, gs)
      gs.drag.active = false
      gs.drag.entity_id = nil
    else
      self:endDrag(gs)
    end
  end
  gs.drag.pending_entity = nil
end

function DragSystem:startDrag(cardEntity, world_x, world_y, gs)
  local card = cardEntity:get("beecarbonize.card")

  gs.drag.active = true
  gs.drag.entity_id = cardEntity
  gs.drag.offset_x = world_x - card.x
  gs.drag.offset_y = world_y - card.y
  gs.drag.original_x = card.x
  gs.drag.original_y = card.y

  -- Find source sector and slot
  for _, sectorEntity in ipairs(self.sectors) do
    local sector = sectorEntity:get("beecarbonize.sector")
    for i = 1, 8 do
      if sector.cards[i] == cardEntity then
        gs.drag.source_sector = sectorEntity
        gs.drag.source_slot = i
        break
      end
    end
  end

  card.is_dragging = true

  -- Initial juice for pickup
  card.juice.scale = 0.12
  card.juice.rotation = 0.18
end

function DragSystem:endDrag(gs)
  local cardEntity = gs.drag.entity_id
  local card = cardEntity:get("beecarbonize.card")

  -- Drop juice
  card.juice.scale = card.juice.scale + 0.08
  card.juice.rotation = card.juice.rotation + 0.12

  if gs.drag.target_sector and gs.drag.target_slot then
    local target_sector = gs.drag.target_sector:get("beecarbonize.sector")
    local target_slot = gs.drag.target_slot
    local target_entity = gs.drag.target_entity_id

    -- If target is the same as source, just return
    if gs.drag.target_sector == gs.drag.source_sector and target_slot == gs.drag.source_slot then
      self:returnToSource(cardEntity, gs)
    else
      -- Handle swap or move
      if target_entity and target_entity ~= cardEntity then
        self:swapCards(cardEntity, target_entity, gs.drag.source_sector, gs.drag.source_slot, gs.drag.target_sector, target_slot, gs.drag.original_x, gs.drag.original_y)
      else
        self:moveCard(cardEntity, gs.drag.source_sector, gs.drag.source_slot, gs.drag.target_sector, target_slot)
      end
    end
  else
    -- Dropped in "free space" or invalid target (like Events)
    -- Check if it was dropped over any sector
    local dropped_sector = self:getSectorAt(card.x + CARD_W/2, card.y + CARD_H/2)
    if dropped_sector then
      -- Dropped over a sector but not a specific slot, or sector is read-only (Events)
      -- For now, return to source if it's Events
      local s = dropped_sector:get("beecarbonize.sector")
      if s.type == "events" then
        self:returnToSource(cardEntity, gs)
      else
        -- Find first available slot in sector (that's not the card itself)
        local next_slot = nil
        for i = 1, 8 do
          if not s.cards[i] or s.cards[i] == cardEntity then
            next_slot = i
            break
          end
        end

        if next_slot then
           self:moveCard(cardEntity, gs.drag.source_sector, gs.drag.source_slot, dropped_sector, next_slot)
        else
           self:returnToSource(cardEntity, gs)
        end
      end
    else
      -- Free floating - stay where it is, but remove from sector
      if gs.drag.source_sector then
        local source_sector = gs.drag.source_sector:get("beecarbonize.sector")
        if gs.drag.source_slot then
          source_sector.cards[gs.drag.source_slot] = nil
        end
      end
      card.is_dragging = false
      card.is_placed_on_top = true -- Mark as placed on top to maintain high z-index
    end
  end

  -- Reset drag state
  gs.drag.active = false
  gs.drag.entity_id = nil
  gs.drag.source_sector = nil
  gs.drag.source_slot = nil
  gs.drag.target_sector = nil
  gs.drag.target_slot = nil
  gs.drag.target_entity_id = nil
end

function DragSystem:returnToSource(cardEntity, gs)
  local card = cardEntity:get("beecarbonize.card")
  card.x = gs.drag.original_x
  card.y = gs.drag.original_y
  card.is_dragging = false
end

function DragSystem:moveCard(cardEntity, sourceSectorEntity, sourceSlot, targetSectorEntity, targetSlot)
  local card = cardEntity:get("beecarbonize.card")

  -- Remove from source
  if sourceSectorEntity then
    local source_sector = sourceSectorEntity:get("beecarbonize.sector")
    source_sector.cards[sourceSlot] = nil
  end

  -- Add to target
  local target_sector = targetSectorEntity:get("beecarbonize.sector")
  target_sector.cards[targetSlot] = cardEntity

  card.is_dragging = false
end

function DragSystem:swapCards(card1, card2, sector1, slot1, sector2, slot2, original_x, original_y)
  local c1 = card1:get("beecarbonize.card")
  local c2 = card2:get("beecarbonize.card")

  local s2 = sector2:get("beecarbonize.sector")
  s2.cards[slot2] = card1

  if sector1 then
    local s1 = sector1:get("beecarbonize.sector")
    s1.cards[slot1] = card2
  else
    -- If source was free-floating, the swapped card becomes free-floating
    -- at the original position of the dragged card
    c2.x = original_x
    c2.y = original_y
    c2.is_placed_on_top = true
  end

  c1.is_dragging = false

  -- Add juice to swapped card
  c2.juice.scale = c2.juice.scale + 0.1
  c2.juice.rotation = c2.juice.rotation + 0.15
end

function DragSystem:updateDragTarget(world_x, world_y, gs)
  -- Reset target
  gs.drag.target_sector = nil
  gs.drag.target_slot = nil
  gs.drag.target_entity_id = nil

  -- Find sector under mouse
  local sectorEntity = self:getSectorAt(world_x, world_y)
  if sectorEntity then
    local sector = sectorEntity:get("beecarbonize.sector")
    if sector.type == "events" then return end -- Cannot drop on events

    gs.drag.target_sector = sectorEntity

    -- Find the nearest slot in the sector
    local minDist = math.huge
    local nearestSlot = nil

    for i = 1, 8 do
      local slotPos = sector.slots[i]
      if slotPos and slotPos.x > 0 then
        local dx = world_x - (slotPos.x + CARD_W/2)
        local dy = world_y - (slotPos.y + CARD_H/2)
        local dist = dx*dx + dy*dy

        if dist < minDist then
          minDist = dist
          nearestSlot = i
        end
      end
    end

    if nearestSlot then
      gs.drag.target_slot = nearestSlot
      -- Check if slot is occupied (and not by the card we are dragging)
      local occupant = sector.cards[nearestSlot]
      if occupant and occupant ~= gs.drag.entity_id then
        gs.drag.target_entity_id = occupant
      else
        gs.drag.target_entity_id = nil
      end
    end
  end
end

function DragSystem:getCardAt(world_x, world_y)
  -- Iterate in reverse to find top-most
  for i = self.cards.size, 1, -1 do
    local e = self.cards:get(i)
    local card = e:get("beecarbonize.card")
    if world_x >= card.x and world_x <= card.x + CARD_W and
       world_y >= card.y and world_y <= card.y + CARD_H then
      return e
    end
  end
  return nil
end

function DragSystem:getSectorAt(world_x, world_y)
  -- This is tricky because sectors don't have explicit bounds in world space yet.
  -- They are positioned by FlexLove.
  -- We might need to add bounds to the Sector component or query UISystem.
  -- For now, let's assume we can find them if they had bounds.
  -- Since they don't, I'll use a heuristic: a sector is roughly 280x600.
  -- I'll check against the positions of cards within sectors if any.

  -- Better approach: sectors should probably have their positions updated by UISystem.
  -- Let's add x, y, w, h to Sector component.
  for i = 1, self.sectors.size do
    local e = self.sectors:get(i)
    local s = e:get("beecarbonize.sector")
    if s.x and world_x >= s.x and world_x <= s.x + s.w and
       world_y >= s.y and world_y <= s.y + s.h then
      return e
    end
  end
  return nil
end

function DragSystem:getWarpedMouse(x, y)
  local cls = self:getWorld():getSystem(require("mods.beecarbonize.system.CanvasLayerSystem"))
  if cls and cls.getWarpedMouse then
    local wx, wy = cls:getWarpedMouse(x, y)
    if wx < -500 then return -1000, -1000 end

    local cameraEntity = self.cameras:get(1)
    if not cameraEntity then return wx, wy end
    local cam = cameraEntity:get("beecarbonize.camera")

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

return DragSystem
