'use strict'
const PriorityQueue = require('priorityqueuejs');

// Test input
//const original_state = '.......BCBDADCA'

// Real input
const original_state = '.......DACDCABB'


const target_state = '.......ABCDABCD'

// "lower" means the additional amount of energy to lower an amphipod into a
// chamber that isn't its own. We do this if we must, but we probably won't
// have to.
const base_energy = { A: 1, B: 10, C: 100, D: 1000, lower: 1000000 }


const top_two_row_transitions = [
  // Top row
  [0, 1, 1],
  [1, 0, 1],
  [1, 2, 2],
  [2, 1, 2],
  [2, 3, 2],
  [3, 2, 2],
  [3, 4, 2],
  [4, 3, 2],
  [4, 5, 2],
  [5, 4, 2],
  [5, 6, 1],
  [6, 5, 1],

  // Top to second and back
  [1, 7, 2],
  [2, 7, 2],
  [2, 8, 2],
  [3, 8, 2],
  [3, 9, 2],
  [4, 9, 2],
  [4, 10, 2],
  [5, 10, 2],
  [7, 1, 2],
  [7, 2, 2],
  [8, 2, 2],
  [8, 3, 2],
  [9, 3, 2],
  [9, 4, 2],
  [10, 4, 2],
  [10, 5, 2],
]

function add_new_state(state, from, to, energy_to_here, energy) {
  let new_state = Array.from(state)
  new_state[to] = state[from]
  new_state[from] = '.'

  // Add extra energy when lowering an amphipod into the wrong chamber.
  if (to > 7 && to > from && state[from] !== target_state[to]) {
    energy_to_here += base_energy.lower
  }
  queue.enq([
    new_state.join(''),
    energy_to_here + energy * base_energy[state[from]]
  ])
}


// Entries in the queue: state, 
let queue = new PriorityQueue((x, y) => y[1] - x[1])
let visited = new Set()
queue.enq([original_state, 0])

while (queue.size() > 0) {
  let [state, energy_to_here] = queue.deq()
  if (visited.has(state)) {
    continue
  }
  visited.add(state)

  if (state === target_state) {
    console.log(energy_to_here)
    break
  }

  if (energy_to_here > 100000) {
    console.log('wat')
    break
  }

  for (let [from, to, energy] of top_two_row_transitions) {
    if (state[from] === '.' || state[to] !== '.') {
      continue
    }

    add_new_state(state, from, to, energy_to_here, energy)
  }

  for (let chamber = 0; chamber < 4; chamber++) {
    let row2 = chamber + 7
    let row3 = chamber + 11

    if (state[row2] === '.' && state[row3] !== '.') {
      add_new_state(state, row3, row2, energy_to_here, 1)
    }
    if (state[row2] !== '.' && state[row3] === '.') {
      add_new_state(state, row2, row3, energy_to_here, 1)
    }
  }
}
