love.filesystem.require("util/geom.lua")
love.filesystem.require("objects/goodies/WarpCrystal.lua")
love.filesystem.require("objects/goodies/WarpPortal.lua")
love.filesystem.require("objects/goodies/ArmorPowerup.lua")
love.filesystem.require("objects/goodies/MaxArmorPowerup.lua")
love.filesystem.require("objects/goodies/TeleportPowerup.lua")
love.filesystem.require("objects/goodies/BoosterPowerup.lua")
love.filesystem.require("objects/goodies/HomingMissilePowerup.lua")
love.filesystem.require("objects/goodies/ProximityMinePowerup.lua")
love.filesystem.require("objects/goodies/MineralChunk.lua")
love.filesystem.require("objects/goodies/EnergyChunk.lua")
love.filesystem.require("objects/composable/Resource.lua")
love.filesystem.require("objects/composable/Powerup.lua")
love.filesystem.require("objects/SimpleBullet.lua")
love.filesystem.require("objects/composable/DamageableObject.lua")
love.filesystem.require("objects/composable/Thruster.lua")
love.filesystem.require("objects/Ship.lua")
love.filesystem.require("objects/enemies/Hornet.lua")
love.filesystem.require("objects/enemies/Eel.lua")
love.filesystem.require("objects/enemies/HornetEgg.lua")
love.filesystem.require("objects/enemies/Leech.lua")
love.filesystem.require("objects/enemies/Grasshopper.lua")
love.filesystem.require("objects/enemies/Turret.lua")
love.filesystem.require("objects/enemies/Bomber.lua")
love.filesystem.require("objects/composable/Trigger.lua")
love.filesystem.require("objects/BoomOperator.lua")

local dist = 32

objects = {

  loadCollisions = function()
    return {
      -- Dead objects
      {
        function(a) return a == nil or a.dead end,
        function(b) return true end,
        function(a,b) end
      },

      -- Projectiles and explosions
      {
        function(a) return kindOf(a,Projectile) end,
        function(b) return kindOf(b,DamageableObject) end,
        function(projectile, damageable) projectile:touchDamageable(damageable) end
      },
      {
        function(a) return isA(a,ProximityMine) end,
        function(b) return b ~= nil end,
        function(prox, thing) prox:explode(thing) end
      },
      {
        function(a) return kindOf(a,Projectile) end,
        function(b) return b ~= nil end,
        function(projectile, whatever, c) 
          local x,y = c:getPosition()
          projectile:touchOther(x,y)
        end
      },

      -- Hornets and eels
      {
        function(a) return a == L.physics end,
        function(b) return isA(b, Hornet) end,
        function(wall, hornet) hornet:collided() end
      },
      {
        function(a) return isA(a, Eel) end,
        function(b) return isA(b, Ship) end,
        function(eel, ship, c)
          local x,y = c:getPosition()
          L:addObject(ZapExplosion:create(x,y,40,1.5,eel.fillColor))
          eel:shock(ship)
        end
      },

      { -- Grasshopper hops off damageable stuff
        function(a) return isA(a,Grasshopper) end,
        function(b) return kindOf(b,DamageableObject) end,
        function(hopper, thing, c) local x,y = c:getPosition(); hopper:jumpOff(thing, {x,y}) end
      },
      { -- Hop off of solid things
        function(a) return isA(a,Grasshopper) end,
        function(b) return b == L.physics or kindOf(b,Resource) or kindOf(b,Powerup) end,
        function(hopper, solid, c) local x,y = c:getPosition(); hopper.touchedSolid = {x,y} end
      },

      -- Generic collection
      {
        function(x) return kindOf(x, CollectibleObject) end, 
        function(x) return kindOf(x, CollectorObject) end, 
        function(collectible, hobo)
          if collectible.dead or hobo.dead then return end
          if hobo:inventoryAdd(collectible) then
            collectible:collected(hobo)
          end
        end
      },

      -- VICTORY
      {
        function(maybePortal) return isA(maybePortal, WarpPortal) end,
        function(maybeShip) return isA(maybeShip, Ship) and maybeShip.hasCrystal end,
        function(portal, ship) love.audio.play(portal.sound); state.current = state.victory end
      }
    }
  end,

  
  
  
  getStartingSpot = function(obs, node)
    return WarpPortal:create(node)
  end,
  
  getWarpCrystal = function(obs, node)
    return WarpCrystal:create(node)
  end,

}


