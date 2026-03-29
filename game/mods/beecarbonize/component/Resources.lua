local concord = require("libs.concord")

local Resources = concord.component("beecarbonize.resources", function(c, options)
  c.production = options.production or 0
  c.people = options.people or 0
  c.science = options.science or 0
  c.emissions = options.emissions or 0
  c.max_emissions = options.max_emissions or 3000
end)

return Resources
