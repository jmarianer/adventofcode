let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync(path + '/input11');
let energy = buffer.toString().split('\n').map(x => Array.from(x).map(x => parseInt(x))).filter(x => x.length)

function inc(i, j) {
  if (energy[i][j] > 9) {
    return
  }
  energy[i][j]++
  if (energy[i][j] > 9) {
    for (let di = -1; di <= 1; di++) {
      for (let dj = -1; dj <= 1; dj++) {
        if (i+di >= 0 && i+di < 10 && j+dj >= 0 && j+dj < 10) {
          inc(i+di, j+dj)
        }
      }
    }
  }
}

let flashes = 0
for (let step = 1; step < 1000; step++) {
  let d_flashes = 0
  for (let i = 0; i < 10; i++) {
    for (let j = 0; j < 10; j++) {
      inc(i, j)
    }
  }
  for (let i = 0; i < 10; i++) {
    for (let j = 0; j < 10; j++) {
      if (energy[i][j] > 9) {
        energy[i][j] = 0
        d_flashes++
      }
    }
  }
  flashes += d_flashes
  if (step == 100) {
    console.log(flashes)
  }
  if (d_flashes == 100) {
    console.log(step)
    break
  }
}
