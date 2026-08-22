local Mouse = {}
Mouse.__index = {}

local Signal = require('Foxit.Classes.Signal')

local Object2D = require('Foxit.Classes.Object2D')
setmetatable(Mouse, Object2D)

function Mouse.new()
    local self = Object2D.new(); setmetatable(self, Mouse)
    self.Mouse = true

    self.LMB = Signal.new()
    self.RMB = Signal.new()

    self.Color = Color3.new(1, 1, 1)

    return self
end

return Mouse