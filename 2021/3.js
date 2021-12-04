let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync(path + '/input3');
let lines = buffer.toString().split('\n')

let width = lines[0].length;
let totals = Array.from({length: width}, () => 0)

for (let line of lines) {
  for (let i = 0; i < width; i++) {
    if (line[i] == '1') {
      totals[i] ++;
    }
  }
}

let gamma = 0;
let epsilon = 0;
for (let total of totals) {
  gamma *= 2;
  epsilon *= 2;
  if (total > lines.length/2) {
    gamma++;
  } else {
    epsilon++;
  }
}
console.log(gamma * epsilon)

let all = lines;
for (let i = 0; i < width; i++) {
  zeros = all.filter(x => x[i] == '0').length;
  if (zeros > all.length/2) {
    search_for = '0';
  } else {
    search_for = '1';
  }

  all = all.filter(x => x[i] == search_for);
}
oxygen = parseInt(all[0], 2)


all = lines;
for (let i = 0; i < width; i++) {
  zeros = all.filter(x => x[i] == '0').length;
  if (zeros <= all.length/2) {
    search_for = '0';
  } else {
    search_for = '1';
  }

  all = all.filter(x => x[i] == search_for);
  if (all.length == 1) {
    break;
  }
}
co2 = parseInt(all[0], 2)

console.log(oxygen * co2)
