# Implementing Card Grid and Custom Card Components in FlexLove

When building card-based UIs like in Beecarbonize, using a structured Grid layout combined with Slots provides a robust foundation for future features like Drag'n'Drop.

## Key Learnings

### 1. Grid Positioning
FlexLove supports `positioning = "grid"`. To use it effectively:
- Define `gridColumns` and `gridRows`.
- Use `columnGap` and `rowGap` for spacing between cells.
- Set `alignItems = "start"` or `"center"` if you want children to maintain their size instead of stretching to fill the cell.

### 2. Slot Pattern
Using a "Slot" element as a container for "Card" elements allows for a clear separation of layout (the slot) and the content (the card).
- The Slot can have a background (e.g., `themeComponent = "framev2"`) to indicate an empty or occupied space.
- The Card is a child of the Slot, usually with its own padding and styling.

### 3. Card Dimensions
For the Beecarbonize mod, the following dimensions were used:
- `CARD_W = 90`
- `CARD_H = 120`
- This fits well in a 2-column grid within a 280px wide sector (accounting for padding and gaps).

### 4. Implementation Example
```lua
local function renderCardGrid(parent, cards, onCardClick)
  local grid = FlexLove.new({
    parent = parent,
    width = "100%",
    positioning = "grid",
    gridColumns = 2,
    columnGap = 15,
    rowGap = 15,
    alignItems = "start"
  })

  for i = 1, 8 do -- Create 8 slots (4 rows of 2)
    local slot = FlexLove.new({
      parent = grid,
      width = 90,
      height = 120,
      padding = 0, -- Ensure the card fills the slot perfectly
      themeComponent = "framev4" -- Use a distinct slot theme
    })
    
    local cardEntity = cards[i]
    if cardEntity then
      renderCard(slot, cardEntity, onCardClick)
    end
  end
end
```

### 6. Empty Slots as Drop Targets
By pre-filling the `CardGrid` with a fixed number of slots, we ensure there is always a visual "drop zone" for cards. These empty slots (`framev2` without a `Card` child) will be used to handle drag-and-drop logic in the future.

### 5. Immediate Mode Considerations
In immediate mode (used by Beecarbonize), UI helper functions should be stateless and called every frame within `FlexLove.beginFrame()` and `FlexLove.endFrame()`.
