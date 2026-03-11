# FlexLove Input Handling

## Core Rule

FlexLove **automatically** handles input. You must **NOT** manually hook FlexLove input functions to LÖVE callbacks.

## Automatic Input Handling

FlexLove implicitly hooks to LÖVE callbacks for all input types:

- `FlexLove.keypressed(key, scancode, isrepeat)` → `love.keypressed()`
- `FlexLove.textinput(text)` → `love.textinput()`
- `FlexLove.wheelmoved(x, y)` → `love.wheelmoved()`
- `FlexLove.mousepressed(x, y, button, istouch)` → `love.mousepressed()`
- `FlexLove.mousereleased(x, y, button, istouch)` → `love.mousereleased()`
- `FlexLove.mousemoved(x, y, dx, dy, istouch)` → `love.mousemoved()`
- `FlexLove.touchpressed(id, x, y, dx, dy)` → `love.touchpressed()`
- `FlexLove.touchreleased(id, x, y, dx, dy)` → `love.touchreleased()`
- `FlexLove.touchmoved(id, x, y, dx, dy)` → `love.touchmoved()`

## Supported Input Types

### Keyboard
- Text selection
- Cursor movement
- Performance HUD
- Text entry in input fields

### Mouse
- Click/hover interactions
- Button presses and releases
- Wheel scrolling

### Touch
- Touch events for mobile devices
- Touch ownership assignment

### Gamepad
- **NOT supported natively** by FlexLove
- Must implement manual gamepad handling via LÖVE joystick functions

## Correct Pattern

```lua
-- NO manual hooking needed!
-- FlexLove automatically handles all input
```

## Manual Gamepad Implementation

Since FlexLove lacks native gamepad support, implement manual handling:

```lua
function love.joystickpressed(joystick, button)
  -- Implement gamepad navigation logic
  -- Route to your UI elements manually
end

function love.joystickaxis(joystick, axis, value)
  -- Implement gamepad axis handling
end
```

## Common Mistakes

1. **Manually hooking FlexLove input functions**: This is prohibited and breaks automatic handling
2. **Forgetting to implement gamepad manually**: FlexLove does not support gamepad natively
3. **Using non-existent FlexLove.gamepad* functions**: These do not exist in FlexLove

## Integration with Roomy

Roomy scenes do not handle input automatically. You must implement gamepad handling manually in your scene's LÖVE callbacks.

## Related Lessons

- [FlexLove Drawing Pattern](flexlove_drawing_pattern.md) - UI must be drawn inside FlexLove.draw()
- [FlexLove Roomy Integration](flexlove_roomy_integration.md) - Scene integration patterns
- [Roomy Setup](roomy_setup.md) - Scene management basics
