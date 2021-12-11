let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync(path + '/input9');
let heights = buffer.toString().split('\n').map(x => Array.from(x).map(x => parseInt(x))).filter(x => x.length)

function floodSize(i, j) {
  let cur = heights[i][j]
  if (cur == 9) {
    return 0
  }
  heights[i][j] = 9
  let total = 1
  if (heights[i-1][j] > cur) {
    total += floodSize(i-1, j)
  }
  if (heights[i+1][j] > cur) {
    total += floodSize(i+1, j)
  }
  if (heights[i][j-1] > cur) {
    total += floodSize(i, j-1)
  }
  if (heights[i][j+1] > cur) {
    total += floodSize(i, j+1)
  }
  return total
}

let sum = 0
heights = heights.map(x => [9, ...x, 9])
a = Array.from({length: heights[0].length}, () => 9)
heights = [a, ...heights, a]
basins = []
for (let i = 1; i < heights.length - 1; i++) {
  for (let j = 1; j < heights[i].length - 1; j++) {
    let cur = heights[i][j]
    if (cur < heights[i-1][j] &&
        cur < heights[i+1][j] &&
        cur < heights[i][j-1] &&
        cur < heights[i][j+1]) {
      sum += cur + 1
      basins.push(floodSize(i, j))
    }
  }
}
console.log(sum)
basins.sort((a, b) => b - a);
console.log(basins[0] * basins[1] * basins[2])
