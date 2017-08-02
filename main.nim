import strutils

const w = 4
const processorCount = 4

type
  squareArray = array[w, array[w, int]]

proc createField() : squareArray =
  var field2D: squareArray
  let cellsPerProcessor = (w * w) div processorCount
  for y in 0..<w:
    for x in 0..<w:
      field2D[y][x] = min(processorCount -1, (y * w + x) div cellsPerProcessor)
  return field2D

proc rank(field2D : squareArray) : int =
  var sum = 0
  for y in 0..<w:
    for x in 0..<w:
      let v = field2D[y][x]

      let y2 = if y <= 0: 0 else: y - 1
      let y3 = if y >= w - 1: w - 1 else: y + 1
      let x4 = if x <= 0: 0 else: x - 1
      let x5 = if x >= w - 1: w - 1 else: x + 1

      if v != field2D[y2][x]: sum += 1
      if v != field2D[y3][x]: sum += 1
      if v != field2D[y][x4]: sum += 1
      if v != field2D[y][x5]: sum += 1
  return sum

proc printField(field2D : squareArray) =
  var line: string
  for y in 0..<w:
    line = ""
    for x in 0..<w:
      line &= intToStr(field2D[y][x]) & " "
    echo line
  echo "rank: " & intToStr(rank(field2D))

proc at(field2D : squareArray, x : int, y : int) : int =
  var x = x; var y = y
  if (x < 0 and y < 0) or (x >= w and y >= w):
    raise newException(IndexError, "out of bounds")
  while x <  0: x += w; y -= 1
  while x >= w: x -= w; y += 1
  if y < 0 or y >= w:
    raise newException(IndexError, "out of bounds")
  return field2D[y][x]

proc setAt(field2D : var squareArray, x : int, y : int, v : int) =
  var x = x; var y = y
  if (x < 0 and y < 0) or (x >= w and y >= w):
    raise newException(IndexError, "out of bounds")
  while x <  0: x += w; y -= 1
  while x >= w: x -= w; y += 1
  if y < 0 or y >= w:
    raise newException(IndexError, "out of bounds")
  field2D[y][x] = v

proc swap(field2D : var squareArray, x1 : int, y1 : int, x2 : int, y2 : int) =
  var tmp = at(field2D, x2, y2)
  setAt(field2D, x2, y2, at(field2D, x1 - 1, y1))
  setAt(field2D, x1 - 1, y1, tmp)

proc nextPermutation(field2D : var squareArray) : bool =

  # Find non - increasing suffix
  var x1 = w - 1
  var y1 = w - 1
  while ((x1 > 0 or y1 > 0) and at(field2D, x1 - 1, y1) >= at(field2D, x1, y1)):
    x1 -= 1
    if x1 < 0:
      x1 += w
      y1 -= 1
  if (x1 <= 0 and y1 <= 0):
    return false

  # Find successor to pivot
  var x2 = w - 1
  var y2 = w - 1
  var pivot = at(field2D, x1 - 1, y1)
  while (field2D[y2][x2] <= pivot):
    x2 -= 1
    if (x2 < 0):
      x2 += w
      y2 -= 1

  # Swap elements
  swap(field2D, x1, y1, x2, y2)

  # Reverse suffix
  x1 += 1
  if (x1 >= w):
    x1 -= w
    y1 += 1
  x2 = w - 1
  y2 = w - 1
  while (y2 > y1 or (y2 == y1 and x2 >= x1)): # equal to y2 * w + x2 >= y1 * w + x1
    swap(field2D, x1, y1, x2, y2)
    x1 += 1
    if (x1 >= w):
      x1 -= w
      y1 += 1
    x2 -= 1
    if (x2 < 0):
      x2 += w
      y2 -= 1

  return true

var field2D = createField()
var count = 0
var bestRank = rank(field2D)

while nextPermutation(field2D):
  if field2D[0][0] != 0:
    break
  count += 1

  var newRank = rank(field2D)
  if newRank < bestRank:
    bestRank = newRank
    printField(field2D)

echo "count: ", count
echo "best rank: ", bestRank
