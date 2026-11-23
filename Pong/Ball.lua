Class = require "class"
Ball = Class{}

function Ball:init(x, y, radius)
    self.x = x
    self.y = y
    self.width = radius
    self.height = radius

    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-90, 90)
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH /2 -2
    self.y = VIRTUAL_HEIGHT /2 -2
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-90, 90)
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
    if self.y < 1 or self.y > VIRTUAL_HEIGHT then
        self.dy = -self.dy
    end
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end