let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync('input17test');

// Test input
// let [minX, maxX, minY, maxY] = [20, 30, -10, -5]
// Real input
let [minX, maxX, minY, maxY] = [102, 157, -146, -90]

// Part 1
console.log(minY * (minY + 1) / 2)

// Part 2
function howFar(dy, i) {
  // How far will you get with an initial velocity of dy and i steps?
  return (i + 1) * (2 * dy - i) / 2;
}

let ySteps = {}
for (dy = -minY; dy > minY - 1; dy--) {
  let i = 0;
  while (howFar(dy, i) > maxY) {
    i++
  }
  let minI = i
  while (howFar(dy, i) >= minY) {
    i++
  }
  if (i > minI) {
    ySteps[dy] = [minI + 1, i]
  }
}

let xSteps = {}
for (dx = 0; dx <= maxX; dx++) {
  let i = 0;
  while (i <= dx && howFar(dx, i) < minX) {
    i++
  }
  let minI = i
  while (i <= dx && howFar(dx, i) <= maxX) {
    i++
  }
  if (i > minI) {
    if (i >= dx) {
      xSteps[dx] = [minI + 1, 1234567890]
    } else {
      xSteps[dx] = [minI + 1, i]
    }
  }
}

let count = 0
for (let x in xSteps) {
  for (let y in ySteps) {
    let [a, b] = xSteps[x]
    let [c, d] = ySteps[y]
    if (b < c || d < a) {
      continue
    }
    count++
  }
}
console.log(count)
