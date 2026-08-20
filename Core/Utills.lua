local utils = {}

function utils.BuildLogFuncs(name)
    local t = {}

    function t.info(...)
        print(('[%s/INFO]: '):format(name) .. table.concat({...}, ' '))
    end

    function t.warn(...)
        print(('[%s/WARN]: '):format(name) .. table.concat({...}, ' '))
    end

    function t.error(...)
        print(('[%s/ERROR]: '):format(name) .. table.concat({...}, ' '))
    end

    return t
end

return utils