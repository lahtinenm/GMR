local function areTablesEqual(a, b)
    local aKeys = Object.keys(a)
    local bKeys = Object.keys(b)
    if #aKeys ~= #bKeys then
        return false
    end
    local allKeys = Array.concat(aKeys, bKeys)
    for _, key in ipairs(allKeys) do
        if a[key] ~= b[key] then
            return false
        end
    end

    return true
end

local function equals(a, b)
    if type(a) == 'table' and type(b) == 'table' then
        return areTablesEqual(a, b)
    else
        -- TODO: Extend as required
        return false
    end
end

local function expect(value)
    return {
        toEqual = function (expectedValue)
            return equals(value, expectedValue)
        end
    }
end

Testing = {
    expect = expect
}
