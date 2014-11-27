
local Game = require('game')

WORLD_SIZE = 800
TICK_TIME = 150 -- milliseconds
BLOCK_SIZE = 16
BLOCK_COUNT = WORLD_SIZE / BLOCK_SIZE

BLOCK_OUTLINE_COLOR = { 52, 73, 94 }
BLOCK_OUTLINE_WIDTH = 1

BLOCK_STATE_EMPTY = 0
BLOCK_STATE_HEAD = 1
BLOCK_STATE_TAIL = 2
BLOCK_STATE_CONDUCTOR = 3

BLOCK_COLORS = {
  [BLOCK_STATE_EMPTY] = { 39, 174, 96 },
  [BLOCK_STATE_HEAD] = { 52, 152, 219 },
  [BLOCK_STATE_TAIL] = { 142, 68, 173 },
  [BLOCK_STATE_CONDUCTOR] = { 231, 76, 60 },
}

local game
function love.load()
  print('love.load')
  game = Game:new()
end

function love.focus(f)
  if f then
    if game.status == 'paused' then
      game.status = 'running'
    end
  else
    if game.status == 'running' then
      game.status = 'paused'
    end
  end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end

  if key == 'return' then
    -- Reset if running
    if game.status == 'running' then
      game = Game:new()
    end
  end
end

function love.mousepressed(x, y, button)
  game:click(x, y)
end


function love.update(dt)
  if game.status == 'running' then
    game:update(dt)
  end
end

function love.draw()
  game:draw()
end
