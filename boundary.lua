local display = require('display')

return function (x,y,w,h)
    entity = {}
    entity.w = w or 1
    entity.h = h or display.height
    entity.x = x or display.width/2
    entity.y = y or 0
    
    entity.draw = function( self)
        love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    end

    return entity
end