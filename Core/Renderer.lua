local Renderer = {}
Renderer.__index = Renderer

local RenderFunctions = {}
Renderer.RenderFunctions = {}

local Signal = require('Foxit.Classes.Signal')
local utils = require('Foxit.Core.Utills'); Renderer.log = utils.BuildLogFuncs('Renderer')

function Renderer.new()
    local self = {}; setmetatable(self, Renderer)

    self.RenderStepped = Signal.new()
    self.PreRender = Signal.new()
    self.dt = 0

    self.RenderFunction = RenderFunctions.V1

    self.log.info('New Renderer created')
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

function Renderer:GetWindowSize()
    return love.window.getDimensions()
end

function Renderer:SetWindowSize(w, h)
    local w, h, f = love.window.getMode() 
    self.log.info(('Window Size Changed: W: %s; H: %s'):format(w, h))
    return love.window.setMode( w, h, f )
end

function Renderer:Fullscreen(Type)
    local w, h, f = love.window.getMode() 
    f.fullscreen = true
    f.fullscreentype = Type
    self.log.info(('Entering Fullscreen mode with %s type'):format(Type))
    return love.window.setMode( w, h, f )
end

function Renderer:Windowed()
    local w, h, f = love.window.getMode() 
    f.fullscreen = false
    self.log.info('Entering Windowed mode')
    return love.window.setMode( w, h, f )
end

-- // Render Function
local function V1()
    

end

RenderFunctions.V1 = V1

return Renderer