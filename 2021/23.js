'use strict'
const PriorityQueue = require('priorityqueuejs');

// Test input (part 1)
//const original_state = '.......BCBDADCA'
//const target_state = '.......ABCDABCD'

// Test input (part 2)
//const original_state = '.......BCBDDCBADBACADCA'
//const target_state = '.......ABCDABCDABCDABCD'

//const original_state = 'ACA...B.CB.DCB.DBA.ADCD'

// Real input (part 1)
//const original_state = '.......DACDCABB'
//const target_state = '.......ABCDABCD'

// Real input (part 2)
const original_state = '.......DACDDCBADBACCABB'
const target_state = '.......ABCDABCDABCDABCD'


const base_energy = { A: 1, B: 10, C: 100, D: 1000 }


function log_state(state) {
  let str = ''
  for (let i = 0; i < state.length; i++) {
    str += state[i]
    if (i >= 6) {
      if (i % 4 == 2) {
        str += '\n  '
      } else {
        str += ' '
      }
    } else {
      if (i >= 1 && i < 5) {
        str += 'o'
      }
    }
  }
  console.log(str)
}


function add_new_state(state, from, to, energy_to_here, energy) {
  if (from >= state.length || to >= state.length) {
    return
  }

  let new_state = Array.from(state)
  new_state[to] = state[from]
  new_state[from] = '.'

  if (to > 6 && to > from) {
    // Don't lower an amphipod into the wrong chamber.
    if (state[from] !== target_state[to]) {
      return
    }

    // Don't lower it into the right chamber either, unless everything below it
    // is correct.
    let cur = to + 4
    while (cur < state.length) {
      if (state[cur] != target_state[cur]) {
        return
      }
      cur += 4
    }
  }
  // Don't raise an amphipod from its chamber if it and all the ones under it
  // are already done.
  if (from > 7) {
    let cur = from
    while (cur < state.length) {
      if (state[cur] != target_state[cur]) {
        break
      }
      cur += 4
    }
    if (cur > state.length) {
      return
    }
  }
  new_state = new_state.join('')
  let new_energy = energy_to_here + energy * base_energy[state[from]]
  //console.log(new_energy)
  //log_state(new_state)
  queue.enq([new_state, new_energy, state])
}


let queue = new PriorityQueue((x, y) => y[1] - x[1])
let visited = new Set()
let prev_state_map = {}
queue.enq([original_state, 0, null])

while (queue.size() > 0) {
  let [state, energy_to_here, prev_state] = queue.deq()
  if (visited.has(state)) {
    continue
  }
  visited.add(state)
  prev_state_map[state] = [prev_state, energy_to_here]

  if (state === target_state) {
    console.log(energy_to_here)
    break
  }

  // Each move is either from a chamber to the top row or from the top row to a chamber.
  for (let chamber = 0; chamber < 4; chamber++) {
    // The exit from the chamber is between two top-row points.
    let between1 = chamber + 1
    let between2 = chamber + 2

    // Chamber to top row:
    // First, find the topmost place where there's an amphipod in the chamber
    let down = chamber + 7
    let energy_mult_up = 0
    while (state[down] === '.' && down < state.length) {
      down += 4
      energy_mult_up++
    }
    if (down < state.length) {
      // It takes two energy to get to between1
      let energy_mult = 2
      for (let up = between1; up >= 0; up--) {
        if (state[up] === '.') {
          add_new_state(state, down, up, energy_to_here, energy_mult_up + energy_mult)
        } else {
          break
        }
        energy_mult++
        if (up != 1)
          energy_mult++
      }
      energy_mult = 2
      for (let up = between2; up <= 6; up++) {
        if (state[up] === '.') {
          add_new_state(state, down, up, energy_to_here, energy_mult_up + energy_mult)
        } else {
          break
        }
        energy_mult++
        if (up != 5)
          energy_mult++
      }
    }

    // Top row to chamber
    // Find out if there's an empty spot in the chamber
    down = chamber + 7
    let energy_mult1 = 0
    while (state[down] === '.' && down < state.length) {
      down += 4
      energy_mult1++
    }
    down -= 4
    energy_mult1--
    if (energy_mult1 >= 0) {
      let energy_mult2 = 2
      for (let up = between1; up >= 0; up--) {
        if (state[up] !== '.') {
          add_new_state(state, up, down, energy_to_here, energy_mult1 + energy_mult2)
          break
        }
        energy_mult2++
        if (up != 1)
          energy_mult2++
      }
      energy_mult2 = 2
      for (let up = between2; up <= 6; up++) {
        if (state[up] !== '.') {
          add_new_state(state, up, down, energy_to_here, energy_mult1 + energy_mult2)
          break
        }
        energy_mult2++
        if (up != 5)
          energy_mult2++
      }
    }
  }
}


let state = target_state
let energy
while (state != null) {
  let foo = prev_state_map[state]
  console.log(foo[1])
  log_state(state)
  state = foo[0]
}
