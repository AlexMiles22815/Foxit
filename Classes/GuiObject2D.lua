local GuiObject2D = {}
GuiObject2D.__index = GuiObject2D

local Object2D = require('Foxit.Classes.Object2D')
setmetatable(GuiObject2D, Object2D)

function GuiObject2D.new(IsCore)
    local self = Object2D.new(); setmetatable(self, GuiObject2D)
    self.IsGui = true
    self.Name = 'GuiObject2D'

    if IsCore then
        table.insert(Foxit.CoreGui, self)
    else
        table.insert(Foxit.Gui, self)
    end

    return self
end



return GuiObject2D