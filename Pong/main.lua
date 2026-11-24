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
    love.window.setTitle("PONG")
    math.randomseed(os.time())
    -- love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    love.graphics.setDefaultFilter('nearest', 'nearest')
    font = {
    ['small_font'] = love.graphics.newFont('font.ttf', 8),
    ['large_font'] = love.graphics.newFont('font.ttf', 16),
    ['score_font'] = love.graphics.newFont('font.ttf', 32)}
    sound = {
    ['paddle_hit'] = love.audio.newSource('/sounds/paddle_hit.wav', "static"),
    ['score'] = love.audio.newSource('/sounds/score.wav', "static"),
    ['wall_hit'] = love.audio.newSource('/sounds/wall_hit.wav', "static")}

    love.graphics.setFont(font['small_font'])
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true,
    })
    p1_score = 0
    p2_score = 0
    serve = 1

    p1 = Paddle(10, 30, 5, 20)
    p2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
    ball = Ball(VIRTUAL_WIDTH /2 -2, VIRTUAL_HEIGHT/2 -2, 4, 4)
    
    game_state = "start"
end

function love.update(dt)
    if game_state == "serve" then
        ball.dy = math.random(-90, 90)
        if serve == 1 then
            ball.dx = -math.random(140, 200)
        else
            ball.dx = math.random(140, 200)
        end

    elseif game_state == 'play' then
        if ball:collides(p1) then
            ball.dx = -ball.dx * 1.3 -- >:3
            ball.x = p1.x + 5
            sound['paddle_hit']:play()
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball:collides(p2) then
            ball.dx = -ball.dx * 1.3
            ball.x = p2.x -4
            sound['paddle_hit']:play()
            if ball.dy > 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end
        
        if ball.y <= 0 then
            sound['wall_hit']:play()
            ball.dy = -ball.dy
            ball.y = 0
        elseif ball.y >= VIRTUAL_HEIGHT -4 then
            sound['wall_hit']:play()
            ball.dy = -ball.dy
            ball.y = VIRTUAL_HEIGHT - 4
        end

        if ball.x < 0 then
            p2_score = p2_score + 1
            sound['score']:play()
            serve = 1
            if p2_score >= 10 then
                game_state = "done"
                win = 2
            else
                game_state = "serve"
                ball:reset()
            end
        elseif ball.x > VIRTUAL_WIDTH then
            sound['score']:play()
            p1_score = p1_score + 1
            serve = 2
            if p1_score >= 10 then
                game_state = "done"
                win = 1
            else
                game_state = "serve"
                ball:reset()
            end
        end

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
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "enter" or key == "return" then
        if game_state == "start" then
            game_state = "serve"
        elseif game_state == "serve" then
            game_state = "play"
        elseif game_state == "done" then
            game_state = "start"
            ball:reset()
            p1_score = 0
            p2_score = 0

            if win == 1 then
                serve = 2
            else
                serve = 1
            end
        else
            game_state = "start"
            ball:reset()
        end
    end
end

function love.draw()
    push:apply('start')
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    display_score()
    if game_state == 'start' then
        love.graphics.setFont(font['small_font'])
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press [ENTER] to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif game_state == "serve" then
        love.graphics.setFont(font['small_font'])
        love.graphics.printf('Player ' .. tostring(serve) .. "'s serve!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press [ENTER] to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif game_state == "done" then
        love.graphics.setFont(font['large_font'])
        love.graphics.printf('Player ' .. tostring(win) .. " won!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(font['small_font'])
        love.graphics.printf('Press [ENTER] to restart!', 0, 40, VIRTUAL_WIDTH, 'center')
        
    end
    p1:render()
    p2:render()
    ball:render()
    display_fps()
    push:apply('end')
end

function display_fps()
    love.graphics.setFont(font['small_font'])
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end

function display_score()
    love.graphics.setFont(font['score_font'])
    love.graphics.print(tostring(p1_score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(p2_score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end