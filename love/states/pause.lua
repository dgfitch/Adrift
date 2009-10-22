state.pause = {
  
  shipMapColor = {255,255,255},
  enemyMapColor = {255,0,0},
  powerupMapColor = {128,255,128},
  crystalMapColor = {128,192,255},
  portalMapColor = {128,192,255},
  otherMapColor = {128,128,128},
  
  
  update = function(s,dt)
  end,
  
  draw = function(s) 
    local g = state.game
    L:renderMap(g.ship.hasFullMap)
    if g.ship.hasFieldDetector then
      for k,v in ipairs(g.level.objects) do
        if v.body ~= nil then
          local wx,wy = v.body:getPosition()
          local x,y,w = L:xyMap(wx,wy)
          if v.type == objects.ships then
            if v.friendly then
              lib.setColor(s.shipMapColor)
              w = w*2
            else
              lib.setColor(s.enemyMapColor)
            end
          elseif v.type == objects.powerups then
            lib.setColor(s.powerupMapColor)
          elseif v.type == objects.warpCrystal then
            lib.setColor(s.crystalMapColor)
          elseif v.type == objects.startingSpot then
            lib.setColor(s.portalMapColor)
          else
            lib.setColor(s.otherMapColor)
            w = w/2
          end
          love.graphics.rectangle(love.draw_fill,x-w/2,y-w/2,w,w)
        end
      end
    end
    local wx,wy = g.ship.body:getPosition()
    local x,y,w = L:xyMap(wx,wy)
    lib.setColor(s.shipMapColor)
    love.graphics.rectangle(love.draw_fill,x-w,y-w,w*2,w*2)

  end,
  
  mousepressed = function(s,x,y,button) end,
  
  keypressed = function(s,key) 
    state.current = state.game
  end,
  
  joystickpressed = function(s,j,b)
    state.current = state.game
  end
}
