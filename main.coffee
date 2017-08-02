w = 4
processorCount = 4

createField = () ->
  field2D = []
  cellsPerProcessor = (w * w) // processorCount
  for y in [0...w]
    field2D.push([])
    for x in [0...w]
      field2D[y].push(Math.min(processorCount-1, (y * w + x) // cellsPerProcessor))
  return field2D

rank = (field2D) ->
  sum = 0
  for y in [0...w]
    for x in [0...w]
      v = field2D[y][x]

      y2 = if y <= 0 then 0 else y - 1
      y3 = if y >= w - 1 then w - 1 else y + 1
      x4 = if x <= 0 then 0 else x - 1
      x5 = if x >= w - 1 then w - 1 else x + 1

      sum += 1 if v != field2D[y2][x]
      sum += 1 if v != field2D[y3][x]
      sum += 1 if v != field2D[y][x4]
      sum += 1 if v != field2D[y][x5]
  return sum

printField = (field2D) ->
  for y in [0...w]
    line = ""
    for x in [0...w]
      line += field2D[y][x] + " "
    console.log(line)
  console.log("rank: ", rank(field2D))

at = (field2D, x, y) ->
  throw "out of bounds" if (x < 0 and y < 0) or (x >= w and y >= w)
  while x <  0
    x += w
    y -= 1
  while x >= w
    x -= w
    y += 1
  throw "out of bounds" if y < 0 or y >= w
  return field2D[y][x]

setAt = (field2D, x, y, v) ->
  throw "out of bounds" if (x < 0 and y < 0) or (x >= w and y >= w)
  while x <  0
    x += w
    y -= 1
  while x >= w
    x -= w
    y += 1
  throw "out of bounds" if y < 0 or y >= w
  field2D[y][x] = v

swap = (field2D, x1, y1, x2, y2) ->
  tmp = at(field2D, x2, y2)
  setAt(field2D, x2, y2, at(field2D, x1 - 1, y1))
  setAt(field2D, x1 - 1, y1, tmp)

nextPermutation = (field2D) ->

  # Find non - increasing suffix
  x1 = w - 1
  y1 = w - 1
  while ((x1 > 0 or y1 > 0) and at(field2D, x1 - 1, y1) >= at(field2D, x1, y1))
    x1 -= 1
    if x1 < 0
      x1 += w
      y1 -= 1
  if (x1 <= 0 and y1 <= 0)
    return false

  # Find successor to pivot
  x2 = w - 1
  y2 = w - 1
  pivot = at(field2D, x1 - 1, y1)
  while (field2D[y2][x2] <= pivot)
    x2 -= 1
    if (x2 < 0)
      x2 += w
      y2 -= 1

  # Swap elements
  swap(field2D, x1, y1, x2, y2)

  # Reverse suffix
  x1 += 1
  if (x1 >= w)
    x1 -= w
    y1 += 1
  x2 = w - 1
  y2 = w - 1
  while (y2 > y1 or (y2 == y1 and x2 >= x1)) # equal to y2 * w + x2 >= y1 * w + x1
    swap(field2D, x1, y1, x2, y2)
    x1 += 1
    if (x1 >= w)
      x1 -= w
      y1 += 1
    x2 -= 1
    if (x2 < 0)
      x2 += w
      y2 -= 1

  return true

field2D = createField()
count = 0
bestRank = rank(field2D)

while nextPermutation(field2D)
  if field2D[0][0] != 0
    break
  count += 1

  newRank = rank(field2D)
  if newRank < bestRank
    bestRank = newRank
    printField(field2D)

console.log("count: ", count)
console.log("best rank: ", bestRank)
