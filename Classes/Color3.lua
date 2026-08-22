local Color3 = {}
Color3.__index = Color3
Color3.__type = 'Color3'

function Color3.new(r, g, b)
    local self = {}; setmetatable(self, Color3)

    self.R = r or 0
    self.G = g or 0
    self.B = b or 0

    return self
end

function Color3.__add(self, other)
    assert(typeof(other) == 'Color3', 'wrong type')

    local new = Color3.new()
    new.R = self.R + other.R
    new.G = self.G + other.G
    new.B = self.B + other.B

    return new
end

function Color3.__sub(self, other)
    assert(typeof(other) == 'Color3', 'wrong type')

    local new = Color3.new()
    new.R = self.R - other.R
    new.G = self.G - other.G
    new.B = self.B - other.B

    return new
end

function Color3:ReturnRGB()
    return self.R, self.G, self.B
end

return Color3