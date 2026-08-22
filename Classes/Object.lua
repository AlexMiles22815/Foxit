local Object = {}
Object.__index = Object
Object.__type = 'Object'

function Object.new()
    local self = {}; setmetatable(self, Object)
    
    self.Name = 'Object'
    self.Tags = {}
    self.Attributes = {}

    if Foxit.Objects then
        table.insert(Foxit.Objects, self)
    end

    return self
end

function Object:HasTag(tag)
    return self.Tags[tag] ~= nil
end

function Object:AddTag(tag)
    self.Tags[tag] = true
end

function Object:RemoveTag(tag)
    self.Tags[tag] = nil
end

function Object:GetAttribute(attr)
    return self.Attributes[attr]
end

function Object:SetAttribute(attr, val)
    self.Attributes[attr] = val
end

return Object
