
local Game = {}
function Game:new()
  print('Game:new')
  local o = {}
  setmetatable(o, self)
  self.__index = self

  o.status = 'running'
  o.blocks = require('blocks'):new(o)
  return o
end

function Game:update(dt)
  self.blocks:update(dt)
end

function Game:draw()
  self.blocks:draw()
end -- draw

function Game:click(x, y)
  self.blocks:toggle(math.ceil(x / BLOCK_SIZE), math.ceil(y / BLOCK_SIZE))
end

return Game
