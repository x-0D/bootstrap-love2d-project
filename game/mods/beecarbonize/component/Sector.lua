local concord = require("libs.concord")

local Sector = concord.component("beecarbonize.sector", function(c, options)
  c.type = options.type or "unknown" -- "ecosystem", "energy", "industry", "social", "science"
  c.name = options.name or "Unknown Sector"
  c.cards = options.cards or {} -- List of card entities

  -- Bounds (filled by UISystem)
  c.x = options.x or 0
  c.y = options.y or 0
  c.w = options.w or 280
  c.h = options.h or 600

  -- Slot positions (filled by UISystem)
  c.slots = {}
  for i = 1, 8 do
    c.slots[i] = { x = 0, y = 0 }
  end
end)

return Sector
