
local display = require('display')


return function (x)
    local entity = {}
    entity.w = 20
    entity.h = 80
    entity.x = x
    entity.y = display.height / 2 - entity.h / 2
    entity.dx = 0
    entity.dy = 0
    entity.score = 0
    
    entity.draw = function(self)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
        -- love.graphics.line(self.x+self.w*0.5, self.y+self.h*0.5, self.x+self.w*0.5+self.dx*0.2, self.dy*0.2+self.h*0.5+self.y)s
    end

    entity.update = function( self, dt, up_key, down_key)
        if love.keyboard.isDown(up_key) then
            self.dy = -300
        elseif love.keyboard.isDown(down_key) then
            self.dy = 300
        else
            self.dy = 0
        end
        
        if self.y <= 0 then
            self.y = 0
        end
        if self.y + self.h >= display.height then
            self.y = display.height - self.h
        end
        
        self.y = self.y + self.dy * dt
    end

    entity.computer_erro = 10
    entity.computer = function( self, dt, ball_y, ball_h)
        
        if self.y > ball_y + self.computer_erro then
            self.dy = -300 
        elseif self.y+self.h < ball_y+ball_h+ self.computer_erro then
            self.dy = 300 
        else
            self.dy = 0
        end
        
        if self.y <= 0 then
            self.y = 0
        end
        if self.y + self.h >= display.height then
            self.y = display.height - self.h
        end
        
        self.y = self.y + self.dy * dt
    end


    return entity
end