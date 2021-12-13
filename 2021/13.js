let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync(path + '/input13');
let splits = buffer.toString().split('\n\n')

dots = splits[0].split('\n').map(x => x.split(',').map(x => parseInt(x)))
folds = splits[1].split('\n').filter(x => x)
console.log(folds)

maxX = Math.max(...dots.map(x => x[0]))
maxY = Math.max(...dots.map(x => x[1]))

field = Array.from({length: maxY + 1}, () => Array.from({length: maxX + 1}, () => false))
for (let xy of dots) {
  let x = xy[0]
  let y = xy[1]
  field[y][x] = true
}

function foldY(y_fold) {
  for (let x = 0; x < field[0].length; x++) {
    for (let dy = 1; dy <= y_fold; dy++) {
      field[y_fold - dy][x] |= field[y_fold + dy][x]
    }
  }
  field.splice(y_fold)
}

function foldX(x_fold) {
  for (let y = 0; y < field.length; y++) {
    for (let dx = 1; dx <= x_fold; dx++) {
      field[y][x_fold - dx] |= field[y][x_fold + dx]
    }
    field[y].splice(x_fold)
  }
}

function fold(foldLine) {
  console.log(foldLine)
  let splits = foldLine.split('fold along ')[1].split('=')
  let index = parseInt(splits[1])
  if (splits[0] == 'x') {
    foldX(index)
  } else {
    foldY(index)
  }
}

fold(folds[0])
console.log(field.map(x => x.filter(y => y).length).reduce((x, y) => x + y))

for (let i = 1; i < folds.length; i++) {
  fold(folds[i])
}
console.log(field.map(x => x.slice(0, 80).map(y => y ? '#' : ' ').join('')).join('\n'))
