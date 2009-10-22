mock = function() 
  local t = {}
  setmetatable(t, {__call = mock, __index = mock, __newindex = mock})
  return t
end

love = {}
love.filesystem = {}
love.graphics = mock()

