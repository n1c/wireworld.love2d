
local Block = require('block')

local Blocks = {}
function Blocks:new(game)
  print('Blocks:new')
  local o = {}
  setmetatable(o, self)
  self.__index = self

  o.game = game
  o.collection = {}
  o:init()

  o.since_last_tick = 0
  o.tick = 0
  return o
end

function Blocks:init()
  for x = 1, BLOCK_COUNT do
    self.collection[x] = {}
    for y = 1, BLOCK_COUNT do
      self.collection[x][y] = Block:new(game, x, y)
    end
  end

  -- Now that we have all our blocks, set the neighs
  for x = 1, BLOCK_COUNT do
    for y = 1, BLOCK_COUNT  do
      if y > 1 then self.collection[x][y]:addNeigh(self.collection[x][y - 1]) end -- North
      if x < BLOCK_COUNT then self.collection[x][y]:addNeigh(self.collection[x + 1][y]) end -- East
      if y < BLOCK_COUNT then self.collection[x][y]:addNeigh(self.collection[x][y + 1]) end -- South
      if x > 1 then self.collection[x][y]:addNeigh(self.collection[x - 1][y]) end -- West

      if x < BLOCK_COUNT and y > 1 then self.collection[x][y]:addNeigh(self.collection[x + 1][y - 1]) end -- North East
      if x < BLOCK_COUNT and y < BLOCK_COUNT then self.collection[x][y]:addNeigh(self.collection[x + 1][y + 1]) end -- South East
      if x > 1 and y < BLOCK_COUNT then self.collection[x][y]:addNeigh(self.collection[x - 1][y + 1]) end -- South West
      if x > 1 and y > 1 then self.collection[x][y]:addNeigh(self.collection[x - 1][y - 1]) end -- North West
    end
  end
end

function Blocks:toggle(x, y)
  self.collection[x][y]:toggle()
end

function Blocks:update(dt)
  self.since_last_tick = self.since_last_tick + dt
  if self.since_last_tick * 1000 < TICK_TIME then return end
  self.tick = (self.tick + 1) % 4;
  self.since_last_tick = 0

  -- Tick the engine
  self.collection[BLOCK_COUNT / 2][1].value = 3 - self.tick

  -- Calculate all neighbour values
  for x = 1, BLOCK_COUNT do
    for y = 1, BLOCK_COUNT do
      if self.collection[x][y].value == BLOCK_STATE_CONDUCTOR then
        self.collection[x][y]:calcNeighs()
      end
    end
  end

  for x = 1, BLOCK_COUNT do
    for y = 1, BLOCK_COUNT do
      if self.collection[x][y].value > BLOCK_STATE_HEAD then
        self.collection[x][y].value = self.collection[x][y].value - 1
      elseif self.collection[x][y].value == BLOCK_STATE_HEAD then
        if self.collection[x][y].neigh_value == BLOCK_STATE_HEAD or self.collection[x][y].neigh_value == BLOCK_STATE_TAIL then
          self.collection[x][y].value = BLOCK_STATE_CONDUCTOR
        end
      end

      -- Reset all the neigh_values
      self.collection[x][y].neigh_value = BLOCK_STATE_EMPTY
    end
  end
end

function Blocks:draw(dt)
  for x = 1, BLOCK_COUNT do
    for y = 1, BLOCK_COUNT do
      self.collection[x][y]:draw()
    end
  end
end

return Blocks
