local Camera = {}
Camera.__index = Camera

local Object2D = require('Foxit.Classes.Object2D')
setmetatable(Camera, Object2D)

function Camera.new()
    local self = Object2D.new(); setmetatable(self, Camera)
    self.Name = Camera
    self.Zoom = 1
    
    return self
end

function Camera:ScreenToWorld(x, y)
    local Renderer = Foxit:GetRenderer()

    x, y = Renderer:ScreenToVirtual(x, y)

    local vw, vh = Renderer:GetVirtualSize()

    x = x - vw / 2 + self.Position.X
    y = y - vh / 2 + self.Position.Y

    return Vector2.new(x, y)
end

return Camera