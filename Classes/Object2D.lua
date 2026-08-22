local Object2D = {}
Object2D.__index = Object2D

local Object = require('Foxit.Classes.Object')
local Signal = require('Foxit.Classes.Signal')
setmetatable(Object2D, Object)

function Object2D.new()
    local self = Object.new(); setmetatable(self, Object2D)
    
    self.Name = 'Object2D'
    self.Position = Vector2.new(0, 0)
    self.Scale = Vector2.new(1, 1)
    self.Rotation = 0
    self.Color = Color3.new(1, 1, 1)
    self.Transparency = 0
    self.LoveImage = nil

    self.OnMouseClicked = Signal.new()

    return self
end

function Object2D:LoadImage(path)
    self.LoveImage = love.graphics.newImage(path)
end

function Object2D:Destroy()
    self.LoveImage = nil
    collectgarbage("collect")
end

return Object2D