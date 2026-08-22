local Object2D = {}
Object2D.__index = {}

local Object = require('Foxit.Classes.Object')
setmetatable(Object2D, Object)

function Object2D.new()
    local self = Object.new(); setmetatable(self, Object2D)
    
    self.Name = 'Object2D'
    self.Position = Vector2.new(0, 0)
    self.Scale = Vector2.new(1, 1)
    self.Rotation = 0

    self.LoveImage = nil


    return self
end

function Object2D:LoadImage(path)
    self.LoveImage = love.graphics.newImage(path)
end

return Object2D