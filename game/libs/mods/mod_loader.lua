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

function modLoader.scanMods()
  modLoader.mods = {}
  local modsDir = "mods"

  if not isDir(modsDir) then
    return
  end

  local entries = love.filesystem.getDirectoryItems(modsDir)
  for _, entry in ipairs(entries) do
    local modPath = modsDir .. "/" .. entry
    if isDir(modPath) then
      local manifestPath = modPath .. "/modinfo.lua"
      if isFile(manifestPath) then
        local success, modInfo = pcall(function()
          return love.filesystem.load(manifestPath)()
        end)

        if success and modInfo then
          modInfo.path = modPath
          modInfo.name = entry
          modLoader.mods[entry] = modInfo
        end
      end
    end
  end
end

function modLoader.loadMod(modName)
  local modInfo = modLoader.mods[modName]
  if not modInfo then return nil end
  if modInfo.loaded then return modInfo.module end

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

function modLoader.getMods()
  return modLoader.mods
end

function modLoader.setEnabled(modName, enabled)
  local modInfo = modLoader.mods[modName]
  if not modInfo then return false, "Mod not found" end

  modInfo.enabled = enabled

  -- Persist to modinfo.lua
  local manifestPath = modInfo.path .. "/modinfo.lua"
  local content = "return {\n"
  for k, v in pairs(modInfo) do
    if k ~= "path" and k ~= "name" and k ~= "module" and k ~= "loaded" then
      if type(v) == "string" then
        content = content .. string.format("  %s = %q,\n", k, v)
      elseif type(v) == "boolean" then
        content = content .. string.format("  %s = %s,\n", k, tostring(v))
      elseif type(v) == "table" then
        -- Simple table serialization for dependencies
        content = content .. string.format("  %s = {},\n", k)
      end
    end
  end
  content = content .. "}\n"

  local success, err = love.filesystem.write(manifestPath, content)
  if not success then
    return false, "Failed to write modinfo.lua: " .. tostring(err)
  end

  return true
end

return modLoader
