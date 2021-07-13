-- Programa: Aula 1 - Ping Pong
-- Autor: Michael Jordan S Chagas
-- Curso: Ciência da Computação - UFMT-CUA
-- Disclina: Design e Programação de Games (Opt)
-- Docente: Maxwell Silva Carmo
-- Data: 2021-07-01
--
-- Este programa simula o jogo de ping pong, com 
-- os controles "up" e "down" para mover a racket.
-------------------------------------------------------

MAX_POINT = 20

local display = require('display')
local racket = require('racket')
local ball = require('ball')
local boundary = require('boundary')
local sound = require('sound')

function love.load()
    math.randomseed(os.time())

    -- love.window.setMode(display.width, display.height)
    love.window.setMode(display.width, display.height, {
        -- fullscreen = true,
        resizable = true
    })

    racket1 = racket(10)
    racket2 = racket(display.width - 20 -10)
    boundary_left = boundary(-1)
    boundary_right = boundary(display.width)

    ball = ball()

    bigFont = love.graphics.newFont("ice_pixel-7.ttf", 100)
    smallFont = love.graphics.newFont("ice_pixel-7.ttf", 50)

    sounds = sound()
    sounds.music:play()
    state = 'start'
end

function love.update(dt)
    if state == 'pause' or state == 'serve' then
        return
    end

    if collides(ball, racket1) then
        ball.service_direction = -ball.service_direction
        ball.dx = ball.dx * 1.09
        ball.x = racket1.x + racket1.w
        ball.dy = math.random(-200, 200)
        racket1.score = racket1.score + 1
        sounds.hit_racket:play()
        if racket1.score == MAX_POINT then
            state = 'start'
            sounds.win:play()
        end
        racket1.computer_erro = math.random(-ball.h*3,ball.h*3)
    end
    if collides(ball, racket2) then
        ball.service_direction = -ball.service_direction
        ball.dx = ball.dx * 1.09
        ball.x = racket2.x - racket2.w - ball.w
        ball.dy = math.random(-200, 200)
        racket2.score = racket2.score + 1
        sounds.hit_racket:play()
        if racket2.score == MAX_POINT then
            state = 'start'
            sounds.win:play()
        end
    end

    if ball.x <= 0 then
        state = "serve"
        ball:centralizes()
        racket2.score = racket2.score + 1
        if racket2.score == MAX_POINT then
            state = 'start'
            sounds.win:play()
        else
            ball.service_direction = 1
            state = 'serve'
        end
        sounds.point:play() 
    end
    if ball.x+ball.w >= display.width then
        state = "serve"
        ball:centralizes()
        racket1.score = racket1.score + 1
        if racket1.score == MAX_POINT then
            state = 'start'
            sounds.win:play()
        else
            ball.service_direction = -1
            state = 'serve'
        end
        sounds.point:play() 
    end

    if state == 'serve' then
        return
    end

    ball:update(dt)
    -- racket1:update( dt, 'w', 's')
    racket1:computer( dt, ball.y, ball.h)
    racket2:update( dt, 'up', 'down')

    fps = love.timer.getFPS()
end

function love.draw()
    love.graphics.setColor(1, 20 / 255, 1)
    love.graphics.setFont(smallFont)
    if state == 'start' then
        love.graphics.printf("Pressione enter para jogar", 0, display.height / 3, display.width, 'center')
    elseif state == 'serve' then
        love.graphics.printf("Pressione espaco para servir", 0, display.height / 3, display.width, 'center')
    elseif state == 'pause' then
        love.graphics.printf("Pressione espaco para continuar\nou esc para sair", 0, display.height / 3, display.width, 'center')
    end

    love.graphics.setFont(bigFont)
    love.graphics.printf(racket1.score, 200, display.height / 2, display.width, 'left')
    love.graphics.printf(racket2.score, 0, display.height / 2, display.width - 200, 'right')

    -- if state == 'play' then
        love.graphics.setColor(200/255, 1, 1)
        racket1:draw()
        racket2:draw()
        ball:draw()
        boundary_left:draw()
        boundary_right:draw()
    -- end

    love.graphics.reset()
    love.graphics.print('FPS: ' .. fps, 10, 12)

end

function collides(object1, object2)
    if object1.y > object2.y + object2.h or object1.y + object1.h < object2.y then
        return false
    end
    if object1.x > object2.x + object2.w or object1.x + object1.w < object2.x then
        return false
    end
    return true
end

function love.keypressed(key)
    if state == 'start' and (key == 'return' or key == 'space') then
        ball:centralizes()
        ball.dx = ball.service_direction * 300
        ball.dy = math.random(-150, 210)
        racket1.score = 0
        racket2.score = 0
        state = 'play'
    end

    if state == 'serve' and (key == 'return' or key == 'space') then
        ball:centralizes()
        ball.dx = ball.service_direction * 300
        ball.dy = math.random(-150, 210)
        state = 'play'
    end

    if state == 'pause' and (key == 'return' or key == 'space') then
        state = 'play'
    end

    if key == 'escape' and state == 'play' then
        state = 'pause'
    elseif  key == 'escape' then
        love.event.quit()
    end

end
