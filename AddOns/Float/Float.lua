Float = {}

function Float.seemsCloseBy(a, b)
  return math.abs(b - a) < 0.0000000001
end
