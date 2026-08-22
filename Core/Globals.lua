function tick()
    return Foxit.Living
end

function typeof(item)
    local meta = getmetatable(item)
    local metaType = meta.__type

    if metaType then return metaType else return type(item) end
end

function math.clamp(val, lower, upper)
    assert(val and lower and upper)
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end