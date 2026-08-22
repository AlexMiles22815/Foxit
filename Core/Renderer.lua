local Renderer = {}
Renderer.__index = Renderer

local RenderFunctions = {}
Renderer.RenderFunctions = {}

local Signal = require('Foxit.Classes.Signal')
local utils = require('Foxit.Core.Utills')
local Vector2 = require('Foxit.Classes.Vector2')

Renderer.log = utils.BuildLogFuncs('Renderer')


function Renderer.new()
    local self = {}
    setmetatable(self, Renderer)

    self.RenderStepped = Signal.new()
    self.PreRender = Signal.new()

    self.dt = 0

    self.RenderFunction = RenderFunctions.V1

    -- Virtual / logical resolution
    self.VirtualSize = Vector2.new(320, 180)

    -- Pixel-perfect rendering
    self.PixelPerfect = false
    self.Canvas = nil

    self.log.info('New Renderer created')

    return self
end


-- =========================================
-- Update / Draw
-- =========================================

function Renderer:Update(dt)
    self.dt = dt
end


function Renderer:Draw()
    self.PreRender:Fire(self.dt)

    self.RenderFunction(self)

    self.RenderStepped:Fire(self.dt)
end


-- =========================================
-- Window
-- =========================================

function Renderer:GetWindowSize()
    local w, h = love.window.getMode()

    return w, h
end


function Renderer:SetWindowSize(w, h)
    local _, _, f = love.window.getMode()

    self.log.info(
        ('Window Size Changed: W: %s; H: %s'):format(w, h)
    )

    return love.window.setMode(w, h, f)
end


function Renderer:Fullscreen(Type)
    local w, h, f = love.window.getMode()

    f.fullscreen = true
    f.fullscreentype = Type

    self.log.info(
        ('Entering Fullscreen mode with %s type'):format(Type)
    )

    return love.window.setMode(w, h, f)
end


function Renderer:Windowed()
    local w, h, f = love.window.getMode()

    f.fullscreen = false

    self.log.info('Entering Windowed mode')

    return love.window.setMode(w, h, f)
end


-- =========================================
-- Virtual Resolution
-- =========================================

function Renderer:GetVirtualSize()
    return self.VirtualSize.X, self.VirtualSize.Y
end


function Renderer:SetVirtualSize(w, h)
    self.VirtualSize = Vector2.new(w, h)

    if self.PixelPerfect then
        self:CreateCanvas()
    end
end


-- =========================================
-- Pixel Perfect
-- =========================================

function Renderer:SetPixelPerfect(value)
    value = not not value

    if self.PixelPerfect == value then
        return
    end

    self.PixelPerfect = value

    if self.PixelPerfect then
        self:CreateCanvas()

        self.log.info(
            'PixelPerfect rendering enabled'
        )
    else
        self.Canvas = nil

        self.log.info(
            'PixelPerfect rendering disabled'
        )
    end
end


function Renderer:CreateCanvas()
    local w, h = self:GetVirtualSize()

    self.Canvas = love.graphics.newCanvas(w, h)

    -- VERY IMPORTANT for pixel art
    self.Canvas:setFilter(
        'nearest',
        'nearest'
    )

    self.log.info(
        ('Created PixelPerfect Canvas: %sx%s'):format(w, h)
    )
end


-- =========================================
-- Normal Viewport
-- =========================================

function Renderer:GetViewport()
    local sw, sh = self:GetWindowSize()
    local vw, vh = self:GetVirtualSize()

    local scale = math.min(
        sw / vw,
        sh / vh
    )

    local width = vw * scale
    local height = vh * scale

    local x = (sw - width) / 2
    local y = (sh - height) / 2

    return {
        X = x,
        Y = y,

        Width = width,
        Height = height,

        Scale = scale
    }
end


-- =========================================
-- Pixel Perfect Viewport
-- =========================================

function Renderer:GetPixelViewport()
    local sw, sh = self:GetWindowSize()
    local vw, vh = self:GetVirtualSize()

    -- Integer scale
    local scale = math.floor(
        math.min(
            sw / vw,
            sh / vh
        )
    )

    -- Window smaller than virtual resolution
    if scale < 1 then
        scale = 1
    end

    local width = vw * scale
    local height = vh * scale

    local x = math.floor(
        (sw - width) / 2
    )

    local y = math.floor(
        (sh - height) / 2
    )

    return {
        X = x,
        Y = y,

        Width = width,
        Height = height,

        Scale = scale
    }
end


-- =========================================
-- Coordinate Conversion
-- =========================================

function Renderer:ScreenToVirtual(x, y)

    local viewport

    if self.PixelPerfect then
        viewport = self:GetPixelViewport()
    else
        viewport = self:GetViewport()
    end

    x = (x - viewport.X) / viewport.Scale
    y = (y - viewport.Y) / viewport.Scale

    return x, y
end


-- =========================================
-- World
-- =========================================

function Renderer:BeginWorld()

    local vw, vh = self:GetVirtualSize()
    local Camera = Foxit.Camera

    love.graphics.push()

    if not self.PixelPerfect then

        local viewport = self:GetViewport()

        love.graphics.translate(
            viewport.X,
            viewport.Y
        )

        love.graphics.scale(
            viewport.Scale,
            viewport.Scale
        )
    end

    love.graphics.translate(
        vw / 2 - Camera.Position.X,
        vh / 2 - Camera.Position.Y
    )
end


function Renderer:EndWorld()
    love.graphics.pop()
end


-- =========================================
-- GUI
-- =========================================

function Renderer:BeginGUI()

    love.graphics.push()

    if not self.PixelPerfect then

        local viewport = self:GetViewport()

        love.graphics.translate(
            viewport.X,
            viewport.Y
        )

        love.graphics.scale(
            viewport.Scale,
            viewport.Scale
        )
    end
end


function Renderer:EndGUI()
    love.graphics.pop()
end


-- =========================================
-- Screen GUI
-- =========================================

function Renderer:BeginScreenGUI()
    love.graphics.push()
end


function Renderer:EndScreenGUI()
    love.graphics.pop()
end


-- =========================================
-- Pixel Perfect Frame
-- =========================================

function Renderer:BeginPixelPerfect()

    if not self.Canvas then
        self:CreateCanvas()
    end

    love.graphics.setCanvas(self.Canvas)

    love.graphics.clear(
        0,
        0,
        0,
        1
    )
end


function Renderer:EndPixelPerfect()

    love.graphics.setCanvas()

    local viewport = self:GetPixelViewport()

    love.graphics.push()

    love.graphics.translate(
        viewport.X,
        viewport.Y
    )

    love.graphics.setColor(
        1,
        1,
        1,
        1
    )

    love.graphics.draw(
        self.Canvas,
        0,
        0,
        0,
        viewport.Scale,
        viewport.Scale
    )

    love.graphics.pop()
end


-- =========================================
-- Render Function
-- =========================================

local function V1(Renderer)

    local Objects = Foxit.Objects

    if Renderer.PixelPerfect then
        Renderer:BeginPixelPerfect()
    end
    
    -- // World

    Renderer:BeginWorld()

    for i, Object in pairs(Objects) do

        if Object.Mouse then
            goto continue
        end

        if Object.LoveImage then

            local R, G, B =
                Object.Color:ReturnRGB()

            local A =
                Object.Transparency

            love.graphics.setColor(
                R,
                G,
                B,
                1 - A
            )

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

    Renderer:EndWorld()

    Renderer:BeginGUI()

    -- // GUI

    Renderer:EndGUI()

    if Renderer.PixelPerfect then
        Renderer:EndPixelPerfect()
    end


    -- // Core Gui

    Renderer:BeginScreenGUI()

    local Mouse = Foxit.Mouse

    if Mouse.LoveImage then

        local R, G, B =
            Mouse.Color:ReturnRGB()

        local A =
            Mouse.Transparency

        love.graphics.setColor(
            R,
            G,
            B,
            1 - A
        )

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

    love.graphics.setColor(
        1,
        1,
        1,
        1
    )

    Renderer:EndScreenGUI()
end


RenderFunctions.V1 = V1


return Renderer