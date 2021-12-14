let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync(path + '/input14');
let splits = buffer.toString().split('\n\n')

let init = splits[0]
let cur = init
let insertions = {}
for (let i of splits[1].split('\n').filter(x => x)) {
  let splits = i.split(' -> ')
  insertions[splits[0]] = splits[1]
}

// Slow and stupid
for (let i = 0; i < 10; i++) {
  let next = cur[0]
  for (let i = 1; i < cur.length; i++) {
    next += insertions[cur[i-1]+cur[i]] + cur[i]
  }
  cur = next
}

let counts = {}
for (let i of cur) {
  counts[i] |= 0
  counts[i]++
}
let v = Object.values(counts)
console.log(Math.max(...v) - Math.min(...v))


// Much better
cur = {}
for (let i = 1; i < init.length; i++) {
  let str = init[i-1] + init[i]
  if (!cur[str]) cur[str] = 0n
  cur[str]++
}
for (let i = 0; i < 40; i++) {
  let next = {}
  for (let j in insertions) {
    if (!cur[j]) cur[j] = 0n
    let str1 = j[0] + insertions[j]
    let str2 = insertions[j] + j[1]
    if (!next[str1]) next[str1] = 0n
    next[str1] += cur[j]
    if (!next[str2]) next[str2] = 0n
    next[str2] += cur[j]
  }
  cur = next
}

counts = {}
for (let i in cur) {
  if (!counts[i[0]]) counts[i[0]] = 0n
  counts[i[0]] += cur[i]
  if (!counts[i[1]]) counts[i[1]] = 0n
  counts[i[1]] += cur[i]
}
counts[init[0]]++
counts[init[init.length-1]]++
v = Object.values(counts)
v.sort((a, b) => (a < b) ? -1 : ((a > b) ? 1 : 0))
console.log((v[v.length-1] - v[0]) / 2n)
