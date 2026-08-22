local TextLabel = {}
TextLabel.__index = TextLabel

local GuiObject2D = require('Foxit.Classes.GuiObject2D')
setmetatable(TextLabel, GuiObject2D)

function TextLabel.new(isCore)
    local self = GuiObject2D.new(isCore); setmetatable(self, TextLabel)

    self.Name = 'TextLabel'
    self.Text = 'TextLabel'

    self.TextSize = 16
    self.Font = nil
    self.TextTransparency = 0
    self.BackgroundTransparency = 0

    self.TextColor = Color3.new()
    self.BackgroundColor = Color3.new()    

    return self
end


return TextLabel