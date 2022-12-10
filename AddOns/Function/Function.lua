local function partial(fn, ...)
  local partialArguments = { ... }
  return function(...)
    return fn(unpack(partialArguments), ...)
  end
end

local function curry(fn, numberOfParameters)
  local numberOfParametersType = type(numberOfParameters)
  if numberOfParametersType ~= 'number' then
    print('Invalid argument: numberOfParameters. ' .. numberOfParametersType .. ' given instead of number.')
    return
  end

  local numberOfParametersPassed = 0
  local arguments = {}

  local curriedFunction
  curriedFunction = function(...)
    local passedArguments = { ... }
    numberOfParametersPassed = numberOfParametersPassed + #passedArguments
    Array.append(arguments, passedArguments)
    if numberOfParametersPassed == numberOfParameters then
      return fn(unpack(arguments))
    else
      return curriedFunction
    end
  end

  return curriedFunction
end

local function noOperation()

end

local function identity(value)
  return value
end

local function alwaysTrue()
  return true
end

local function isTrue(value)
  return not not value
end

local function returnValue(value)
  return function()
    return value
  end
end

local function once(fn)
  local hasBeenRun = false
  return function(...)
    if not hasBeenRun then
      hasBeenRun = true
      return fn(...)
    end
  end
end

local function alwaysFalse()
  return false
end

Function = {
  partial = partial,
  curry = curry,
  noOperation = noOperation,
  identity = identity,
  alwaysTrue = alwaysTrue,
  isTrue = isTrue,
  returnValue = returnValue,
  once = once,
  alwaysFalse = alwaysFalse
}
