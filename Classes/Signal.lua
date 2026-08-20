local unpack = table.unpack or unpack

local Signal = {}
Signal.__index = Signal

function Signal.new()
    local self = {}; setmetatable(self, Signal)
    
    self.Connections = {}


    return self
end

function Signal:Fire(...)
    
    for i, connection in pairs(self.Connections) do
        if connection.Active and connection.Function then
            if connection.Once then
                connection:Disconnect()
            end
            connection.Function(...)
        end
    end

end

function Signal:Connect(f)

    local SignalObj = self
    local ConnectionObj = {}
    ConnectionObj.Function = f
    ConnectionObj.Once = false
    ConnectionObj.Active = true

    function ConnectionObj:Disconnect()
        self.Active = false

        for i, conn in pairs(SignalObj.Connections) do
            if conn == ConnectionObj then
                table.remove(SignalObj.Connections, i)
                break
            end
        end

    end


    table.insert(self.Connections, ConnectionObj)

    return ConnectionObj
end

function Signal:Once(f)
    local Conn = self:Connect(f)
    Conn.Once = true

    return Conn
end

function Signal:Wait()
    local finished = false
    local returned = {}
    
    self:Once(function(...)
        finished = true
        returned = {...}
    end)

    while not finished do
        task.wait(0.01)
    end

    return unpack(returned)
end

return Signal