function isSuperset(set, subset) {
    for (let elem of subset) {
        if (!set.has(elem)) {
            return false
        }
    }
    return true
}

function getDigits(samples, outputs) {
  samples = samples.map(x => new Set(x))
  digits = Array.from({length: 10}, () => '')

  // Unique number of segments
  digits[1] = samples.filter(y => y.size == 2)[0]
  digits[4] = samples.filter(y => y.size == 4)[0]
  digits[7] = samples.filter(y => y.size == 3)[0]
  digits[8] = samples.filter(y => y.size == 7)[0]

  // Six segments: 0, 6, 9
  digits[6] = samples.filter(y => y.size == 6 && !isSuperset(y, digits[1]))[0]
  digits[9] = samples.filter(y => y.size == 6 && isSuperset(y, digits[4]))[0]
  digits[0] = samples.filter(y => y.size == 6 && !digits.includes(y))[0]

  // Five segments: 2, 3, 5
  digits[3] = samples.filter(y => y.size == 5 && isSuperset(y, digits[1]))[0]
  digits[5] = samples.filter(y => y.size == 5 && isSuperset(digits[6], y))[0]
  digits[2] = samples.filter(y => y.size == 5 && !digits.includes(y))[0]

  res = 0
  outputs = outputs.map(x => new Set(x))
  for (let output of outputs) {
    res *= 10
    digit = [0,1,2,3,4,5,6,7,8,9].filter(i =>
      isSuperset(digits[i], output) &&
      isSuperset(output, digits[i]))[0]
    res += digit
  }
  return res;
}

let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync(path + '/input8');
let segments = buffer.toString().split('\n').map(x => x.split(' | ').map(y => y.split(' '))).filter(x => x.length == 2);

// Part 1
console.log(segments.map(x => 
  x[1].filter(y => [2, 3, 4, 7].includes(y.length)).length
).reduce((a, b) => a + b))


// Part 2
console.log(segments.map(x => 
  getDigits(x[0], x[1])
).reduce((a, b) => a + b))
