local Camera = {}
Camera.__index = Camera

local Object2D = require('Foxit.Classes.Object2D')
setmetatable(Camera, Object2D)

function Camera.new()
    local self = Object2D.new(); setmetatable(self, Camera)
    self.Name = Camera
    
    return self
end


return Camera