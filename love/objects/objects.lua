require("util/geom.lua")
require("objects/goodies/WarpCrystal.lua")
require("objects/goodies/WarpPortal.lua")
require("objects/goodies/EnergyPowerup.lua")
require("objects/goodies/MaxEnergyPowerup.lua")
require("objects/goodies/TeleportPowerup.lua")
require("objects/goodies/BoosterPowerup.lua")
require("objects/SimpleBullet.lua")
require("objects/composable/DamageableObject.lua")
require("objects/composable/Thruster.lua")
require("objects/Ship.lua")
require("objects/enemies/Hornet.lua")
require("objects/enemies/Eel.lua")
require("objects/enemies/HornetEgg.lua")
require("objects/enemies/Leech.lua")
require("objects/enemies/Grasshopper.lua")

objects = {
  
  getStartingSpot = function(obs, node)
    return WarpPortal:create(node)
  end,
  
  getWarpCrystal = function(obs, node)
    return WarpCrystal:create(node)
  end,

  getEnemy = function(obs, node, difficulty)
    local r = math.random()
    if r<0.375 then return Hornet:create(node.x, node.y, difficulty) end 
    if r<0.5 then return HornetEgg:create(node.x, node.y, difficulty) end
    return Eel:create(node.x,node.y, difficulty)
  end,

  getCreature = function(obs, node, difficulty)
    return Grasshopper:create(node.x + 0.1, node.y, difficulty)
  end,

  getPowerup = function(obs,node)
    local r = math.random()
    if r<0.05 then return TeleportPowerup:create(node) end
    if r<0.15 then return BoosterPowerup:create(node) end
    if r<0.3 then return MaxEnergyPowerup:create(node) end
    return EnergyPowerup:create(node)
  end,
  
}
