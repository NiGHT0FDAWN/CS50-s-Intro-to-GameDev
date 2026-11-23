Class = require "class"
Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0

    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-90, 90)
end

function Paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(1,self.y + self.dy *dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT -self.height-1, self.y + self.dy *dt)
    end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end