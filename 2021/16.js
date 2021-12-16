let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync('input16');
let bin = Array.from(buffer.toString().split('\n')[0]).map(x => parseInt(x, 16).toString(2).padStart(4, '0')).join('')

function eatBits(i) {
  let ret = bin.substring(0, i)
  bin = bin.substring(i)
  return ret
}

function eatLiteral() {
  let v = ''
  let bits = 0
  while (true) {
    let b = eatBits(5)
    bits += 5
    v += b.substring(1)
    if (b[0] == '0') {
      break
    }
  }
  return [bits, parseInt(v, 2)]
}

function eatPacket() {
  let version_sum = parseInt(eatBits(3), 2)
  let type = parseInt(eatBits(3), 2)
  let bits = 6
  if (type == 4) {
    let [b, value] = eatLiteral()
    return [version_sum, bits + b, value]
  } else {
    let len_type = eatBits(1)
    bits++
    let values = []
    if (len_type == '1') {
      let len = parseInt(eatBits(11), 2)
      bits += 11
      for (let i = 0; i < len; i++) {
        let [version, b, value] = eatPacket()
        version_sum += version
        bits += b
        values.push(value)
      }
    } else {
      let len = parseInt(eatBits(15), 2)
      bits += 15
      let target_bits = bits + len
      while (bits < target_bits) {
        let [version, b, value] = eatPacket()
        version_sum += version
        bits += b
        values.push(value)
      }
    }

    let value
    switch(type) {
      case 0: value = values.reduce((a, b) => a + b); break
      case 1: value = values.reduce((a, b) => a * b); break
      case 2: value = Math.min(...values); break
      case 3: value = Math.max(...values); break
      case 5: let [a1, b1] = values; value = (a1 > b1) ? 1 : 0; break
      case 6: let [a2, b2] = values; value = (a2 < b2) ? 1 : 0; break
      case 7: let [a3, b3] = values; value = (a3 == b3) ? 1 : 0; break
    }
    return [version_sum, bits, value]
  }
}

let [version_sum, bits, value] = eatPacket()
console.log(version_sum)
console.log(value)
