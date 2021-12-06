let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync(path + '/input6');
let orig_fish = buffer.toString().split(',').map(x => parseInt(x))

// Slow, doesn't work for 256
fish = orig_fish
for (let i = 0; i < 80; i++) {
  newborn_count = fish.filter(x => x == 0).length
  fish = fish.map(x => x == 0 ? 6 : x - 1)
  for (let i = 0; i < newborn_count; i++) {
    fish.push(8)
  }
}
console.log(fish.length)

// Near-instantaneous, even for 256
fish = [0,0,0,0,0,0,0,0,0]
for (let i of orig_fish) {
  fish[i]++
}
for (let i = 0; i < 256; i++) {
  newborn_count = fish[0]
  for (let i = 0; i < 8; i++) {
    fish[i] = fish[i+1]
  }
  fish[6] += newborn_count
  fish[8] = newborn_count
}
console.log(fish.reduce((x, y) => x + y))
