local cute = require("cute")
local concord = require("libs.concord")
local modSystem = require("libs.mods")

-- Remove cute.go() from here, it's called in main.lua
-- cute.go()

notion("Mod API Layer Registration", function()
  local world = concord.world()
  local gameState = {}
  local scenes = {}

  modSystem.initialize(world, gameState, scenes, concord)

  -- Register component first so system can be defined
  modSystem.modAPI.registerComponent("test_comp", { value = 0 })

  local layer = {
    systems = {
      concord.system({ pool = { "test_comp" } })
    },
    init = function(api)
      api.log("Test layer init called")
    end
  }

  local registeredLayer = modSystem.modAPI.registerLayer(layer)
  check(registeredLayer == layer).is(true)

  -- Verify component registration
  local comp = concord.components.test_comp
  check(comp ~= nil).is(true)

  -- Verify system registration
  local hasSystem = world:hasSystem(layer.systems[1])
  check(hasSystem).is(true)
end)

notion("Mod API Mixins", function()
  local world = concord.world()
  local gameState = {}
  local scenes = {}

  modSystem.initialize(world, gameState, scenes, concord)

  local MySystem = concord.system({})
  function MySystem:testMethod()
    return "original"
  end

  local layer = {
    mixins = {
      [MySystem] = {
        testMethod = function(original, self)
          return "mixin_" .. original(self)
        end
      }
    }
  }

  modSystem.modAPI.registerLayer(layer)

  local systemInstance = MySystem(world)
  check(systemInstance:testMethod()).is("mixin_original")
end)
