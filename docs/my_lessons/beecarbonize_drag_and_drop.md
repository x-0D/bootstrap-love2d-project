# Beecarbonize Card Drag'n'Drop System Behavior

This document outlines the behavior of the Card Dragging system as extracted from the original implementation.

## 1. Core Concepts
- **Sectors (Desks)**: The main play areas where cards can be placed. In the old implementation, these were referred to as "desks". There are four primary sectors: Industry, Ecosystems, People, and Science.
- **Slots**: Each sector contains a fixed number of slots (e.g., 8). Cards must be placed into these slots to be "active" within a sector.
- **Free Floating**: Cards can be dragged freely across the screen. If dropped outside a sector or a valid slot, they remain "free-floating" in world space.

## 2. Dragging Behavior
- **Pending Drag**: To prevent accidental drags, the system uses a "pending drag" state. A drag only begins if the mouse moves more than a small threshold (e.g., 5 pixels) while the button is held down.
- **World Space Logic**: All dragging calculations are performed in world coordinates. Screen-to-world conversion is essential to ensure cards align with the camera-transformed game world.
- **Z-Order**: Dragged cards are rendered on top of all other elements to ensure they are visible.

## 3. Interaction & Placement
- **Valid Targets**: Cards can only be "slotted" into the four main sectors.
- **Swapping**: If a card is dropped into an occupied slot, the system automatically swaps the positions of the dragged card and the card already in the slot.
- **Cancelling Drag**:
    - **Events Sector**: Dropping a card over the Events sector (which is read-only) is prohibited. If a card is dropped there, the drag is cancelled, and the card returns to its original position or source slot.
    - **Full Sectors**: If a sector is full (no empty slots) and no swap is possible, the card returns to its source.
- **Drag Prohibition**:
    - **Event Cards**: Event cards cannot be dragged; they are static and can only be clicked for interaction.
    - **Modals**: Dragging is disabled when any modal UI (card details, shop, settings) is open.
    - **Paused State**: No dragging is allowed when the game is paused.

## 4. Camera Interference Avoidance
The camera and dragging systems are coordinated to prevent conflicting inputs:
- **Priority**: Card dragging has priority over camera panning.
- **Check State**: Before starting a camera drag (panning), the camera system checks if a card is currently being dragged or if a drag is "pending".
- **Agreement**: Both systems use the same coordinate transformation logic to ensure consistent behavior across zoom levels and pan positions.

## 5. Visual Feedback (Juice)
- **Scale and Rotation**: Dragged cards receive a slight scale increase and a small random rotation to make them feel "lifted" off the board.
- **Snap Feedback**: When hovering over a valid slot, the card or the slot may provide visual feedback (e.g., highlighting) to indicate a valid drop target.
- **Drop Effect**: Upon releasing a card, a small juice effect (scale/rotation pulse) is applied to signify the completion of the action.
