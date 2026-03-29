# UI Layout Adjustments in Beecarbonize Mod

When adjusting UI elements that use both absolute and flex positioning in FlexLove:

1.  **Coordinate Systems**: Absolute elements (like the emissions bar and resource coins in `UISystem.lua`) use fixed `x` and `y` coordinates. Flex containers (like the `board` for sectors) use padding and flex properties.
2.  **Overlap Prevention**: To avoid overlap between absolute elements at the top and a flex container below them:
    *   Reduce the `y` coordinates of absolute elements.
    *   Increase the `paddingTop` of the flex container.
3.  **Relative Heights**: When adding top padding to a container with `height = "100%"`, consider reducing the percentage height of its children (e.g., from `85%` to `75%`) to prevent them from clipping at the bottom of the screen.
4.  **Z-Index**: While `z-index` handles visual layering, spatial separation (adjusting `y` and `paddingTop`) is necessary for better user experience and clarity.
