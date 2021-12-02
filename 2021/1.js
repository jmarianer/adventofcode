let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync(path + '/input1');
let numbers = buffer.toString().split('\n').map(s => parseInt(s))

let count = 0
for (let i = 0; i < numbers.length - 2; i++) {
  if (numbers[i+1] > numbers[i]) {
    count++;
  }
}
console.log(count);

count = 0
for (let i = 0; i < numbers.length - 4; i++) {
  if (numbers[i+1] + numbers[i+2] + numbers[i+3] > numbers[i] + numbers[i+1] + numbers[i+2]) {
    count++;
  }
}
console.log(count);
