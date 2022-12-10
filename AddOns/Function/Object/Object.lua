local function copy(object)
    local result = {}
    for key, value in pairs(object) do
        result[key] = value
    end
    return result
end

local function keys(object)
    local result = {}
    for key, _ in pairs(object) do
        table.insert(result, key)
    end
    return result
end

Object = {
    copy = copy,
    keys = keys
}
