local Foxit = {
    love = {}, -- Love Callbacks
    Living = 0,

    Collections = {Tags = {}},

    Sounds = {},
    Objects = {},
    Gui = {},
    CoreGui = {},

    Version = '0.0.1',
}

setmetatable(Foxit.Objects, {__mode = 'k'}) -- Weak 
setmetatable(Foxit.Sounds, {__mode = 'k'}) -- Weak =)))

_G.Foxit = Foxit

local utils = require('Foxit.Core.Utills'); Foxit.log = utils.BuildLogFuncs('main')
local Renderer = require('Foxit.Core.Renderer').new()
local SoundHandler = require('Foxit.Core.Handlers.SoundHandler')
local Mouse = require('Foxit.Classes.Mouse')

require('Foxit.Core.Globals')

Script = require('Foxit.Classes.Script')
Signal = require('Foxit.Classes.Signal')
Vector2 = require('Foxit.Classes.Vector2')
Color3 = require('Foxit.Classes.Color3')
Camera = require('Foxit.Classes.Camera')
Object2D = require('Foxit.Classes.Object2D')
GuiObject2D = require('Foxit.Classes.GuiObject2D')
TextLabel = require('Foxit.Classes.TextLabel')
task = require('Foxit.Core.task')


Foxit.Camera = Camera.new()
Foxit.Mouse = Mouse.new()
Foxit.Mouse.LoveImage = love.graphics.newImage('Foxit/Assets/Cursor/Idle.png')
Foxit.Mouse.Scale = Vector2.new(0.05, 0.05)
love.mouse.setVisible(false)

Foxit.log.info('Setting up Signals..')

Foxit.KeyPressed = Signal.new()
Foxit.KeyReleased = Signal.new()

-- // Callbacks
Foxit.log.info('Setting up Love Callbacks..')

function Foxit.love.update(dt)

    -- // Mouse
    local mx, my = love.mouse.getPosition()
    Foxit.Mouse.Position = Vector2.new(mx, my)



    -- // Other

    Renderer:Update(dt)
    SoundHandler:Update(dt)
    task.update(dt)
    Foxit.Living = Foxit.Living + dt
end

function Foxit.love.draw()
    Renderer:Draw()
end

function Foxit.love.keypressed(key, scancode, isrepeat)
    Foxit.KeyPressed:Fire(key:upper())
end

function Foxit.love.keyreleased(key, scancode)
    Foxit.KeyReleased:Fire(key:upper())
end

function Foxit.love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        Foxit.Mouse.LMB:Fire(false)
    elseif button == 2 then
        Foxit.Mouse.RMB:Fire(false)
    elseif button == 3 then

    end

end

function Foxit.love.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        Foxit.Mouse.LMB:Fire(true)
    elseif button == 2 then
        Foxit.Mouse.RMB:Fire(true)
    elseif button == 3 then

    end

end

function Foxit:GetRenderer()
    return Renderer
end

Renderer:SetWindowSize(1280, 720)
Renderer:SetVirtualSize(1280, 720)
Renderer:SetPixelPerfect(false)

_G.__introFinished = false

Foxit.log.info('Playing Intro..')
local IntroScript = Script.new('Foxit/Scripts/intro.lua')
IntroScript.Name = 'intro'

IntroScript:Run()

task.spawn(function()

    repeat task.wait(0.001)
    until _G.__introFinished

    Foxit.log.info('Intro Finished')
    Foxit.log.info('Running Main Script')
    local MainScript = Script.new('Game/main.lua')
    MainScript.Name = 'Main'

    MainScript:Run()

end)

return Foxit