require("oo.lua")
require("objects/composable/CollectibleObject.lua")

TeleportPowerup = {
  super = CollectibleObject,
  
  timer = 0, 
  
  images = {
    love.graphics.newImage("graphics/teleport0.png"),
    love.graphics.newImage("graphics/teleport1.png"),
    love.graphics.newImage("graphics/teleport2.png"),
    love.graphics.newImage("graphics/teleport3.png"),
  },
  
  sound = love.audio.newSound("sound/teleportCollect.ogg"),
  
  effect = function(self, collector) 
    collector.hasTeleport = true
    if collector == state.game.ship then 
      state.game.score = state.game.score + 1000 
      logger:add("Teleport Powerup collected! Press mod-back to activate!")
    end
  end,
  
  update = function(self, dt)
    self:superUpdate(dt)
    self.timer = self.timer + dt
  end,
  
  draw = function(self)
    local amplitude = #(self.images)/2
    local imageIndex = math.floor(amplitude * math.sin(8*math.pi*self.timer) + amplitude + 1)
    local x, y, s = L:xy(self.x, self.y, 0)
    love.graphics.draw(self.images[imageIndex], x, y, 0, s/25)
  end,
  
  create = function(self,node)
    local tpBody = love.physics.newBody(L.world,node.x,node.y,0.25)
    local tpShape = love.physics.newRectangleShape(tpBody,1,1)
    local result = CollectibleObject:create(tpBody, tpShape, TeleportPowerup.sound, TeleportPowerup.effect)
    result.superUpdate = result.update
    mixin(result, TeleportPowerup)
    result.class = TeleportPowerup
    return result
  end
}
