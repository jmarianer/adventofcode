let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync(path + '/input2');
let lines = buffer.toString().split('\n')

let pos = 0
let depth = 0
for (let line of lines) {
  let a = line.split(' ');
  if (a[0] == 'forward') {
    pos += parseInt(a[1])
  }
  if (a[0] == 'down') {
    depth += parseInt(a[1])
  }
  if (a[0] == 'up') {
    depth -= parseInt(a[1])
  }
}
console.log(pos * depth)

pos = 0
depth = 0
let aim = 0
for (let line of lines) {
  let a = line.split(' ');
  if (a[0] == 'forward') {
    pos += parseInt(a[1])
    depth += parseInt(a[1]) * aim
  }
  if (a[0] == 'down') {
    aim += parseInt(a[1])
  }
  if (a[0] == 'up') {
    aim -= parseInt(a[1])
  }
}
console.log(pos * depth)

