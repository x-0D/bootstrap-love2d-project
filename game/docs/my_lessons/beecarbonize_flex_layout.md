# Beecarbonize Layout and 3D Shader Conflicts

When implementing UI layouts in Beecarbonize, it is crucial to account for the **fake 3D perspective shader** applied to the table layer.

## Key Takeaways

- **Avoid `flex = 1` on Shaded Layers**: Elements on the `Table` layer (priority 20) are drawn into a canvas that is later transformed by a perspective shader. Using `flex = 1` can cause elements to expand in ways that conflict with the shader's coordinate mapping, especially for mouse interaction.
- **Fixed Dimensions for Stability**: For the board's sectors, prefer fixed `width` (e.g., `280px`) and `height` percentages (e.g., `85%`) to maintain a stable layout that matches the perspective.
- **Mouse Coordinate Mapping**: The `screenToTable` function in `UISystem.lua` must match the shader's transformation. In this project, there's a discrepancy between the legacy `TILT_FACTOR` logic and the real 3D shader in `CanvasLayerSystem.lua`.
- **Gaps over Margins**: Use the `gap` property for consistent spacing between sectors and cards. It's cleaner and works well with flex containers.
- **HUD Layer Safety**: Elements on the `HUD` layer (priority 100) are drawn directly to the screen and are not affected by the perspective shader. You can safely use more complex flex layouts and overlays here.

## Example Pattern (Safe for 3D Layer)

```lua
local board = FlexLove.new({
  width = "100%", height = "100%", positioning = "flex",
  flexDirection = "row", justifyContent = "center", gap = 20
})

for _, sector in ipairs(sectors) do
  local sUI = FlexLove.new({
    parent = board, width = 280, height = "85%",
    flexDirection = "column", gap = 12, padding = 10
  })
  -- ... children ...
end
```
