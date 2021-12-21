//let input = [4, 8]
let input = [2, 10]

let die = 0
let rolls = 0
function roll() {
  rolls++
  die %= 100
  die++
  return die
}

// Part 1
let [player1, player2] = input
let [score1, score2] = [0, 0]
while (true) {
  player1 += roll() + roll() + roll()
  player1--
  player1 %= 10
  player1++
  score1 += player1
  if (score1 >= 1000)
    break

  player2 += roll() + roll() + roll()
  player2--
  player2 %= 10
  player2++
  score2 += player2
  if (score2 >= 1000)
    break
}

console.log(score1, score2, rolls)



// Part 2
let options = {}
for (let i = 1; i <= 3; i++) {
  for (let j = 1; j <= 3; j++) {
    for (let k = 1; k <= 3; k++) {
      if (!((i+j+k) in options))
        options[i+j+k] = 0n
      options[i+j+k]++
    }
  }
}
console.log(options)

let initial_position = input.join(',') + ",0,0"  // p1, p2, s1, s2
let positions = {}
positions[initial_position] = 1n
console.log(positions)

while (Object.values(positions).length !== 2) {
  let next_positions = {}
  for (let p in positions) {
    if (p.includes("WIN")) {
      next_positions[p] = positions[p]
      continue
    }
    for (let r in options) {
      let [p1, p2, s1, s2] = p.split(',').map(x => parseInt(x))
      p1 += r-1
      p1 %= 10
      p1++
      s1 += p1
      np = (s1 >= 21) ? "WIN1" : [p1, p2, s1, s2].join(',')
      if (!(np in next_positions))
        next_positions[np] = 0n
      next_positions[np] += positions[p] * options[r]
    }
  }
  positions = next_positions
  console.log(positions)

  next_positions = {WIN1: 0n, WIN2: 0n}
  for (let p in positions) {
    if (p.includes("WIN")) {
      next_positions[p] += positions[p]
      continue
    }
    for (let r in options) {
      let [p1, p2, s1, s2] = p.split(',').map(x => parseInt(x))
      p2 += r-1
      p2 %= 10
      p2++
      s2 += p2
      np = (s2 >= 21) ? "WIN2" : [p1, p2, s1, s2].join(',')
      if (!(np in next_positions))
        next_positions[np] = 0n
      next_positions[np] += positions[p] * options[r]
    }
  }
  positions = next_positions
  console.log(positions)
}
