let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync(path + '/input10');
let lines = buffer.toString().split('\n')

pairs = {
  "(": ")",
  "[": "]",
  "{": "}",
  "<": ">",
}

scores = {
  ")": 3,
  "]": 57,
  "}": 1197,
  ">": 25137,
}

scores2 = {
  ")": 1,
  "]": 2,
  "}": 3,
  ">": 4,
}

let score = 0
let line_scores = []

l0: for (let line of lines) {
  stack = []
  for (let char of line) {
    if (char in pairs) {
      stack.push(pairs[char])
    } else {
      if (char !== stack.pop()) {
        score += scores[char]
        continue l0;
      }
    }
  }

  let score2 = 0
  stack.reverse()
  for (let char of stack) {
    score2 *= 5
    score2 += scores2[char]
  }
  if (score2) {
    line_scores.push(score2)
  }
}
console.log(score)
line_scores.sort((a, b) => a - b)
console.log(line_scores[(line_scores.length - 1) / 2])
