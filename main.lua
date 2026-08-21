local Foxit = {
    love = {}, -- Love Callbacks
    Living = 0,

    Collections = {Tags = {}},

    Sounds = {},
    Objects = {},
}

setmetatable(Foxit.Objects, {__mode = 'k'}) -- Weak 
setmetatable(Foxit.Sounds, {__mode = 'k'}) -- Weak =)))

_G.Foxit = Foxit

local utils = require('Foxit.Core.Utills'); Foxit.log = utils.BuildLogFuncs('main')
local Renderer = require('Foxit.Core.Renderer').new()
local SoundHandler = require('Foxit.Core.Handlers.SoundHandler')

Script = require('Foxit.Classes.Script')
Signal = require('Foxit.Classes.Signal')
Vector2 = require('Foxit.Classes.Vector2')
task = require('Foxit.Core.task')

Foxit.log.info('Setting up Signals..')

Foxit.KeyPressed = Signal.new()
Foxit.KeyReleased = Signal.new()

-- // Callbacks
Foxit.log.info('Setting up Love Callbacks..')

function Foxit.love.update(dt)
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

function Foxit:GetRenderer()
    return Renderer
end

function tick()
    return Foxit.Living
end

_G.__introFinished = false


local IntroScript = Script.new('Foxit/Scripts/intro.lua')
IntroScript.Name = 'intro'

IntroScript:Run()

task.spawn(function()

    repeat task.wait(0.001)
    until _G.__introFinished

    local MainScript = Script.new('Game/main.lua')
    MainScript.Name = 'Main'

    MainScript:Run()

end)

return Foxit