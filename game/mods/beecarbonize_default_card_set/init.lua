local M = {}

M.ecosystem = {}
M.energy = {}
M.industry = {}
M.social = {}
M.science = {}
M.event = {}
M.sectors = {}

local function loadDir(dir, target)
  local entries = love.filesystem.getDirectoryItems(dir)
  for _, entry in ipairs(entries) do
    if entry:match("%.lua$") then
      local name = entry:gsub("%.lua$", "")
      local filePath = dir .. "/" .. entry
      local chunk, err = love.filesystem.load(filePath)
      if chunk then
        local success, data = pcall(chunk)
        if success then
          target[name] = data
        else
          print(string.format("[CardSet] Error executing %s: %s", filePath, data))
        end
      else
        print(string.format("[CardSet] Error loading %s: %s", filePath, err))
      end
    end
  end
end

function M.initialize()
  print("[CardSet] Initializing card data...")
  M.ecosystem = {}
  M.industry = {}
  M.people = {}
  M.science = {}
  M.event = {}
  M.sectors = {}

  loadDir("mods/beecarbonize_default_card_set/ecosystem", M.ecosystem)
  loadDir("mods/beecarbonize_default_card_set/industry", M.industry)
  loadDir("mods/beecarbonize_default_card_set/people", M.people)
  loadDir("mods/beecarbonize_default_card_set/science", M.science)
  loadDir("mods/beecarbonize_default_card_set/event", M.event)
  loadDir("mods/beecarbonize_default_card_set/sectors", M.sectors)
end

M.initialize()

return M
