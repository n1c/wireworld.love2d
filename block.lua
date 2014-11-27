
local Block = {}
function Block:new(game, x, y)
  -- print('Block:new ' .. x .. ':' .. y)
  local o = {}
  setmetatable(o, self)
  self.__index = self

  o.game = game
  o.x = x
  o.y = y
  o.drawX = (o.x - 1) * BLOCK_SIZE
  o.drawY = (o.y - 1) * BLOCK_SIZE
  o.value = BLOCK_STATE_EMPTY
  o.neigh_value = BLOCK_STATE_EMPTY
  o.neighs = {}

  return o
end

function Block:toggle()
  if self.value == 0 then
    self.value = 1
  else
    self.value = 0
  end
end

function Block:calcNeighs()
  for i, b in pairs(self.neighs) do
    b.neigh_value = b.neigh_value + 1
  end
end

function Block:draw(dt)
  love.graphics.setColor(BLOCK_OUTLINE_COLOR)
  love.graphics.rectangle('fill', self.drawX, self.drawY, BLOCK_SIZE, BLOCK_SIZE);

  love.graphics.setColor(BLOCK_COLORS[self.value])
  love.graphics.rectangle('fill', self.drawX + BLOCK_OUTLINE_WIDTH, self.drawY + BLOCK_OUTLINE_WIDTH, BLOCK_SIZE, BLOCK_SIZE);
end

function Block:addNeigh(n)
  table.insert(self.neighs, n)
end

return Block
