local function add(a, b)
  return a + b
end

local function sum(list)
  return Array.reduce(list, add, 0)
end

local function multiply(a, b)
  return a * b
end

local function product(list)
  return Array.reduce(list, multiply, 1)
end

local function round(value, numberOfDigitsAfterTheDecimalSeparator)
  if numberOfDigitsAfterTheDecimalSeparator == nil then
    numberOfDigitsAfterTheDecimalSeparator = 0
  end
  local a = 10 ^ numberOfDigitsAfterTheDecimalSeparator
  return math.floor(value * a + 0.5) / a
end

local function sign(value)
  if value < 0 then
    return -1
  elseif value == 0 then
    return 0
  else
    return 1
  end
end

local function euclideanDistance(nodeA, nodeB)
  return math.sqrt(
    math.pow(nodeB.x - nodeA.x, 2) +
      math.pow(nodeB.y - nodeA.y, 2) +
      math.pow(nodeB.z - nodeA.z, 2)
  )
end

local function euclideanDistance2D(nodeA, nodeB)
  return math.sqrt(
    math.pow(nodeB.x - nodeA.x, 2) +
      math.pow(nodeB.y - nodeA.y, 2)
  )
end

local function manhattanDistance(nodeA, nodeB)
  return (
    math.abs(nodeB.x - nodeA.x) +
      math.abs(nodeB.y - nodeA.y) +
      math.abs(nodeB.z - nodeA.z)
  )
end

local function manhattanDistance2D(nodeA, nodeB)
  return (
    math.abs(nodeB.x - nodeA.x) +
      math.abs(nodeB.y - nodeA.y)
  )
end

Math = {
  add = add,
  sum = sum,
  multiply = multiply,
  product = product,
  round = round,
  sign = sign,
  euclideanDistance = euclideanDistance,
  euclideanDistance2D = euclideanDistance2D,
  manhattanDistance = manhattanDistance,
  manhattanDistance2D = manhattanDistance2D
}
