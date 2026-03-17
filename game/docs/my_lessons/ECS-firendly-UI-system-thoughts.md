-- Applying transcendent knowledge to Love2D UI system:
-- ECS-friendly: 
-- your UI components are just Entity-Component-System
-- ecs/
--   ui/
--     init.lua -- init ui developer experience
--     button/
--       button_lay.lua -- main component of button
--       button_ctl.lua -- controller of button
--   components/
--     ui.lua
--   systems/
--     ui_system.lua -- system of ui

-- when ui_system called, it will call related "UI" component for all entities.
-- here is example of the entity with ui component:
-- flutter-like widget tree
require "ui"
require "ui.button"

example_ui = {
  ui = ui.Row({
    children = {
      ui.button({
        type = "button",
        label = "Start Game",
        action = function(event)
          print("start game")
        end
      }
      ),
      ui.button({
        type = "button",
        label = "Quit Game",
        action = function(event)
          print("quit game")
        end
      }),
    }
  })
}

-- row = new Row()
-- row->addChild()

-- here is example stateful counter
example_counter = {
  state = {
    count = 0
  },
  callbacks = {
    decrement = function()
      example_counter.state.count = example_counter.state.count - 1
    end,
    increment = function()
      example_counter.state.count = example_counter.state.count + 1
    end,
  },
  ui = ui.Row({
    children = {
      ui.button({
        type = "button",
        label = "-",
        action = "decrement"
      }),
      ui.Text({
        label = tostring(example_counter.state.count)
      }),
      ui.button({
        type = "button",
        label = "+",
        action = "increment"
      }),
    }
  })
}

-- when UI system process these entities, it will call related "UI" component controllers for all entities.

UISystem = {}
function UISystem:draw(dt)
  for _, entity in pairs(self.entities) do
    if entity.ui then
      entity.ui:draw(dt)
    end
  end
end
