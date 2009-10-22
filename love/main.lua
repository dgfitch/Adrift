love.load = function()
  math.randomseed(os.time())
  require("lib.lua")
  require("oo.lua")
  require("util/util.lua")
  require("objects/objects.lua")
  require("objects/Level.lua")
  require("sound/sound.lua")
  require("states/states.lua")
  love.mouse.setVisible(false)
  state.current = state.menu
  love.audio.play(sound.bgm)
  useJoystick = (love.joystick.getNumJoysticks() > 0)
  if useJoystick then love.joystick.open(0) end
end

love.update = function(dt)
  dt = math.min(dt, 1/15)
  state.current:update(dt)
end

love.draw = function()
  state.current:draw()
  if state.repl.active then state.repl:draw() end 
  logger:draw()
end

love.mousepressed = function(x, y, button)
  state.current:mousepressed(x, y, button)
end

love.keypressed = function(key)
  if state.repl.active then
    if key==love.key_escape or key==love.key_tab then
      state.repl.active = false
    else
      state.repl:keypressed(key)
    end
  else
    if key==love.key_escape then love.system.exit() end
    if key==love.key_r then love.system.restart() end
    if key==love.key_tab then
      state.repl.active = true
      state.repl:start()
    end
    state.current:keypressed(key)
  end
end

love.joystickpressed = function(j,b)
  if state.current.joystickpressed ~= nil then state.current:joystickpressed(j,b) end
end

logger = {
  messages = {},
  
  add = function(l,message)
    table.insert(l.messages,{msg = message, time = os.time()})
    if table.getn(l.messages) > 20 then table.remove(l.messages,1) end
  end,
  
  draw = function(l)
    for k,v in ipairs(l.messages) do
      local timely = 255*math.exp((v.time - os.time())/3)
      lib.setColor(255,255,255,timely)
      love.graphics.draw(v.msg, 10,k*20)
      if timely < 32 then v.dead = true end 
    end
    
    local toKeep = {}
    for k, v in ipairs(l.messages) do
      if not v.dead then table.insert(toKeep, v) end
    end
    l.messages = toKeep
  end
}
