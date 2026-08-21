local Renderer = {}
Renderer.__index = Renderer

local RenderFunctions = {}
Renderer.RenderFunctions = {}

local Signal = require('Foxit.Classes.Signal')

function Renderer.new()
    local self = {}; setmetatable(self, Renderer)

    self.RenderStepped = Signal.new()
    self.PreRender = Signal.new()
    self.dt = 0

    self.RenderFunction = RenderFunctions.V1

    return self
end

function Renderer:Update(dt)
    self.dt = 0
end

function Renderer:Draw()
    self.PreRender:Fire(self.dt)

    -- // Render stuff

    self.RenderFunction()

    -- //

    self.RenderStepped:Fire(self.dt)
end

-- // Render Function
local function V1()
    

end

RenderFunctions.V1 = V1

return Renderer