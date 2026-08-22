function tick()
    return Foxit.Living
end

function typeof(item)
    local meta = getmetatable(item)
    local metaType = meta.__type

    if metaType then return metaType else return type(item) end
end