local Mouse = {}
Mouse.__index = Mouse

local Signal = require('Foxit.Classes.Signal')
local Object2D = require('Foxit.Classes.Object2D')

setmetatable(Mouse, Object2D)

function Mouse.new()
    local self = Object2D.new()
    setmetatable(self, Mouse)

    self.Name = 'Mouse'
    self.Mouse = true

    self.LMB = Signal.new()
    self.RMB = Signal.new()

    self.Color = Color3.new(1, 1, 1)

    self.WorldPosition = Vector2.new(0, 0)

    return self
end

return Mouse