# Roomy Scene Management Setup

## Initialization Pattern

Roomy requires three main steps in main.lua:

1. **Require the library**: `local roomy = require("libs.roomy")`
2. **Create manager instance**: `local manager = roomy.new()`
3. **Hook LÖVE callbacks**: `manager:hook()` in love.load()
4. **Enter initial scene**: `manager:enter(initialScene)` in love.load()

## Scene Structure

Scenes are simple Lua tables with methods:
- LÖVE callbacks: `update`, `draw`, `keypressed`, etc.
- Lifecycle callbacks: `enter`, `leave`, `pause`, `resume`

Each scene should return itself at the end of the file.

## Integration with Existing Code

Roomy hooks wrap existing LÖVE callbacks, so they still work. The hook calls the original callback first, then emits to the active scene.

## Key Points

- Manager maintains scene stack with `_scenes[#_scenes]` as active scene
- `enter()` replaces current scene
- `push()` adds overlay scene
- `pop()` removes overlay scene
- All LÖVE callbacks are automatically routed to active scene
- FlexLove automatically handles keyboard, mouse, and touch input. You must NOT manually hook FlexLove input functions to LÖVE callbacks.

## Input Handling

When using FlexLove with Roomy scenes:

- **Keyboard, Mouse, Touch**: Automatically handled by FlexLove - no manual hooking needed
- **Gamepad**: NOT supported natively by FlexLove - implement manual handling via LÖVE joystick functions in your scene

## Related Lessons

- **[FlexLove Drawing Pattern](flexlove_drawing_pattern.md)**: Critical lesson about FlexLove UI must be drawn inside FlexLove.draw() anonymous function
- **[FlexLove and Roomy Integration](flexlove_roomy_integration.md)**: Complete guide to integrating FlexLove with Roomy scene management
- **[FlexLove Input Handling](flexlove_input_handling.md)**: Automatic input handling rules and gamepad implementation
