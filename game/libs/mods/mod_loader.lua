local modLoader = {}

modLoader.mods = {}

local function isDir(path)
  local info = love.filesystem.getInfo(path)
  return info and info.type == "directory"
end

local function isFile(path)
  local info = love.filesystem.getInfo(path)
  return info and info.type == "file"
end

local function serializeTable(tbl, indent)
  indent = indent or "  "
  local content = "{\n"
  for k, v in pairs(tbl) do
    local keyStr = type(k) == "string" and k or "[" .. tostring(k) .. "]"
    if type(v) == "string" then
      content = content .. string.format("%s%s = %q,\n", indent, keyStr, v)
    elseif type(v) == "boolean" or type(v) == "number" then
      content = content .. string.format("%s%s = %s,\n", indent, keyStr, tostring(v))
    elseif type(v) == "table" then
      content = content .. string.format("%s%s = %s,\n", indent, keyStr, serializeTable(v, indent .. "  "))
    end
  end
  content = content .. indent:sub(1, -3) .. "}"
  return content
end

function modLoader.scanMods()
  local modsDir = "mods"

  if not isDir(modsDir) then
    return
  end

  local entries = love.filesystem.getDirectoryItems(modsDir)
  local foundMods = {}
  for _, entry in ipairs(entries) do
    local modPath = modsDir .. "/" .. entry
    if isDir(modPath) then
      local manifestPath = modPath .. "/modinfo.lua"
      if isFile(manifestPath) then
        local success, modInfo = pcall(function()
          -- Use load and run for safety
          local chunk = love.filesystem.load(manifestPath)
          if chunk then return chunk() end
        end)

        if success and modInfo then
          modInfo.path = modPath
          modInfo.name = entry
          -- Default to enabled if not specified
          if modInfo.enabled == nil then
            modInfo.enabled = true
          end
          foundMods[entry] = modInfo
        end
      end
    end
  end

  -- Update modLoader.mods, preserving loaded state
  local newMods = {}
  for name, info in pairs(foundMods) do
    if modLoader.mods[name] then
      info.module = modLoader.mods[name].module
      info.loaded = modLoader.mods[name].loaded
    end
    newMods[name] = info
  end
  modLoader.mods = newMods
end

function modLoader.loadMod(modName)
  local modInfo = modLoader.mods[modName]
  if not modInfo then return nil end
  if modInfo.loaded then return modInfo.module end

  -- Only load if enabled, unless it's the core mod
  if not modInfo.enabled and modName ~= "core" then
    print(string.format("[ModLoader] Skipping loading disabled mod '%s'", modName))
    return nil
  end

  local initPath = modInfo.path .. "/init.lua"
  if not isFile(initPath) then return nil end

  -- Use require for init.lua to handle modules correctly
  local requirePath = modInfo.path:gsub("/", ".") .. ".init"
  local success, modModule = pcall(require, requirePath)

  if success then
    modInfo.module = modModule
    modInfo.loaded = true
    return modModule
  end

  print(string.format("[ModLoader] Error loading mod '%s': %s", modName, modModule))
  return nil
end

function modLoader.unloadMod(modName)
  local modInfo = modLoader.mods[modName]
  if not modInfo or not modInfo.loaded then return end

  print(string.format("[ModLoader] Unloading mod '%s'...", modName))

  -- Clear all modules belonging to this mod from package.loaded
  local prefix = "mods." .. modName:gsub("/", ".")
  local keysToRemove = {}
  for k, _ in pairs(package.loaded) do
    if k == prefix or k:sub(1, #prefix + 1) == prefix .. "." then
      table.insert(keysToRemove, k)
    end
  end

  for _, k in ipairs(keysToRemove) do
    print(string.format("[ModLoader]   - Clearing package.loaded['%s']", k))
    package.loaded[k] = nil
  end

  -- Clear mod internal state
  modInfo.module = nil
  modInfo.loaded = false
end

function modLoader.getMods()
  return modLoader.mods
end

function modLoader.setEnabled(modName, enabled)
  local modInfo = modLoader.mods[modName]
  if not modInfo then return false, "Mod not found" end

  modInfo.enabled = enabled

  -- Persist to modinfo.lua
  local manifestPath = modInfo.path .. "/modinfo.lua"

  -- Ensure directory exists in save folder before writing
  love.filesystem.createDirectory(modInfo.path)

  -- Create a clean table for serialization, excluding internal fields
  local cleanInfo = {}
  for k, v in pairs(modInfo) do
    if k ~= "path" and k ~= "name" and k ~= "module" and k ~= "loaded" then
      cleanInfo[k] = v
    end
  end

  local content = "return " .. serializeTable(cleanInfo) .. "\n"

  local success, err = love.filesystem.write(manifestPath, content)
  if not success then
    return false, "Failed to write modinfo.lua: " .. tostring(err)
  end

  return true
end

return modLoader
