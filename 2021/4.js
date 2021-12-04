function wins(table) {
  const five = [0, 1, 2, 3, 4];
  for (let j = 0; j < 5; j++) {
    if (five.every(k => table[j][k] < 0))
      return true;
    if (five.every(k => table[k][j] < 0))
      return true;
  }
  return false;
}


let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync(path + '/input4');
let input_paras = buffer.toString().split('\n\n')

let numbers = input_paras.shift().split(',').map(x => parseInt(x))
let tables = input_paras.map(para =>
  para.trim().split('\n').map(line =>
    line.trim().split(/\s+/).map(x =>
      parseInt(x))))


let part1done = false;
for (let number of numbers) {
  for (let i = tables.length-1; i >= 0; i--) {
    for (let j = 0; j < 5; j++) {
      for (let k = 0; k < 5; k++) {
        if (tables[i][j][k] == number) {
          tables[i][j][k] = -1;
        }
      }
    }

    if (wins(tables[i])) {
      let sum = 0;
      for (let j = 0; j < 5; j++) {
        for (let k = 0; k < 5; k++) {
          if (tables[i][j][k] > 0) {
            sum += tables[i][j][k];
          }
        }
      }
      score = sum * number;
      tables.splice(i, 1);
      if (!part1done) {
        console.log(score);
        part1done = true
      }
    }
  }
}

console.log(score);
