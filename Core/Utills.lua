local utils = {}
local config = require('Foxit.config')


function utils.BuildLogFuncs(name)
    local t = {}

    function t.info(...)
        if config.hideEngineLogs then return end
        print(('[%s/INFO]: '):format(name) .. table.concat({...}, ' '))
    end

    function t.warn(...)
        if config.hideEngineLogs then return end
        print(('[%s/WARN]: '):format(name) .. table.concat({...}, ' '))
    end

    function t.error(...)
        print(('[%s/ERROR]: '):format(name) .. table.concat({...}, ' '))
    end

    return t
end

function utils.drawHexagon(mode, x, y, radius)
    local vertices = {}
    for i = 1, 6 do
        local angle = (i - 1) * math.pi / 3
        table.insert(vertices, x + radius * math.cos(angle))
        table.insert(vertices, y + radius * math.sin(angle))
    end
    love.graphics.polygon(mode, vertices)
end



return utils