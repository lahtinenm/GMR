local function length(list)
  local length = 0
  for key in pairs(list) do
    if type(key) == 'number' and key > length then
      length = key
    end
  end
  return length
end

local function filter(list, predicate)
  local result = Array.create()
  for index = 1, length(list) do
    local item = list[index]
    if predicate(item) then
      table.insert(result, item)
    end
  end
  return result
end

local function findIndex(list, predicate)
  for index = 1, length(list) do
    local item = list[index]
    if predicate(item) then
      return index
    end
  end
  return -1
end

local function seemsEqual(a, b)
  if type(a) == 'number' and type(b) == 'number' then
    return Float.seemsCloseBy(a, b)
  else
    return a == b
  end
end

local function indexOf(list, value)
  return findIndex(list, seemsEqual(value))
end

local function find(list, predicate)
  local index = findIndex(list, predicate)
  local result
  if index == -1 then
    result = nil
  else
    result = list[index]
  end
  return result, index
end

local function includes(list, value)
  return find(list, function(value2)
    return value2 == value
  end) ~= nil
end

local function map(list, predicate)
  local result = Array.create()
  for index = 1, length(list) do
    local item = list[index]
    result[index] = predicate(item, index)
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
  for index = initialIndex, length(list) do
    value = predicate(value, list[index], list)
  end
  return value
end

local function all(list, predicate)
  for index = 1, length(list) do
    local item = list[index]
    if not predicate(item) then
      return false
    end
  end
  return true
end

local function copy(list)
  local result = Array.create()
  for index = 1, length(list) do
    local item = list[index]
    result[index] = item
  end
  return result
end

local function concat(...)
  local result = Array.create()
  local lists = { ... }
  for index = 1, length(lists) do
    local list = lists[index]
    for index2 = 1, length(list) do
      local item = list[index2]
      table.insert(result, item)
    end
  end
  return result
end

local function append(array, listToAppend)
  for index = 1, length(listToAppend) do
    local item = listToAppend[index]
    table.insert(array, item)
  end
  return array
end

local function extreme(list, predicate, extremeFn)
  local result
  if length(list) == 0 then
    result = nil
  else
    local extremeIndex = 1
    for index = 1, length(list) do
      local item = list[index]
      if extremeFn(predicate(item), predicate(list[extremeIndex])) then
        extremeIndex = index
      end
    end
    result = list[extremeIndex]
  end
  return result
end

local function smallerThan(a, b)
  return a < b
end

local function min(list, predicate)
  return extreme(list, predicate, smallerThan)
end

local function greaterThan(a, b)
  return a > b
end

local function max(list, predicate)
  return extreme(list, predicate, greaterThan)
end

local function maxCompare(list, compare)
  local result
  if length(list) == 0 then
    result = nil
  else
    local maxIndex = 1
    for index = 1, length(list) do
      local item = list[index]
      if compare(item, list[maxIndex]) then
        maxIndex = index
      end
    end
    result = list[maxIndex]
  end
  return result
end

local function count(list, predicate)
  return length(filter(list, predicate))
end

local function any(list, predicate)
  for index = 1, length(list) do
    local item = list[index]
    if predicate(item) then
      return true
    end
  end
  return false
end

local function groupBy(list, predicate)
  local groups = {}
  for index = 1, length(list) do
    local value = list[index]
    local key = predicate(value)
    if not groups[key] then
      groups[key] = {}
    end
    table.insert(groups[key], value)
  end
  return groups
end

local function pickWhile(list, condition)
  local picks = {}
  local index = 1
  while index <= length(list) and condition(picks, list[index]) do
    table.insert(picks, list[index])
    index = index + 1
  end
  return picks
end

local function slice(list, startIndex, length)
  if length == nil then
    length = Array.length(list) - startIndex + 1
  end
  local endIndex = startIndex + length - 1
  local result = Array.create()
  for index = startIndex, endIndex do
    table.insert(result, list[index])
  end
  return result
end

local function unique(list)
  local inList = {}
  local result = Array.create()
  for index = 1, length(list) do
    local item = list[index]
    if not inList[item] then
      inList[item] = true
      table.insert(result, item)
    end
  end
  return result
end

local function forEach(list, predicate)
  for index = 1, length(list) do
    local value = list[index]
    predicate(value, index)
  end
  return list
end

local function equals(listA, listB, predicate)
  predicate = predicate or Function.identity

  local lengthOfListA = Array.length(listA)

  if lengthOfListA ~= Array.length(listB) then
    return false
  end

  local length = lengthOfListA
  for index = 1, length do
    if not seemsEqual(predicate(listA[index]), predicate(listB[index])) then
      return false
    end
  end

  return true
end

local function flat(list)
  local result = Array.create()
  for index = 1, length(list) do
    local element = list[index]
    if Array.isArray(element) then
      for index = 1, length(element) do
        local element2 = element[index]
        table.insert(result, element2)
      end
    else
      table.insert(result, element)
    end
  end
  return result
end

local function flatMap(list, predicate)
  return Array.flat(Array.map(list, predicate))
end

local function isNumber(value)
  return type(value) == 'number'
end

local function areAllKeysNumbers(table)
  return Array.all(Object.keys(table), isNumber)
end

local function isArray(list)
  return type(list) == 'table' and areAllKeysNumbers(list)
end

local function isArrayWithSubsequentIndexes(list)
  return isArray(list) and length(list) == #list
end

local function selectTrue(list)
  return Array.filter(list, Function.isTrue)
end

local function generateNumbers(from, to, interval)
  local numbers = Array.create()
  for number = from, to, interval do
    table.insert(numbers, number)
  end
  return numbers
end

local function isTrueForAllInInterval(from, to, interval, predicate)
  local values = Array.generateNumbers(from, to, interval)
  return Array.all(values, predicate)
end

local function hasElements(array)
  return Boolean.toBoolean(next(array))
end

local function isEmpty(array)
  return not hasElements(array)
end

local function remove(array, element)
  local equals = Function.partial(seemsEqual, element)
  local index
  repeat
    index = findIndex(array, equals)
    if index ~= -1 then
      table.remove(array, index)
    end
  until index == -1
  return array
end

local function removeFirstOccurence(array, element)
  local equals = Function.partial(seemsEqual, element)
  local index = findIndex(array, equals)
  if index ~= -1 then
    table.remove(array, index)
  end
  return array
end

local function create(table)
  local array
  if table then
    array = Array.copy(table)
  else
    array = {}
  end
  setmetatable(array, { __index = Array })
  return array
end

Array = {
  create = create,
  filter = filter,
  find = find,
  includes = includes,
  map = map,
  reduce = reduce,
  all = all,
  copy = copy,
  concat = concat,
  append = append,
  extreme = extreme,
  min = min,
  max = max,
  maxCompare = maxCompare,
  findIndex = findIndex,
  indexOf = indexOf,
  count = count,
  any = any,
  groupBy = groupBy,
  pickWhile = pickWhile,
  slice = slice,
  unique = unique,
  forEach = forEach,
  equals = equals,
  flat = flat,
  flatMap = flatMap,
  isArray = isArray,
  selectTrue = selectTrue,
  length = length,
  generateNumbers = generateNumbers,
  isTrueForAllInInterval = isTrueForAllInInterval,
  hasElements = hasElements,
  isEmpty = isEmpty,
  isArrayWithSubsequentIndexes = isArrayWithSubsequentIndexes,
  remove = remove,
  removeFirstOccurence = removeFirstOccurence
}
