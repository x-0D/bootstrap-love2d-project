# FlexLove Drawing Pattern

## Critical Rule

**FlexLove UI MUST be drawn inside FlexLove.draw() anonymous function**

This is the most important pattern to understand when working with FlexLove. All FlexLove UI elements must be created and configured within the anonymous function passed to `FlexLove.draw()`.

## Why This Pattern Matters

The `FlexLove.draw()` function handles the rendering pipeline and frame management. When you create UI elements outside of this function, they won't be properly rendered or managed by FlexLove's rendering system.

## Correct Pattern

```lua
function scene:draw()
  FlexLove.draw(function()
    -- ALL FlexLove UI elements MUST be created here
    local root = FlexLove.new({
      width = "100%",
      height = "100%",
      backgroundColor = Color.new(0.05, 0.05, 0.08, 1),
      positioning = "flex",
      flexDirection = "column",
      justifyContent = "center",
      alignItems = "center"
    })

    local title = FlexLove.new({
      parent = root,
      text = "Game Title",
      textSize = "3xl",
      textColor = Color.new(0.3, 0.8, 1, 1)
    })

    local button = FlexLove.new({
      parent = root,
      text = "Start Game",
      textSize = "xl"
    })
  end)
end
```

## Common Mistakes

### ❌ WRONG: Creating UI outside FlexLove.draw()

```lua
function scene:draw()
  -- This won't work! UI elements created here won't render
  local root = FlexLove.new({
    width = "100%",
    height = "100%"
  })

  FlexLove.draw(function()
    -- This is too late, root was already created
  end)
end
```

### ❌ WRONG: Creating UI inside FlexLove.draw() but not using anonymous function

```lua
function scene:draw()
  -- This won't work! You must use an anonymous function
  FlexLove.draw(FlexLove.new({
    width = "100%",
    height = "100%"
  }))
end
```

## Integration with Roomy Scenes

When using FlexLove with Roomy scene management, the pattern remains the same:

```lua
function scene:draw()
  FlexLove.draw(function()
    -- Create entire UI hierarchy here
    local root = FlexLove.new({
      width = "100%",
      height = "100%",
      backgroundColor = Color.new(0.05, 0.05, 0.08, 1),
      positioning = "flex",
      flexDirection = "column",
      justifyContent = "center",
      alignItems = "center"
    })

    -- Create menu container
    local menuContainer = FlexLove.new({
      parent = root,
      width = 500,
      height = "100%",
      positioning = "flex",
      flexDirection = "column",
      gap = 10
    })

    -- Create menu items
    for i, option in ipairs(menuOptions) do
      local button = FlexLove.new({
        parent = menuContainer,
        text = option.label,
        textSize = "xl"
      })

      button.onEvent = function(event)
        if event.type == "release" then
          self:handleMenuAction(option.action)
        end
      end
    end
  end)
end
```

## Key Points

- **Always use anonymous function**: `FlexLove.draw(function() ... end)`
- **Create all UI elements inside**: Every `FlexLove.new()` call must be inside the anonymous function
- **No UI creation outside**: Don't create UI elements before or after the `FlexLove.draw()` call
- **One UI hierarchy per frame**: The anonymous function creates a fresh UI hierarchy each frame
- **Works with immediate mode**: This pattern works with both retained and immediate mode rendering

## Related Concepts

- **Retained Mode**: UI elements persist across frames, updated by modifying properties
- **Immediate Mode**: UI elements recreated every frame within the anonymous function
- **Roomy Integration**: Works seamlessly with Roomy scene management
- **Event Handling**: Events work the same way regardless of where UI is created
- **Input Handling**: FlexLove automatically handles keyboard, mouse, and touch input. You must NOT manually hook FlexLove input functions to LÖVE callbacks.

## Related Lessons

- [FlexLove Input Handling](flexlove_input_handling.md) - Automatic input handling rules
- [FlexLove Roomy Integration](flexlove_roomy_integration.md) - Scene integration patterns
- [Roomy Setup](roomy_setup.md) - Scene management basics
