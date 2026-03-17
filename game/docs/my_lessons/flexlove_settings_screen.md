# Lessons Learned: FlexLove Settings Screen Implementation

## FlexLove UI Components
- **No Pre-built Complex Components**: FlexLove does not provide ready-to-use sliders, dropdowns, or toggles. All UI elements must be built from the basic `Element` type.
- **Retained Mode**: By default, FlexLove uses retained mode where elements are created once and persist. This is efficient for static layouts but requires manual updates to properties (like `text` or `backgroundColor`) to reflect state changes.
- **Event Handling**: Use `onEvent` to handle interactions. Common types are `hover`, `press`, `release`, `drag`, and `mousemoved`.
- **Z-Index**: Use `zIndex` to ensure overlays (like confirmation dialogs) appear on top of other elements.

## Scene Management with Roomy
- **Global Scope**: For scenes to easily navigate to each other (e.g., `mainMenu` to `settings`), it is often simpler to define the scene manager and scene objects as global variables in `main.lua`.
- **Hooking**: `manager:hook()` automatically hooks into LÖVE's callbacks (`draw`, `update`, `keypressed`, etc.).

## Graphic Settings Logic
- **love.window.setMode**: Use this function to apply resolution, fullscreen, vsync, and msaa changes.
- **Confirmation Timer**: A standard AAA-game pattern is to show a revert timer when changing video settings. If the user doesn't confirm, call `love.window.setMode` again with the old settings.
- **Fullscreen Modes**: `love.window.getFullscreenModes()` provides a list of supported resolutions for the current display.

## Input Optimization
- **Unified Navigation**: Implement keyboard/controller navigation by tracking a `selectedIndex` and updating visual states of elements in `update()` or `keypressed()`.
- **Mouse & Touch**: Use `hover` and `release` events to make the UI feel responsive on touch and mouse devices.

## Graphics & Windowing
- **Resolution Scaling**: When changing `love.window.setMode`, call `FlexLove.resize()` and then immediately call a function to rebuild the UI (e.g., `self:rebuildUI()`). This forces FlexLove to recalculate all absolute positions from scratch, fixing alignment issues that might persist in retained mode.
- **Modal Navigation**: When a modal overlay is active, redirect keyboard input to a separate `modalIndex` and prevent interaction with the underlying settings UI.

## Mouse Interaction
- **Click Targets & Themes**: To ensure child elements like arrows are clickable and provide visual feedback, use `themeComponent = "buttonv2"`. This gives the element a proper hit area and state-based styling (hover/pressed) according to the theme.
- **Event Consumption**: When a child element (like a slider arrow) needs to handle a click exclusively, its `onEvent` handler should return `true` to "consume" the event and prevent it from triggering parent behaviors (like row selection logic).
- **Z-Index**: Use `zIndex` (e.g., `zIndex = 10`) for interactive child elements to ensure they stay on top of their parent's background and correctly capture mouse events.

## Common Pitfalls
- **Scene Lifecycle**: When using retained mode with Roomy, ensure all UI-related tables (like `self.menuButtons`) are properly initialized in `enter()` to avoid "attempt to index nil" errors when returning to a scene.
