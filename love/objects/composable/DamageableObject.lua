require("oo.lua")
require("objects/composable/SimplePhysicsObject.lua")
require("objects/composable/Explosion.lua")

DamageableObject = {

  armor = 1,

  prepareAttribute = function(d,hp, damageSound, deathSound, pointsForDestroying)
    local result = {attributes = {}}
    result.attributes[DamageableObject] = true
    
    result.damage = DamageableObject.damage
    result.maxArmor = hp
    result.armor = hp
    result.damageSound = damageSound
    result.deathSound = deathSound
    result.points = pointsForDestroying
    return result
  end,
  
  damage = function(self, amount)
    if not self.dead then
      self.armor = self.armor - amount
      if self.armor > 0 then 
        if self.damageSound ~= nil then love.audio.play(self.damageSound) end
      else
        local explosion 
        if self.class == HornetEgg then
          explosion = EggExplosion:create(self.x,self.y,120,3.0)
        else
          explosion = FireyExplosion:create(self.x,self.y,60,1.0)
        end
        L:addObject(explosion)
        love.audio.play(self.deathSound)
        state.game.score = state.game.score + self.points
        self.dead = true
      end
    end
  end
  
}
