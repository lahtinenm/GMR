local function filter(list, predicate)
    local result = {}
    for index, item in ipairs(list) do
        if predicate(item) then
            table.insert(result, item)
        end
    end
    return result
end

local function findIndex(list, predicate)
    for index, item in ipairs(list) do
        if predicate(item) then
            return index
        end
    end
    return -1
end

local function isEqual(value)
    return function (value2)
        return value2 == value
    end
end

local function indexOf(list, value)
    return findIndex(list, isEqual(value))
end

local function find(list, predicate)
    local index = findIndex(list, predicate)
    local result
    if index == -1 then
        result = nil
    else
        result = list[index]
    end
    return result
end

local function includes(list, value)
    return find(list, function (value2)
        return value2 == value
    end) ~= nil
end

local function map(list, predicate)
    local result = {}
    for index, item in ipairs(list) do
        result[index] = predicate(item)
    end
    return result
end

local function reduce(list, predicate, initialValue)
    local value
    local initialIndex
    if initialValue == nil then
        value = list[1]
        initialIndex = 2
    else
        value = initialValue
        initialIndex = 1
    end
    for index = initialIndex, #list do
        value = predicate(value, list[index], list)
    end
    return value
end

local function all(list, predicate)
    for index, item in ipairs(list) do
        if not predicate(item) then
            return false
        end
    end
    return true
end

local function copy(list)
    local result = {}
    for index, item in ipairs(list) do
        result[index] = item
    end
    return result
end

local function concat(...)
    local result = {}
    for listIndex, list in ipairs({...}) do
        for index, item in ipairs(list) do
            table.insert(result, item)
        end
    end
    return result
end

local function append(list, listToAppend)
    for index, item in ipairs(listToAppend) do
        table.insert(list, item)
    end
end

local function max(list, predicate)
    local result
    if #list == 0 then
        result = nil
    else
        local maxIndex = 1
        for index, item in ipairs(list) do
            if predicate(item) > predicate(list[maxIndex]) then
                maxIndex = index
            end
        end
        result = list[maxIndex]
    end
    return result
end

local function count(list, predicate)
    return #filter(list, predicate)
end

Array = {
    filter = filter,
    find = find,
    includes = includes,
    map = map,
    reduce = reduce,
    all = all,
    copy = copy,
    concat = concat,
    append = append,
    max = max,
    findIndex = findIndex,
    indexOf = indexOf,
    count = count
}
