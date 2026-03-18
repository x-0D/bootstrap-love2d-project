# Input Handling: Press vs Release for Actions

## The "Double Trigger" Bug

A common bug in UI systems occurs when both `keypressed` and `keyreleased` (or `mousepressed` and `mousereleased`) handle the same action, or when a state change in `keypressed` affects the behavior of `keyreleased` for the same physical interaction.

### The Scenario
1.  User presses **Enter** on an "Apply" button.
2.  `keypressed` is triggered, calls `applySettings()`.
3.  `applySettings()` sets `isConfirming = true` and opens a confirmation modal.
4.  User releases **Enter**.
5.  `keyreleased` is triggered. Since `isConfirming` is now `true`, it immediately calls `confirmSettings()`.
6.  The modal disappears instantly, and settings are confirmed without the user actually seeing the modal.

### The Fix
The best practice is to handle logical actions (like "Apply", "Confirm", "Back") in **only one** of the callbacks:
-   **Navigation (Up/Down/Left/Right)**: Usually handled in `keypressed` for an instant, responsive feel.
-   **Actions (Enter/Space)**: Can be handled in `keypressed` for speed, or `keyreleased` for "safety" (allowing the user to move off the button before releasing).
-   **CRITICAL**: Never handle the same action in both without a mechanism to consume the event or prevent immediate propagation.

### Recommended Pattern
Use a `pressedKeys` table to prevent key repeats, and handle the action logic exclusively in `keypressed`:

```lua
function scene:keypressed(key)
  if not self.pressedKeys[key] then
    self.pressedKeys[key] = true
    
    if self.isConfirming then
      -- Handle modal actions
      if key == "return" then self:confirm() end
      return
    end
    
    -- Handle main menu actions
    if key == "return" then self:apply() end
  end
end

function scene:keyreleased(key)
  if self.pressedKeys[key] then
    self.pressedKeys[key] = nil
  end
end
```

By removing the action logic from `keyreleased`, you ensure that a single key stroke (press + release) only triggers one logical state change.
