local concord = require("libs.concord")

return concord.component("example.component.rotation", function(self, data)
  self.angle = (data and data.angle) or 0
  self.speed = (data and data.speed) or 0
end)
