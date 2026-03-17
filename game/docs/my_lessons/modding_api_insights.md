# Modding API with Concord ECS Layers

In this project, we implemented a modding API that treats each mod as a **Concord ECS Layer**. This allows mods to be loaded as mixins to modify gameplay logic.

## Key Concepts

### 1. Concord ECS Layer
A Layer is a structured table that a mod returns (or defines). It can include:
- **components**: New component definitions to be registered in the world.
- **systems**: New system classes to be added to the world.
- **mixins**: Logic to modify existing system methods.
- **init**: An initialization function called when the layer is loaded.

### 2. Mixins
Mixins allow mods to intercept or replace methods in existing systems. The Mod API wraps original methods, providing a way for mods to execute code before, after, or instead of the original logic.

Example of a mixin:
```lua
mod.mixins = {
  [api.RenderSystem] = {
    draw = function(original, self)
      -- Custom pre-draw logic
      original(self) -- Call original draw
      -- Custom post-draw logic
    end
  }
}
```

### 3. Mod API
The `mod_api.lua` provides a bridge between mods and the game engine. It exposes:
- The Concord World.
- Game State.
- Scene management.
- Helper functions for registering layers, components, and systems.

## Implementation Details

- **Early Registration**: Components must be registered before systems that use them are defined.
- **LÖVE Version Compatibility**: Used `love.filesystem.getInfo` instead of deprecated `isDir`/`isFile`.
- **Global Scope Management**: Ensured that the testing framework (`cute`) and the Mod API correctly share state by being careful with `require` paths.

## Best Practices for Modders
- Use the provided `api` object instead of requiring core libraries directly where possible.
- Return a table that matches the `Layer` structure.
- Use `api.log` for debugging to keep logs consistent.
