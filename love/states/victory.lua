state.victory = {

  bgColor = {0,0,0,192},
  txtColor = {255,255,255},
  fontBig = false,

  update = function(s,dt) 
    if not s.fontBig then
    love.graphics.setFont(love.default_font,36)
    s.fontBig = true
    end
  end,
  
  draw = function(s) 
    state.game:draw()
    lib.setColor(s.bgColor)
    love.graphics.rectangle(love.draw_fill,0,0,800,600)
    lib.setColor(s.txtColor)
    love.graphics.setFont(love.default_font,36)
    love.graphics.draw("Level " .. tostring(state.game.levelNumber) .. " complete!", 250, 200)
    love.graphics.draw("Press any key to start the next level!", 100, 300)
  end,
  
  mousepressed = function(s,x,y,button) end,
  
  keypressed = function(s,key) 
    s:done()
  end,
  
  joystickpressed = function(s,j,b)
    s:done()
  end,
  
  done = function(s)
    state.game:enqueueNextLevel()
    state.current = state.game
    love.graphics.setFont(love.default_font,12)
    s.fontBig = false
  end
}
