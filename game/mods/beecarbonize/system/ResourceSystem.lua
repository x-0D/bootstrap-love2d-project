local concord = require("libs.concord")

local ResourceSystem = concord.system({
  resources = {"beecarbonize.resources"},
  cards = {"beecarbonize.card"}
})

function ResourceSystem:update(dt)
  local resourcesEntity = self.resources:get(1)
  if not resourcesEntity then return end
  local res = resourcesEntity:get("beecarbonize.resources")

  -- Update resources based on active cards
  for _, cardEntity in ipairs(self.cards) do
    local card = cardEntity:get("beecarbonize.card")
    if card.is_active and card.status == "idle" then
      local data = card.data
      if data and data.Speed and data.Speed > 0 then
        -- Apply card effects over time
        -- Based on Unity logic, Speed is how often the card produces/consumes
        -- For simplicity, we'll use a tick-based approach or just scale by dt
        local factor = dt * data.Speed

        if data.UpgradeBonus then
          res.production = res.production + (data.UpgradeBonus.Production or 0) * factor
          res.people = res.people + (data.UpgradeBonus.People or 0) * factor
          res.science = res.science + (data.UpgradeBonus.Science or 0) * factor
        end

        res.emissions = res.emissions + (data.Emissions or 0) * factor
      end
    end
  end

  -- Clamp emissions
  if res.emissions < 0 then res.emissions = 0 end
  -- Trigger tipping points in EventSystem
end

return ResourceSystem
