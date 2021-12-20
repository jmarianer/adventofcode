let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync('input20');
let [alg, input] = buffer.toString().split('\n\n')
input = input.split('\n').filter(x => x);

function enhance(input) {
  let output = [];
  for (let i = -1; i <= input.length; i++) {
    let output_line = '';
    for (let j = -1; j <= input[0].length; j++) {
      let index = 0;
      for (let di = -1; di <= 1; di++) {
        for (let dj = -1; dj <= 1; dj++) {
          let i1 = i + di, j1 = j + dj;
          index *= 2;
          if (i1 >= 0 && i1 < input.length &&
              j1 >= 0 && j1 < input[0].length &&
              input[i1][j1] == '#') {
            index++;
          }
        }
      }
      output_line += alg[index];
    }
    output.push(output_line);
  }
  return output;
}
function enhance1(input) {
  let output = [];
  for (let i = -1; i <= input.length; i++) {
    let output_line = '';
    for (let j = -1; j <= input[0].length; j++) {
      let index = 0;
      for (let di = -1; di <= 1; di++) {
        for (let dj = -1; dj <= 1; dj++) {
          let i1 = i + di, j1 = j + dj;
          index *= 2;
          if (i1 >= 0 && i1 < input.length &&
              j1 >= 0 && j1 < input[0].length &&
              input[i1][j1] == '.') {
            index--;
          }
          index++;
        }
      }
      output_line += alg[index];
    }
    output.push(output_line);
  }
  return output;
}

let output = enhance1(enhance(input));
console.log(Array.from(output.join('')).filter(x => x == '#').length);


input = output;
for (let i = 0; i < 24; i++) {
  input = enhance1(enhance(input));
}
console.log(Array.from(input.join('')).filter(x => x == '#').length);
