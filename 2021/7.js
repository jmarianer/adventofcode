let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync(path + '/input7');
let crabs = buffer.toString().split(',').map(x => parseInt(x))

let fuel = crabs.map(crab =>
  crabs.map(x => Math.abs(crab - x)).reduce((a, b) => a + b))

console.log(Math.min(...fuel))

// Oh, turns out the brute force solution works just as well.
fuel = [...Array(Math.max(...crabs)).keys()].map(crab =>
  crabs.map(x => Math.abs(crab - x)).map(x => x*(x+1)/2).reduce((a, b) => a + b))

console.log(Math.min(...fuel))
