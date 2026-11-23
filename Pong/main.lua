push = require 'push'
Class = require "class"
require "Ball"
require "Paddle"

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 300

function love.load()
    math.randomseed(os.time())
    -- love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    love.graphics.setDefaultFilter('nearest', 'nearest')
    small_font = love.graphics.newFont('font.ttf', 8)
    love.graphics.setFont(small_font)
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true,
    })
    game_state = "start"
    p1 = Paddle(10, 30, 5, 20)
    p2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
    ball = Ball(VIRTUAL_WIDTH /2 -2, VIRTUAL_HEIGHT/2 -2, 4, 4)
end

function love.update(dt)
    if love.keyboard.isDown('w')then
        p1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        p1.dy = PADDLE_SPEED
    else
        p1.dy = 0
    end
    if love.keyboard.isDown('up') then
        p2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        p2.dy = PADDLE_SPEED
    else
        p2.dy = 0
    end

    if game_state == 'play' then
        ball:update(dt)
    end

    p1:update(dt)
    p2:update(dt)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "enter" or key == "return" then
        if game_state == "start" then
            game_state = "play"
        else
            game_state = "start"
            Ball:reset()
        end
    end
end

function love.draw()
    push:apply('start')
    p1:render()
    p2:render()
    ball:render()
    push:apply('end')
end

