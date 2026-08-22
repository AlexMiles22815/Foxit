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

    self.RenderFunction(self)

    -- //

    self.RenderStepped:Fire(self.dt)
end

function Renderer:GetWindowSize()
    local w, h, f = love.window.getMode() 
    return w, h
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
local function V1(Renderer)
    local Objects = Foxit.Objects
    local Camera = Foxit.Camera

    local sw, sh = Renderer:GetWindowSize()

    -- // Draw Objects
    love.graphics.push()

    love.graphics.translate(
        sw / 2 - Camera.Position.X,
        sh / 2 - Camera.Position.Y
    )

    for i, Object in pairs(Objects) do
        if Object.Mouse then goto continue end
        
        if Object.LoveImage then
            love.graphics.draw(
                Object.LoveImage,
                Object.Position.X,
                Object.Position.Y,
                0,
                Object.Scale.X,
                Object.Scale.Y,
                Object.LoveImage:getWidth() / 2,
                Object.LoveImage:getHeight() / 2
            )


        end
        ::continue::
    end

    love.graphics.pop()

    -- // Draw GUI

    love.graphics.push()

    love.graphics.pop()

    -- // Core GUI (Mouse, itd)

    love.graphics.push()

    local Mouse = Foxit.Mouse
    if Mouse.LoveImage then
            love.graphics.draw(
                Mouse.LoveImage,
                Mouse.Position.X,
                Mouse.Position.Y,
                0,
                Mouse.Scale.X,
                Mouse.Scale.Y,
                Mouse.LoveImage:getWidth() / 2,
                Mouse.LoveImage:getHeight() / 2
            )

        end

    love.graphics.pop()

    ::continue::
end

RenderFunctions.V1 = V1

return Renderer