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

local function values(object)
  local result = {}
  for _, value in pairs(object) do
    table.insert(result, value)
  end
  return result
end

local function entries(object)
  local list = {}
  for key, value in pairs(object) do
    table.insert(list, { key = key, value = value })
  end
  return list
end

local function equals(a, b)
  local keysA = Set.create(keys(a))
  local keysB = Set.create(keys(b))
  if not Set.equals(keysA, keysB) then
    return false
  end
  local keys = keysA
  for key in Set.iterator(keys) do
    if a[key] ~= b[key] then
      return false
    end
  end
  return true
end

local function assignObject(object, objectB)
  for key, value in pairs(objectB) do
    object[key] = value
  end
end

local function assign(object, ...)
  local objects = { ... }
  for _, objectB in ipairs(objects) do
    assignObject(object, objectB)
  end
  return object
end

local function count(object)
  local count = 0
  for _, _ in pairs(object) do
    count = count + 1
  end
  return count
end

local function every(object, prefix)
  for key, value in pairs(object) do
    if not prefix(value, key) then
      return false
    end
  end

  return true
end

local function fromEntries(entries)
  local object = {}
  for _, entry in ipairs(entries) do
    object[entry.key] = entry.value
  end
  return object
end

local function isEmpty(object)
  return not next(object)
end

local function remove(object, key)
  object[key] = nil
end

local function hasKeys(object)
  return Boolean.toBoolean(next(object))
end

Object = {
  copy = copy,
  keys = keys,
  values = values,
  entries = entries,
  equals = equals,
  assign = assign,
  count = count,
  every = every,
  fromEntries = fromEntries,
  isEmpty = isEmpty,
  remove = remove,
  hasKeys = hasKeys
}

Object2 = Object
