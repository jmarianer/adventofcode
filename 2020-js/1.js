let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync(path + "/input1old");
let numbers = buffer.toString().split('\n').map(s => parseInt(s))

for (let i of numbers) {
  for (let j of numbers) {
    if (i + j == 2020) {
      console.log(i * j)
      break
    }
  }
}

for (let i of numbers) {
  for (let j of numbers) {
    for (let k of numbers) {
      if (i + j + k == 2020) {
        console.log(i * j * k)
        break
      }
    }
  }
}
