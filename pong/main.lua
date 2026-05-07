Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Pong')

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 32)

    love.graphics.setFont(smallFont)

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = false,
        vsync = true,
        fullscreen = false
    })

    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {
        upscale = 'normal'
    })

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 50, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    gameState = 'start'
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'
            ball:reset()
        end
    end
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
        player1:update(dt)
    end

    if love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
        player1:update(dt)
    end

    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
        player2:update(dt)
    end

    if love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
        player2:update(dt)
    end

    if gameState == 'play' then
        ball:update(dt)
    end
end

function love.draw()
    push.start()

    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 1)

    if gameState == 'start' then
        love.graphics.printf("Game in start state!", 0, VIRTUAL_HEIGHT / 2 - 80, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf("Game in play state", 0, VIRTUAL_HEIGHT / 2 - 80, VIRTUAL_WIDTH, 'center')
    end

    player1:render()
    player2:render()

    ball:render()

    displayFPS()

    push.finish()
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(1, 1, 1, 1)
end
