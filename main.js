const w = 4
const processorCount = 4

function createField() {
  field2D = [];
  cellsPerProcessor = Math.floor((w * w) / processorCount);
  for (y = 0; y < w; y++) {
    field2D[y] = [];
    for (x = 0; x < w; x++) {
      field2D[y][x] = Math.min(processorCount -1, Math.floor((y * w + x) / cellsPerProcessor));
    }
  }
  return field2D;
}

function rank(field2D) {
  sum = 0;
  for (y = 0; y < w; y++) {
    for (x = 0; x < w; x++) {
      v = field2D[y][x];

      y2 = y <= 0 ? 0 : y - 1;
      y3 = y >= w - 1 ? w - 1 : y + 1;
      x4 = x <= 0 ? 0 : x - 1;
      x5 = x >= w - 1 ? w - 1 : x + 1;

      if (v != field2D[y2][x]) sum++;
      if (v != field2D[y3][x]) sum++;
      if (v != field2D[y][x4]) sum++;
      if (v != field2D[y][x5]) sum++;
    }
  }
  return sum;
}

function printField(field2D) {
  for (y = 0; y < w; y++) {
    line = "";
    for (x = 0; x < w; x++) {
      line += field2D[y][x] + " ";
    }
    console.log(line);
  }
  console.log("rank: ", rank(field2D));
}

function at(field2D, x, y) {
  if ((x < 0 && y < 0) || (x >= w && y >= w)) {
    throw "out of bounds";
  }
  while (x < 0) { x += w; y--; }
  while (x >= w) { x -= w; y++; }
  if (y < 0 || y >= w) {
    throw "out of bounds";
  }
  return field2D[y][x];
}

function setAt(field2D, x, y, v) {
  if ((x < 0 && y < 0) || (x >= w && y >= w)) {
    throw "out of bounds";
  }
  while (x < 0) { x += w; y--; }
  while (x >= w) { x -= w; y++; }
  if (y < 0 || y >= w) {
    throw "out of bounds";
  }
  field2D[y][x] = v;
}

function swap(field2D, x1, y1, x2, y2) {
  tmp = at(field2D, x2, y2);
  setAt(field2D, x2, y2, at(field2D, x1 - 1, y1));
  setAt(field2D, x1 - 1, y1, tmp);
}

function nextPermutation(field2D) {

  // Find non - increasing suffix
  x1 = w - 1;
  y1 = w - 1;
  while ((x1 > 0 || y1 > 0) && at(field2D, x1 - 1, y1) >= at(field2D, x1, y1)) {
    x1--;
    if (x1 < 0) {
      x1 += w;
      y1--;
    }
  }
  if (x1 <= 0 && y1 <= 0) {
    return false;
  }

  // Find successor to pivot
  x2 = w - 1;
  y2 = w - 1;
  pivot = at(field2D, x1 - 1, y1);
  while (field2D[y2][x2] <= pivot) {
    x2--;
    if (x2 < 0) {
      x2 += w;
      y2--;
    }
  }

  // Swap elements
  swap(field2D, x1, y1, x2, y2);

  // Reverse suffix
  x1++;
  if (x1 >= w) {
    x1 -= w;
    y1++;
  }
  x2 = w - 1;
  y2 = w - 1;
  while (y2 > y1 || (y2 == y1 && x2 >= x1)) { // equal to y2 * w + x2 >= y1 * w + x1
    swap(field2D, x1, y1, x2, y2);
    x1++;
    if (x1 >= w) {
      x1 -= w;
      y1++;
    }
    x2--;
    if (x2 < 0) {
      x2 += w;
      y2--;
    }
  }

  return true;
}


field2D = createField();
count = 0;
bestRank = rank(field2D);

while (nextPermutation(field2D)) {
  if (field2D[0][0] != 0) {
    break;
  }
  count++;

  newRank = rank(field2D);
  if (newRank < bestRank) {
    bestRank = newRank;
    printField(field2D);
  }
}

console.log("count: " + count);
console.log("best rank: " + bestRank);