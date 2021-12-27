let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync('input25');
let map = buffer.toString().split('\n').filter(x => x).map(x => Array.from(x))

function moveEast() {
  let moves = []
  for (let i = 0; i < map.length; i++) {
    for (let j = 0; j < map[0].length; j++) {
      if (map[i][j] === '>') {
        let newJ = (j+1) % map[0].length
        if (map[i][newJ] === '.') {
          moves.push([i, j])
        }
      }
    }
  }
  for (let [i, j] of moves) {
    let newJ = (j+1) % map[0].length
    map[i][j] = '.'
    map[i][newJ] = '>'
  }
  return moves.length
}

function moveSouth() {
  let moves = []
  for (let i = 0; i < map.length; i++) {
    for (let j = 0; j < map[0].length; j++) {
      if (map[i][j] === 'v') {
        let newI = (i+1) % map.length
        if (map[newI][j] === '.') {
          moves.push([i, j])
        }
      }
    }
  }
  for (let [i, j] of moves) {
    let newI = (i+1) % map.length
    map[i][j] = '.'
    map[newI][j] = 'v'
  }
  return moves.length
}

let moves = 0
while (true) {
  moves++
  let i = moveEast()
  i += moveSouth()
  if (i == 0) {
    console.log(moves)
    break
  }
}
//console.log(map.map(x => x.join('')).join('\n'))
