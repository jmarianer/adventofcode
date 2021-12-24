'use strict'
let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync('input24');
let steps = buffer.toString().split('\n')

let vars = {x: 0, y: 0, z: 0, w: 0}
let curdig = 0
// Largest
//let digits = [3, 9, 4, 9, 4, 1, 9, 5, 7, 9, 9, 9, 7, 9]
          //    1  1  1  1 26  1  1 26  1 26 26 26 26 26
// Smallest
let digits = [1, 3, 1, 6, 1, 1, 5, 1, 1, 3, 9, 6, 1, 7]
        //    1  1  1  1 26  1  1 26  1 26 26 26 26 26
console.log(digits.join(''))
let ip
for (let step of steps) {
  if (step === 'inp w') {
    vars.w = digits[curdig++]
    let z = vars.z
    let zz = []
    while (z) {
      zz.push(z % 26)
      z = Math.floor(z / 26)
    }
    console.log(zz, vars)
    ip = 0
    continue
  }
  
  ip++

  let [op, a, B] = step.split(' ')
  /*
  if (op == 'add' && a == 'x' && B != 'z') {
    console.log(B)
  }
  if (op == 'add' && a == 'y' && B != 'w') {
    console.log(B)
  }*/
  if (op == 'div' && a == 'z') {
    console.log(B)
  }

  let b
  if (isNaN(parseInt(B))) {
    b = vars[B]
  } else {
    b = parseInt(B)
  }

  switch(op) {
    case 'add':
      vars[a] += b;
      break
    case 'mul':
      vars[a] *= b
      break
    case 'div':
      vars[a] = Math.floor(vars[a] / b)
      break
    case 'mod':
      vars[a] %= b
      break
    case 'eql':
      vars[a] = (vars[a] == b) ? 1 : 0
      break
  }
  if (ip == 5) {
    console.log(ip, curdig, vars.x, vars.w)
  }

  continue
  if (op === 'add') {
    if (b !== 0) {
      if (vars[a] === 0) {
        vars[a] = b
      } else {
        vars[a] = `${vars[a]} + ${b}`
      }
    }
  }
  if (op === 'mul') {
    if (vars[a] !== 0) {
      if (b === 0) {
        vars[a] = 0
      } else if (b === 1) {
        // Nothing
      } else {
        vars[a] = `(${vars[a]}) * ${b}`
      }
    }
  }
  if (op === 'div') {
    if (vars[a] !== 0) {
      if (b === 1) {
        // Nothing
      } else {
        vars[a] = `(${vars[a]}) / ${b}`
      }
    }
  }
  if (op === 'mod') {
    if (vars[a] !== 0) {
      vars[a] = `(${vars[a]}) % ${b}`
    }
  }
  if (op === 'eql') {
    if (typeof(b) === 'number' && typeof(vars[a]) === 'number') {
      vars[a] = (vars[a] == b) ? 1 : 0
    } else if (typeof(vars[a]) === 'number' && b.startsWith('dig') && vars[a] >= 10) {
      vars[a] = 0
    } else {
      vars[a] = `(${vars[a]} == ${b})`
    }
  }
  console.log(`${a} = ${vars[a]}`)
}
console.log(vars.z)
