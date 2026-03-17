local modAPI = {}

modAPI.world = nil
modAPI.gameState = nil
modAPI.scenes = nil
modAPI.concord = nil

function modAPI.initialize(world, gameState, scenes, concord)
  modAPI.world = world
  modAPI.gameState = gameState
  modAPI.scenes = scenes
  modAPI.concord = concord
end

function modAPI.getWorld()
  return modAPI.world
end

function modAPI.getGameState()
  return modAPI.gameState
end

function modAPI.getScenes()
  return modAPI.scenes
end

function modAPI.getConcord()
  return modAPI.concord
end

function modAPI.registerComponent(name, defaultData)
  if not modAPI.concord then
    error("Concord not available in mod API")
  end

  local Components = modAPI.concord.components
  if Components and Components.has(name) then
    modAPI.log(string.format("Component '%s' already registered, skipping re-register", name))
    return Components.get(name)
  end

  -- In Concord 3.0, the second argument is a populate function.
  -- We'll wrap it to support passing a table of default values.
  local populate = nil
  if type(defaultData) == "table" then
    populate = function(self, data)
      for k, v in pairs(defaultData) do
        self[k] = data and data[k] or v
      end
    end
  elseif type(defaultData) == "function" then
    populate = defaultData
  end

  return modAPI.concord.component(name, populate)
end

function modAPI.registerSystem(system)
  if not modAPI.world then
    error("World not available in mod API")
  end

  return modAPI.world:addSystem(system)
end

function modAPI.spawnEntity()
  if not modAPI.world then
    error("World not available in mod API")
  end

  return modAPI.world:newEntity()
end

function modAPI.filter(def)
  if not modAPI.world then
    error("World not available in mod API")
  end

  return modAPI.world:query(def)
end

function modAPI.getModPath()
  return "mods"
end

function modAPI.print(message)
  print("[Mod API] " .. message)
end

function modAPI.log(message, level)
  level = level or "info"
  print(string.format("[Mod %s] %s", level:upper(), message))
end

function modAPI.loadAsset(path)
  local fullPath = "mods/" .. path
  if love.filesystem.exists(fullPath) then
    return love.graphics.newImage(fullPath)
  end
  return nil
end

function modAPI.loadSound(path)
  local fullPath = "mods/" .. path
  if love.filesystem.exists(fullPath) then
    return love.audio.newSource(fullPath, "static")
  end
  return nil
end

function modAPI.loadFont(path, size)
  local fullPath = "mods/" .. path
  if love.filesystem.exists(fullPath) then
    return love.graphics.newFont(fullPath, size)
  end
  return nil
end

function modAPI.registerEvent(eventName, callback)
  if not modAPI.gameState then
    error("GameState not available in mod API")
  end

  if not modAPI.gameState.eventHandlers then
    modAPI.gameState.eventHandlers = {}
  end

  if not modAPI.gameState.eventHandlers[eventName] then
    modAPI.gameState.eventHandlers[eventName] = {}
  end

  table.insert(modAPI.gameState.eventHandlers[eventName], callback)
end

function modAPI.triggerEvent(eventName, ...)
  if not modAPI.gameState or not modAPI.gameState.eventHandlers then
    return
  end

  local handlers = modAPI.gameState.eventHandlers[eventName]
  if handlers then
    for _, handler in ipairs(handlers) do
      handler(...)
    end
  end
end

function modAPI.setGameState(key, value)
  if not modAPI.gameState then
    error("GameState not available in mod API")
  end

  modAPI.gameState[key] = value
end

function modAPI.getGameState(key)
  if not modAPI.gameState then
    error("GameState not available in mod API")
  end

  return modAPI.gameState[key]
end

function modAPI.registerScene(sceneName, scene)
  if not modAPI.scenes then
    error("Scenes not available in mod API")
  end

  modAPI.scenes[sceneName] = scene
end

function modAPI.registerLayer(layer)
  if not modAPI.world then
    error("World not available in mod API")
  end

  -- Register components
  if layer.components then
    for name, data in pairs(layer.components) do
      modAPI.registerComponent(name, data)
    end
  end

  -- Register systems
  if layer.systems then
    for _, system in ipairs(layer.systems) do
      modAPI.registerSystem(system)
    end
  end

  -- Apply mixins
  if layer.mixins then
    for systemClass, methods in pairs(layer.mixins) do
      if systemClass then
        for methodName, mixinFunc in pairs(methods) do
          local originalMethod = systemClass[methodName]
          if originalMethod then
            systemClass[methodName] = function(self, ...)
              return mixinFunc(originalMethod, self, ...)
            end
          else
            systemClass[methodName] = function(self, ...)
              return mixinFunc(nil, self, ...)
            end
          end
        end
      else
        modAPI.log("Warning: Skipping mixins for nil system class", "warn")
      end
    end
  end

  -- Call layer init if exists
  if layer.init then
    layer.init(modAPI)
  end

  return layer
end

function modAPI.switchScene(sceneName)
  if not modAPI.scenes then
    error("Scenes not available in mod API")
  end

  if modAPI.scenes[sceneName] then
    modAPI.scenes[sceneName]()
  else
    error("Scene not found: " .. sceneName)
  end
end

return modAPI
