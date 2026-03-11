# FlexLove and Roomy Integration

## Overview

FlexLove is a UI library for LÖVE Framework based on flexbox, while Roomy is a scene management library that organizes game code into distinct "scenes" like title screens or gameplay. This document explains how to integrate these two libraries for creating a modern, flexible game interface.

## Roomy Scene Management

Roomy uses a stack-based approach to manage game scenes:

- **Scene Definition**: Each scene is a Lua table with methods corresponding to LÖVE callbacks (update, draw, keypressed) and Roomy lifecycle events (enter, leave, pause, resume)
- **Manager Initialization**: Create a Manager object using `roomy.new()` to maintain a stack of active scenes
- **Hooking LÖVE Callbacks**: Use `manager:hook()` to integrate Roomy with LÖVE by wrapping global callbacks
- **Scene Transitions**:
  - `manager:enter(scene, ...)`: Replaces the current scene with a new one
  - `manager:push(scene, ...)`: Adds a new scene on top as an overlay
  - `manager:pop(...)`: Removes the top scene, returning to the previous one

## FlexLove UI Components

FlexLove provides a comprehensive UI system with:

- **Root Container**: Start with a root `FlexLove.new()` element that spans the entire screen
- **Flexbox Layout**: Use properties like `flexDirection`, `justifyContent`, `alignItems`, `gap`, and `padding` to control element positioning
- **Interactive Elements**: Create buttons, text, containers with event handling via `onEvent` callbacks
- **Theming**: Use built-in themes like "space" or "metal" for consistent styling
- **Immediate Mode Rendering**: Control rendering with `beginFrame()` and `endFrame()` calls

## Integration Pattern

### 1. Scene Lifecycle with FlexLove

When a scene enters, initialize FlexLove. When it leaves, clean up:

```lua
function scene:enter(previous, ...)
  FlexLove.init({
    theme = "space",
    immediateMode = false,
    autoFrameManagement = true
  })
end

function scene:leave(next, ...)
  FlexLove.destroy()
end
```

### 2. Drawing FlexLove UI

**CRITICAL**: FlexLove UI MUST be drawn inside FlexLove.draw() anonymous function. All UI elements must be created within the anonymous function.

```lua
function scene:draw()
  FlexLove.draw(function()
    -- Create root container
    local root = FlexLove.new({
      width = "100%",
      height = "100%",
      backgroundColor = Color.new(0.05, 0.05, 0.08, 1),
      positioning = "flex",
      flexDirection = "column",
      justifyContent = "center",
      alignItems = "center"
    })

    -- Create UI elements with parent-child relationships
    local title = FlexLove.new({
      parent = root,
      text = "Game Title",
      textSize = "3xl",
      textColor = Color.new(0.3, 0.8, 1, 1)
    })

    -- Create more UI elements...
  end)
end
```

### 3. Event Handling

**CRITICAL**: FlexLove automatically handles keyboard, mouse, and touch input. You must NOT manually hook FlexLove input functions to LÖVE callbacks.

Keyboard navigation and button clicks work automatically:

```lua
-- NO manual hooking needed!
-- FlexLove automatically handles all input
```

Button event handling:

```lua
button.onEvent = function(event)
  if event.type == "release" then
    self:handleMenuAction(action)
  end
end
```

### 4. Scene Transitions

Navigate between scenes using Roomy's manager:

```lua
function scene:handleMenuAction(action)
  local nextScene = nil
  
  if action == "start" then
    nextScene = gameplayScene
  elseif action == "quit" then
    love.event.quit()
  end
  
  if nextScene then
    manager:enter(nextScene)
  end
end
```

## Main Menu Example

A complete main menu implementation includes:

- Title element with centered text
- Menu container with vertical flex layout
- Dynamic menu buttons with hover and selection states
- Keyboard navigation (up/down arrows) - handled automatically by FlexLove
- Enter key to select - handled automatically by FlexLove
- Scene transitions to different game screens

**CRITICAL**: All FlexLove UI elements must be created inside the FlexLove.draw() anonymous function.

```lua
function scene:draw()
  FlexLove.draw(function()
    local root = FlexLove.new({
      width = "100%",
      height = "100%",
      backgroundColor = Color.new(0.05, 0.05, 0.08, 1),
      positioning = "flex",
      flexDirection = "column",
      justifyContent = "center",
      alignItems = "center",
      padding = { horizontal = 40, vertical = 40 }
    })

    local title = FlexLove.new({
      parent = root,
      width = 600,
      height = 80,
      backgroundColor = Color.new(0.15, 0.15, 0.25, 1),
      borderRadius = 10,
      text = "Bootstrap Love2D",
      textSize = "3xl",
      textColor = Color.new(0.3, 0.8, 1, 1),
      justifyContent = "center",
      alignItems = "center"
    })

    local menuContainer = FlexLove.new({
      parent = root,
      width = 500,
      height = "100%",
      positioning = "flex",
      flexDirection = "column",
      gap = 10,
      padding = { vertical = 20, horizontal = 20 }
    })

    for i, option in ipairs(menuOptions) do
      local isSelected = i == selectedIndex
      local isHovered = i == hoveredIndex

      local button = FlexLove.new({
        parent = menuContainer,
        width = "90%",
        margin = { left = "5%" },
        height = 50,
        backgroundColor = isSelected and Color.new(0.2, 0.4, 0.8, 1)
          or isHovered and Color.new(0.2, 0.2, 0.35, 1)
          or Color.new(0.1, 0.1, 0.15, 1),
        borderRadius = 8,
        justifyContent = "center",
        alignItems = "center",
        themeComponent = "buttonv2"
      })

      local buttonText = FlexLove.new({
        parent = button,
        text = option.label,
        textSize = "xl",
        textColor = isSelected and Color.new(1, 1, 1, 1)
          or Color.new(0.8, 0.9, 1, 1)
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

## Best Practices

1. **Module Loading**: Use `require("libs.FlexLove")` instead of `require("FlexLove")` to ensure proper module path resolution
2. **Theme Selection**: Choose appropriate themes for your game's visual style
3. **State Management**: Track selection state and handle transitions cleanly
4. **Cleanup**: Always call `FlexLove.destroy()` when leaving a scene to free resources
5. **Event Handling**: Implement button event handling via `onEvent` callbacks
6. **CRITICAL - Drawing Pattern**: All FlexLove UI elements MUST be created inside the FlexLove.draw() anonymous function. Never create UI elements outside of this function.
7. **CRITICAL - Input Handling**: FlexLove automatically handles keyboard, mouse, and touch input. You must NOT manually hook FlexLove input functions to LÖVE callbacks.

## Key Components

- **FlexLove.init()**: Initialize the UI library with theme and rendering mode
- **FlexLove.new()**: Create UI elements with flexbox properties
- **FlexLove.draw()**: Render the UI hierarchy
- **FlexLove.beginFrame()/endFrame()**: Control rendering frame
- **FlexLove.Color**: Color utility for consistent theming
- **Roomy Manager**: Scene management and transitions
