local concord = require("libs.concord")

local EventSystem = concord.system({
  gameState = {"beecarbonize.game_state"},
  resources = {"beecarbonize.resources"},
  cards = {"beecarbonize.card"}
})

function EventSystem:update(dt)
  local gameStateEntity = self.gameState:get(1)
  if not gameStateEntity then return end
  local gs = gameStateEntity:get("beecarbonize.game_state")

  local resourcesEntity = self.resources:get(1)
  if not resourcesEntity then return end
  local res = resourcesEntity:get("beecarbonize.resources")

  -- Update time
  if not gs.is_paused then
    gs.time = gs.time + dt
    -- Update rounds (e.g., every 10 seconds)
    local oldRound = gs.round
    gs.round = math.floor(gs.time / 10)

    if gs.round > oldRound then
      self:onNewRound(gs, res)
    end
  end
end

function EventSystem:onNewRound(gs, res)
  print(string.format("[EventSystem] Round %d", gs.round))
  gs.rounds_without_event = gs.rounds_without_event + 1

  -- Trigger emissions events
  self:checkEmissionsEvents(gs, res)

  -- Random event spawning
  if gs.rounds_without_event >= 3 then
    if math.random() < 0.3 then
      self:triggerRandomEvent(gs)
    end
  end
end

function EventSystem:checkEmissionsEvents(gs, res)
  local cardSet = modSystem.getEnabledModByType("card_set")
  if not cardSet or not cardSet.event then return end

  for key, event in pairs(cardSet.event) do
    if event.EmissionsMin and res.emissions >= event.EmissionsMin then
      -- If Repeatable is 0, we should track if it already triggered
      -- For now, just log it as a generic trigger mechanism
      if math.random() < (event.InitialChance or 0.1) then
        print(string.format("[EventSystem] Emissions event triggered: %s", key))
        self:getWorld():emit("event_triggered", event)
      end
    end
  end
end

function EventSystem:triggerRandomEvent(gs)
  local cardSet = modSystem.getEnabledModByType("card_set")
  if not cardSet or not cardSet.event then return end

  -- Get all event keys
  local eventKeys = {}
  for k, _ in pairs(cardSet.event) do
    table.insert(eventKeys, k)
  end

  if #eventKeys == 0 then return end

  local randomKey = eventKeys[math.random(#eventKeys)]
  local eventData = cardSet.event[randomKey]

  print(string.format("[EventSystem] Triggering random event: %s", eventData.NameLocKey or randomKey))
  gs.rounds_without_event = 0

  -- Actual event triggering would create an entity
  self:getWorld():emit("event_triggered", eventData)
end

return EventSystem
