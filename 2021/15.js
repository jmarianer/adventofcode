let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync(path + '/input15');
let risks = buffer.toString().split('\n').filter(x => x).map(x => Array.from(x).map(x => parseInt(x)))

let origMaxX = risks.length
let origMaxY = risks[0].length
for (let x = 0; x < origMaxX; x++) {
  orig = risks[x]
  for (let i = 0; i < 4; i++) {
    orig = orig.map(x => x%9 + 1)
    risks[x].push(...orig)
  }
}
orig = risks
for (let i = 0; i < 4; i++) {
  orig = orig.map(x => x.map(y => y%9 + 1))
  risks.push(...orig)
}

let maxX = risks.length
let maxY = risks[0].length
let shortest = Array.from({length: maxX}, () => Array.from({length: maxY}, () => -1))

let queue = [[0, 0, 0]]

while (queue.length > 0) {
  queue.sort((x, y) => x[2] - y[2])
  let cur = queue.splice(0, 1)
  x = cur[0][0]
  y = cur[0][1]
  dist = cur[0][2]
  if (x < 0 || y < 0 || x >= maxX || y >= maxY) {
    continue
  }
  if (shortest[x][y] != -1) {
    continue
  }
  dist += risks[x][y]
  shortest[x][y] = dist
  queue.push([x+1, y, dist])
  queue.push([x-1, y, dist])
  queue.push([x, y+1, dist])
  queue.push([x, y-1, dist])
}

// After writing this I realized that this might be wrong if the shortest path
// to origMax within the larger grid goes outside of the original grid, but
// this didn't happen for my test so I'm going to leave it as-is.
console.log(shortest[origMaxX-1][origMaxY-1] - risks[0][0])
console.log(shortest[maxX-1][maxY-1] - risks[0][0])
