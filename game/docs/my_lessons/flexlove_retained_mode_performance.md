# FlexLove Retained Mode Performance Optimization (PERF_001)

## Context
When switching from immediate mode to retained mode in FlexLove, properties of UI elements (like `text`, `width`, `height`, `opacity`, `y`, etc.) are often updated in the `update(dt)` loop to handle animations and state changes.

## Problem: PERF_001
The `PERF_001` warning ("Performance threshold exceeded") is triggered when too many layout calculations happen in a single frame. This typically occurs because:
1.  **Redundant property assignments**: Setting a property (even to the same value) every frame can trigger a layout invalidation.
2.  **Parent-child layout chain**: Updating properties of many children in a single parent (like rows in a list) triggers a layout pass for each child's update.

## Solutions and Best Practices

### 1. Mandatory Dirty Checks
Always check if a value has actually changed before assigning it to a FlexLove element property.
```lua
-- Good
if element.text ~= newText then
    element.text = newText
end

-- Bad (Triggers layout every frame)
element.text = newText
```

### 2. Batching Animations on Parents
Instead of animating properties (like `opacity`) on every child individually, apply the property to a common parent container if possible.
- **Before**: 10 rows updated individually = 10 layout passes.
- **After**: 1 parent list updated = 1 layout pass.

### 3. Optimized Event Checks
Avoid calling expensive layout-dependent checks like `element:contains(x, y)` every frame if it's not necessary.
- **Optimization**: Only check mouse hover if the mouse has actually moved since the last frame.

### 4. Precision Thresholding
For smooth animations (like selection highlights), use a small threshold to stop updates when the change is negligible.
```lua
if math.abs(newValue - current) > 0.01 then
    current = newValue
    element.y = current
end
```

### 5. String Formatting
Be careful with `string.format` in the update loop. Even if the result is the same, the assignment might trigger a layout. Always use a dirty check on the resulting string.
```lua
local newText = string.format("Time: %d", math.ceil(timer))
if label.text ~= newText then
    label.text = newText
end
```
