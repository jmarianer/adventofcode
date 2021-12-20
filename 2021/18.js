let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync('input18');
function maybeParseInt(x) {
  foo = parseInt(x)
  return isNaN(foo) ? x : foo;
}
let numbers = buffer.toString().split('\n').filter(x => x).map(x => Array.from(x).map(maybeParseInt).filter(x => x !== ','))

function reduce(num) {
  outer: while (true) {
    let nesting = 0
    for (let i = 0; i < num.length; i++) {
      if (nesting === 5) {
        for (let j = i-1; j >= 0; j--) {
          if (typeof(num[j]) === 'number') {
            num[j] += num[i]
            break
          }
        }
        for (let j = i+2; j < num.length; j++) {
          if (typeof(num[j]) === 'number') {
            num[j] += num[i+1]
            break
          }
        }
        num.splice(i-1, 4, 0)
        continue outer
      }

      if (num[i] === '[') {
        nesting++;
      } else if (num[i] === ']') {
        nesting--;
      }
    }

    for (let i = 0; i < num.length; i++) {
      if (num[i] >= 10) {
        num.splice(i, 1, '[', Math.floor(num[i]/2), Math.ceil(num[i]/2), ']')
        continue outer
      }
    }
    return num
  }
}

num = [].concat(numbers[0])
for (let i = 1; i < numbers.length; i++) {
  num = ['['].concat(num, numbers[i], ']')
  num = reduce(num)
}

function magnitude(num) {
  while (num.length > 1) {
    for (let i = 0; i < num.length; i++) {
      if (typeof(num[i]) === 'number' && typeof(num[i+1]) === 'number') {
        num.splice(i-1, 4, 3*num[i] + 2*num[i+1])
      }
    }
  }
  return num[0]
}

console.log(magnitude(num))

let max = 0
for (let i = 0; i < numbers.length; i++) {
  for (let j = 0; j < numbers.length; j++) {
    if (i === j) continue;
    let sum = magnitude(reduce(['['].concat(numbers[i], numbers[j], ']')))
    if (sum > max) {
      max = sum
    }
  }
}
console.log(max)
