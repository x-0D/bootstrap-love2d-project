local concord = require("libs.concord")

local BoardSystem = concord.system({
  sectors = {"beecarbonize.sector"},
  cards = {"beecarbonize.card"}
})

function BoardSystem:init()
  -- Sectors are initialized in mod:main() in init.lua
end

function BoardSystem:update(dt)
  -- Handle card layout or sector-wide effects
end

function BoardSystem:addCardToSector(cardEntity, sectorType)
  local sectorEntity
  for _, e in ipairs(self.sectors) do
    if e:get("beecarbonize.sector").type == sectorType then
      sectorEntity = e
      break
    end
  end

  if sectorEntity then
    local sector = sectorEntity:get("beecarbonize.sector")
    -- Find first empty slot
    for i = 1, 8 do
      if not sector.cards[i] then
        sector.cards[i] = cardEntity
        break
      end
    end
    -- Update card entity position based on sector and index
    -- This would be handled by a layout system or manually here
  end
end

return BoardSystem
