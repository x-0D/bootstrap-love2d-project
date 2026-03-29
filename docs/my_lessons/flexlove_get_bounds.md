# Getting Component Bounds in FlexLove

When you need to get the absolute screen-space position and dimensions of a FlexLove component, use the `getBounds()` method.

## Key Learnings

### 1. The `getBounds()` Method
Each FlexLove element (returned by `FlexLove.new()`) has a `:getBounds()` method. It returns a table with the following fields:
- `x`: Absolute x-coordinate on the screen.
- `y`: Absolute y-coordinate on the screen.
- `width`: Total width including padding.
- `height`: Total height including padding.

### 2. Usage Example
```lua
local myComponent = FlexLove.new({
  parent = parent,
  width = 100,
  height = 50
})

-- After layout calculation (usually after FlexLove.endFrame())
-- In immediate mode, it's available as soon as it's created or in the next frame
local bounds = myComponent:getBounds()
print(bounds.x, bounds.y, bounds.width, bounds.height)
```

### 3. Why it's useful
In Beecarbonize, this is used to synchronize the ECS `Sector` and `Card` components with their UI representations, allowing the `DragSystem` to perform hit-testing and coordinate transformations accurately.
