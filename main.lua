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
WIDTH = 960
HEIGHT = 540

function love.load()
    math.randomseed(os.time())

    display = {}
    display.width, display.height = WIDTH, HEIGHT
    -- _, _, display.flags = love.window.getMode()
    -- display.width, display.height = love.window.getDesktopDimensions(display.flags.display)
    -- love.window.setMode(display.width, display.height)
    love.window.setMode(display.width, display.height, {
        -- fullscreen = true,
        resizable = true
    })
    icon = love.image.newImageData("ping-pong.png")
    love.window.setIcon(icon)
    love.window.setTitle("Ping Pong")

    racket1 = {}
    racket1.w = 20
    racket1.h = 80
    racket1.x = 10
    racket1.y = HEIGHT / 2 - racket1.h / 2
    racket1.dy = 0
    racket1.score = 0

    racket2 = {}
    racket2.score = 0

    ball = {}
    ball.w = 20
    ball.h = 20
    ball.x = WIDTH / 2 - ball.w / 2
    ball.y = HEIGHT / 2 - ball.h / 2
    ball.dx = 0
    ball.dy = 0

    bigFont = love.graphics.newFont("ice_pixel-7.ttf", 100)
    smallFont = love.graphics.newFont("ice_pixel-7.ttf", 50)

    state = 'start'
end

function love.update(dt)

    if collides(ball, racket1) then
        ball.dx = -ball.dx * 1.09
        ball.x = racket1.x + racket1.w
        ball.dy = math.random(-200, 200)
        racket1.score = racket1.score + 1
    end
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
    end
    if ball.y >= display.height then
        ball.y = display.height - ball.h
        ball.dy = -ball.dy
    end
    if ball.x <= 0 then
        state = "start"
        ball.x = 0
        ball.dx = 0
        ball.dy = 0
    end
    if ball.x >= display.width then
        -- state = "start"
        ball.x = display.width - ball.w
        ball.dx = -ball.dx
    end

    ball.x = ball.x + ball.dx * dt
    ball.y = ball.y + ball.dy * dt

    if love.keyboard.isDown('up') then
        racket1.dy = -300
    elseif love.keyboard.isDown('down') then
        racket1.dy = 300
    else
        racket1.dy = 0
    end
    if racket1.y <= 0 then
        racket1.y = 0
    end
    if racket1.y + racket1.h >= display.height then
        racket1.y = display.height - racket1.h
    end
    racket1.y = racket1.y + racket1.dy * dt

    fps = love.timer.getFPS()
end

function love.draw()
    love.graphics.setColor(1, 20 / 255, 1)
    if state == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf("Pressione enter para jogar", 0, display.height / 3, display.width, 'center')
    end

    love.graphics.setFont(bigFont)
    love.graphics.printf(racket1.score, 200, display.height / 2, display.width, 'left')
    love.graphics.printf(racket2.score, 0, display.height / 2, display.width - 200, 'right')

    if state == 'play' then
        love.graphics.setColor(20/255, 1, 1)
        love.graphics.rectangle('line', racket1.x, racket1.y, racket1.w, racket1.h)
        love.graphics.rectangle('line', ball.x, ball.y, ball.w, ball.h)
        -- love.graphics.circle('line', ball.x + ball.w / 2, ball.y + ball.h / 2, ball.w / 2)
    end

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
        ball.x = WIDTH / 2 - ball.w / 2
        ball.y = HEIGHT / 2 - ball.h / 2
        ball.dx = -300
        ball.dy = math.random(-150, 210)
        racket1.score = 0
        racket2.score = 0
        state = 'play'
    end

    if key == 'escape' then
        love.event.quit()
    end

end
