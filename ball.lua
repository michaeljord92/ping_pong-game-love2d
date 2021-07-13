local display = require('display')
local sound = require('sound')


return function ( x)
    local sounds = sound()
    local entity = {}
    entity.w = 20
    entity.h = 20
    entity.x = display.width / 2 - entity.w / 2
    entity.y = display.height / 2 - entity.h / 2
    entity.dx = 0
    entity.dy = 0
    entity.service_direction = 1
    
    entity.draw = function ( self)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
        -- love.graphics.circle('line', self.x + self.w / 2, self.y + self.h / 2, self.w / 2)
        -- love.graphics.line(self.x+self.w*0.5, self.y+self.h*0.5, self.x+self.w*0.5+self.dx*0.2, self.dy*0.2+self.h*0.5+self.y)
    end
    
    entity.update = function ( self, dt)
        if self.y <= 0 then
            self.y = 0
            self.dy = -self.dy
            sounds.hit_sreen:play()
        end
        if self.y >= display.height - self.h then
            self.y = display.height - self.h
            self.dy = -self.dy
            sounds.hit_sreen:play()
        end

        self.x = self.x + self.dx * self.service_direction * dt
        self.y = self.y + self.dy * dt
    end
    
    entity.centralizes = function(self)
        self.dx = 0
        self.dy = 0
        self.x = display.width / 2 - self.w / 2
        self.y = display.height / 2 - self.h / 2
    end

    return entity
end