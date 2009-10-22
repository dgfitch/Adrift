require("oo.lua")
require("objects/composable/SimplePhysicsObject.lua")

Projectile = {
  super = SimplePhysicsObject,
  
  create = function(P,bod,shp)
    local result = SimplePhysicsObject:create(bod,shp)
    mixin(result, Projectile)
    result.class = Projectile
    return result
  end
}
