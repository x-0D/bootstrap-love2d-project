# Camera System Updates Lesson

## Context
The BeeCarbonize mod required updates to its camera system to improve user experience. Specifically, the panning was changed from right-click to left-click, and mouse wheel support was added for zooming.

## Implementation Details

### 1. Panning Update
In `BeeCarbonizeSystem.lua`, the `update` function was modified to check for `love.mouse.isDown(1)` (left click) instead of `love.mouse.isDown(2)` (right click).

### 2. Zooming Update
Zooming was previously only possible via keyboard shortcuts (+/- or E/Q). To support the mouse wheel:
- The `gameplay_screen.lua` scene was updated to emit a `wheelmoved` event to the Concord world.
- `BeeCarbonizeSystem.lua` was updated with a `wheelmoved` callback that calls `adjust_zoom(y * 0.1)`.

### 3. HUD Feedback
The HUD text in `BeeCarbonizeSystem:draw()` was updated to reflect the new controls:
- "HUD • Left-click drag or WASD/Arrows to pan • Wheel or +/- to zoom"

### 4. Zoom Origin to Screen Center
To ensure the camera zooms into the center of the screen rather than the top-left corner:
- The transformation in `draw()` was updated to:
  1. Translate to screen center.
  2. Apply scale.
  3. Translate back by the center offset.
  4. Apply camera position (as a screen-space offset).
- The `screenToTable` helper was updated to invert this transformation correctly.

### 5. Dynamic Panning Bounds
To ensure the table layer always stays partially visible (at least crossing the screen center):
- The `set_target` function was updated to calculate dynamic bounds based on the current `target_zoom`, screen dimensions, and depth offset.
- The bounds are:
  - `min_x = -cx * zoom - depth.x`
  - `max_x = cx * zoom - depth.x`
  - `min_y = -cy * zoom - depth.y`
  - `max_y = cy * zoom - depth.y`
- These bounds ensure that the screen center $(cx, cy)$ always remains within the boundaries of the transformed table layer.
- Clamping is automatically applied whenever the zoom level or screen size changes.

### 6. Bottom-Expanding Perspective (No Overscan)
To create a "Game Table" effect that is visually stable and interactive without clipping or distortion:
- A trapezoidal perspective shader was implemented that expands the bottom of the view rather than narrowing the top.
- This approach ensures that everything rendered to the screen-sized `tableCanvas` remains visible on screen.
- The `screenToTable` helper applies the inverse mapping to ensure mouse events remain aligned.

## Lessons Learned
- **Visual Stability vs Realism**: In a 2D game, a simpler trapezoidal distortion often feels more natural and less "broken" than a full 3D perspective projection, which can introduce non-linear deformations that clash with 2D assets.
- **Overscan vs Projection Origin**: While overscan can prevent clipping when narrowing the top of a view, it introduces complexity in drawing and mapping. Choosing a projection origin that doesn't push pixels off-screen (like expanding the bottom) is often a cleaner solution for 2D perspective.
- **Inverse Mapping Consistency**: When using non-linear shaders for UI, the inverse mapping in CPU-side code (for mouse events) must be mathematically identical to ensure the UI remains interactive.
- **Coordinate Transformations**: Zooming from a specific origin $(ox, oy)$ requires a transformation sequence: $T(ox, oy) \cdot S(z) \cdot T(-ox, -oy)$.
- **Screen-Space vs World-Space Offsets**: Keeping camera translation outside the scale allows for consistent dragging speed regardless of zoom level.
- **Dynamic Clamping**: Panning bounds in a zoomable world are not constant; they must be recalculated based on the current scale to maintain a consistent visual constraint.
- **Event Propagation**: In a Concord-based ECS, events from LÖVE (like `wheelmoved`) must be explicitly emitted from the scene/world to be handled by systems.
- **Coordinate Mapping**: When using FlexLove in a world-space pipeline (like the Table Pipeline in this mod), it's useful to temporarily override `love.mouse.getPosition` to map screen coordinates to world coordinates for proper UI interaction.
- **HUD Consistency**: Always ensure that UI text and instructions are updated when changing input schemes.
