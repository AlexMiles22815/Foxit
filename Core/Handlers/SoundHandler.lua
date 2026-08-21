local SoundHandler = {}
SoundHandler.Channels = {
}

SoundHandler.MasterVolume = 1

local utils = require('Foxit.Core.Utills'); SoundHandler.log = utils.BuildLogFuncs('SoundHandler')

function SoundHandler:NewChannel(name)
    SoundHandler.Channels[name] = {
        Volume = 1
    }
    SoundHandler.log.info('New channel was created: '..name)
end

function SoundHandler:Update(dt)
    for _, sound in pairs(Foxit.Sounds) do
        local channelVolume = 1

        if sound.Channel then
            local channel = self.Channels[sound.Channel]

            if channel then
                channelVolume = channel.Volume
            end
        end

        sound:UpdateVolume(channelVolume * self.MasterVolume)
        sound:Update(dt)
    end
end

-- // SetUp

SoundHandler:NewChannel('main')

return SoundHandler