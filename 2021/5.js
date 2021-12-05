let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync(path + '/input5');
let lines = buffer.toString().split('\n').filter(item => item).map(line => 
  line.split(/->|,/).map(x => parseInt(x)))

let size = Math.max(...lines.map(x => Math.max(...x))) + 1

function countCrossings(diagonals) {
  let crossings = Array.from({length: size}, () =>
    Array.from({length: size}, () => 0))
  for (let line of lines) {
    let [x1, y1, x2, y2] = line
    if (x1 == x2) {
      for (let i = Math.min(y1, y2); i <= Math.max(y1, y2); i++) {
        crossings[i][x1]++;
      }
    } else if (y1 == y2) {
      for (let i = Math.min(x1, x2); i <= Math.max(x1, x2); i++) {
        crossings[y1][i]++;
      }
    } else if (diagonals) {
      if (x1 > x2) {
        [x1, y1, x2, y2] = [x2, y2, x1, y1]
      }
      let dir = y2>y1 ? 1 : -1;
      for (let i = 0; i <= x2-x1; i++) {
        crossings[y1+i*dir][x1+i]++;
      }
    }
  }

  let total = 0;
  for (let x = 0; x < size; x++) {
    for (let y = 0; y < size; y++) {
      if (crossings[x][y] > 1) {
        total++;
      }
    }
  }
  console.log(total)
}

countCrossings(false);
countCrossings(true);
