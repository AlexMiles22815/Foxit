local Object = {}
Object.__index = Object

function Object.new()
    local self = {}; setmetatable(self, Object)
    
    self.Name = 'Object'

    if Foxit.Objects then
        table.insert(Foxit.Objects, self)
    end

    return self
end

return Object
