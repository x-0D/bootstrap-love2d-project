# Card Repulsion and Playable Area

To keep cards within the playable area in a Love2D ECS environment, we implemented a repulsion force in the `CardSystem`.

## Key Learnings

### 1. Camera Bounds vs. View Bounds
- **View Bounds**: What is currently visible on the screen. This changes as the user pans or zooms the camera.
- **Camera Bounds**: The static world limits that restrict where the camera center can move. This defines the **Playable Area**.

It is a common misconception to use view bounds for card repulsion. Using view bounds would cause cards to "stick" to the screen edges as the camera moves, which feels unnatural. Instead, cards should be repelled by the boundaries of the entire playable world.

### 2. Calculating the Playable Area
If the camera's internal offset `cam.x` is clamped between `min_x` and `max_x`, and the screen width is `W`, the total reachable world area (at `zoom = 1`) is:
- `worldMinX = min_x`
- `worldMaxX = max_x + W`

This is because the screen center is `W/2 + cam.x`. When `cam.x = min_x`, the screen left edge is `min_x`. When `cam.x = max_x`, the screen right edge is `max_x + W`.

### 3. Implementation in CardSystem
We use the camera's `bounds` property to define the limits for the cards. The repulsion force is applied to free-floating cards when they approach or exceed these absolute world limits.

```lua
local worldMinX = cam.bounds.min_x
local worldMaxX = cam.bounds.max_x + w
```

### 4. Smooth Repulsion
To avoid "hard" clamping, we use a proportional force based on the "penetration depth" into the boundary margin.
- `margin`: A small buffer area near the edge.
- `bounds_push`: A strong force to ensure cards stay within the playable area.
