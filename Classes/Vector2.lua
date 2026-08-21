local Vector2 = {}

local Meta = {
    __index = Vector2,
    __type = 'Vector2',

    __tostring = function(self)
        local m = 'Vector2(%s, %s)'
        return string.format(m, self.X, self.Y)
    end,

    __add = function(self, other)
        assert(xtype(other) == 'Vector2' or xtype(other) == 'number', 'unsupported type')
        if xtype(other) == 'number' then
            return Vector2.new(
                self.X + other,
                self.Y + other
            )
        else
            return Vector2.new(
                self.X + other.X,
                self.Y + other.Y
            )
        end
    end,

    __sub = function(self, other)
        assert(xtype(other) == 'Vector2' or xtype(other) == 'number', 'unsupported type')
        if xtype(other) == 'number' then
            return Vector2.new(
                self.X - other,
                self.Y - other
            )
        else
            return Vector2.new(
                self.X - other.X,
                self.Y - other.Y
            )
        end
    end,

    __mul = function(self, other)
        assert(xtype(other) == 'Vector2' or xtype(other) == 'number', 'unsupported type')
        if xtype(other) == 'number' then
            return Vector2.new(
                self.X * other,
                self.Y * other
            )
        else
            return Vector2.new(
                self.X * other.X,
                self.Y * other.Y
            )
        end
    end,

    __div = function(self, other)
        assert(xtype(other) == 'Vector2' or xtype(other) == 'number', 'unsupported type')
        if xtype(other) == 'number' then
            return Vector2.new(
                self.X / other,
                self.Y / other
            )
        else
            return Vector2.new(
                self.X / other.X,
                self.Y / other.Y
            )
        end
    end,

    __unm = function(self)
        return Vector2.new(
                -self.X,
                -self.Y
            )
    end,

    __eq = function(self, other)
        assert(xtype(other) == 'Vector2', 'not Vector2')
        if self.X == other.X and self.Y == other.Y then return true else return false end
    end

}   


function Vector2.new(X, Y)
    local self = setmetatable({}, Meta)
    self.X = X or 0
    self.Y = Y or 0
    return self
end

return Vector2