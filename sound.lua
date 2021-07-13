
return function ()
    local sounds = {}
    sounds.hit_racket = love.audio.newSource('sound/Laser_shoot 28.wav', 'static')
    sounds.hit_sreen = love.audio.newSource('sound/Jump 11.wav', 'static')
    sounds.point = love.audio.newSource('sound/Powerup 7.wav', 'static')
    sounds.music = love.audio.newSource('sound/110749.mid', 'static')
    sounds.win = love.audio.newSource('sound/Powerup 10.wav', 'static')
    

    sounds.music:setLooping(true)
    return sounds
end