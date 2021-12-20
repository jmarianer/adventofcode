let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync('input19');
let scanners = buffer.toString().split('\n\n').filter(x => x).map(
  x => x.split('\n').filter(x => x.includes(',')).map(x =>
    x.split(',').map(x => parseInt(x)))
  )

function relativize(scanner, beacon) {
  return scanner.map(xyz => xyz.map((x, i) => x - beacon[i]))
}

function derelativize(scanner, beacon) {
  return scanner.map(xyz => xyz.map((x, i) => x + beacon[i]))
}

function transform(beacon, i) {
  let [x, y, z] = beacon
  let origi = i
  if (i >= 16) {
    [x, y, z] = [y, z, x]
    i -= 8
  }
  if (i >= 8) {
    [x, y, z] = [y, z, x]
    i -= 8
  }
  let neg = 0
  if (i >= 4) {
    x = -x
    i -= 4
    neg++
  }
  if (i >= 2) {
    y = -y
    i -= 2
    neg++
  }
  if (i == 1) {
    z = -z
    neg++
  }
  
  if (neg % 2 == 1) {
    [y, z] = [z, y]
  }
  
  return [x, y, z]
}

function sameCoord1(b1, b2, i) {
  let [x1, y1, z1] = b1
  let [x2, y2, z2] = transform(b2, i)
  return x1 == x2 && y1 == y2 && z1 == z2
}

function sameCoord([x1, y1, z1], [x2, y2, z2]) {
  return x1 == x2 && y1 == y2 && z1 == z2
}

function common(beacons1, beacons2) {
  for (let i of transforms) {
    let a = beacons1.map(b1 => beacons2.some(b2 => sameCoord(b1, b2, i)))
    if (a.filter(x => x).length >= 12) {
      return i
    }
  }
}

function stringset(x) {
  return new Set(x.map(xyz => xyz.join(',')))
}

let transforms = [...Array(24).keys()]
// console.log(transforms.map(i => transform([1,2,3], i))

let all_beacons = scanners.splice(0, 1)[0]
let scanner_locations = [[0, 0, 0]]
outer: while (scanners.length) {
  console.log(scanners.length)
  for (let beacon1 of all_beacons) {
    let r1 = stringset(relativize(all_beacons, beacon1))
    for (let [s, scanner] of scanners.entries()) {
      for (let beacon2 of scanner) {
        let r2a = relativize(scanner, beacon2)
        for (let i of transforms) {
          let r2 = r2a.map(x => transform(x, i))
          if ([...stringset(r2)].filter(x => r1.has(x)).length >= 12) {
            scanners.splice(s, 1)
            all_beacons.push(...derelativize(r2, beacon1))
            let [x1, y1, z1] = beacon1
            let [x2, y2, z2] = transform(beacon2, i)
            scanner_locations.push([x1 - x2, y1 - y2, z1 - z2])
            continue outer
          }
        }
      }
    }
  }
}


console.log(stringset(all_beacons).size)
console.log(scanner_locations)

let max = 0
for (let i = 0; i < scanner_locations.length; i++) {
  for (let j = i; j < scanner_locations.length; j++) {
    let [x1, y1, z1] = scanner_locations[i]
    let [x2, y2, z2] = scanner_locations[j]
    let dist = Math.abs(x1 - x2) + Math.abs(y1 - y2) + Math.abs(z1 - z2)
    if (dist > max) {
      max = dist
    }
  }
}
console.log(max)
