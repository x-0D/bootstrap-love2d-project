local concord = require("libs.concord")

local GameState = concord.component("beecarbonize.game_state", function(c, options)
  c.round = options.round or 0
  c.time = options.time or 0
  c.is_paused = options.is_paused or false
  c.game_over = false
  c.win = false
  c.event_pool = options.event_pool or {}
  c.waiting_for_event_pool = options.waiting_for_event_pool or {}
  c.rounds_without_event = 0
  c.current_emissions_high_level = 0
  c.hardcore_mode = options.hardcore_mode or false

  -- Drag State
  c.drag = {
    active = false,
    pending_entity = nil,
    pending_x = 0,
    pending_y = 0,
    entity_id = nil,
    offset_x = 0,
    offset_y = 0,
    source_sector = nil,
    source_slot = nil,
    target_sector = nil,
    target_slot = nil,
    target_entity_id = nil,
    original_x = 0,
    original_y = 0
  }
end)

return GameState
