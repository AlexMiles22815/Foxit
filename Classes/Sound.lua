local Sound = {}
Sound.__index = Sound

local Object = require('Foxit.Classes.Object')
local Signal = require('Foxit.Classes.Signal')
setmetatable(Sound, Object)

function Sound.new(path)
    local self = {}
    setmetatable(self, Sound)

    self.LoveSource = nil

    self.TimeLength = 0
    self.TimePosition = 0

    self.Playing = false
    self.Channel = 'main'

    self.Volume = 1
    self.FinalVolume = 1

    self.Looped = false

    self._StoppedManually = false

    self.Finished = Signal.new()

    if path then
        self:Load(path)
    end

    table.insert(Foxit.Sounds, self)

    return self
end

function Sound:Load(path)
    if self.LoveSource then
        self.LoveSource:stop()
        self.LoveSource:release()
    end

    self.LoveSource = love.audio.newSource(path, "static")

    self.TimeLength = self.LoveSource:getDuration()
    self.TimePosition = 0

    self.LoveSource:setLooping(self.Looped)

    self:ApplyVolume()
end

function Sound:ApplyVolume()
    if not self.LoveSource then
        return
    end

    self.LoveSource:setVolume(self.FinalVolume)
end

function Sound:UpdateVolume(masterAndChannel)
    self.FinalVolume = self.Volume * masterAndChannel

    self:ApplyVolume()
end

function Sound:Play()
    if not self.LoveSource then
        return
    end

    self.LoveSource:play()
    self.Playing = true
end

function Sound:Pause()
    if not self.LoveSource then
        return
    end

    self.LoveSource:pause()
    self.Playing = false
end

function Sound:Resume()
    if not self.LoveSource then
        return
    end

    self.LoveSource:play()
    self.Playing = true
end

function Sound:Stop()
    if not self.LoveSource then
        return
    end

    self.LoveSource:stop()

    self.Playing = false
    self.TimePosition = 0
end

function Sound:SetVolume(volume)
    self.Volume = math.max(0, volume)
end

function Sound:SetChannel(channel)
    self.Channel = channel
end

function Sound:SetLooped(looped)
    self.Looped = looped

    if self.LoveSource then
        self.LoveSource:setLooping(looped)
    end
end

function Sound:Update(dt)
    if not self.LoveSource then
        return
    end

    self.Playing = self.LoveSource:isPlaying()
    self.TimePosition = self.LoveSource:tell()

    if self.Playing then
        self.TimeLength = self.LoveSource:getDuration()
    end
end

function Sound:Destroy()
    if self.LoveSource then
        self.LoveSource:stop()
        self.LoveSource:release()
        self.LoveSource = nil
    end

    for i, sound in ipairs(Foxit.Sounds) do
        if sound == self then
            table.remove(Foxit.Sounds, i)
            break
        end
    end
end

return Sound