'use strict'
let PriorityQueue = require('priorityqueuejs');

// Test input
//let original_state = '.......BCBDADCA'

// Real input
let original_state = '.......DACDCABB'

let target_state = '.......ABCDABCD'
let queue = new PriorityQueue((x, y) => y[1] - x[1])
queue.enq([original_state, 0])

let transitions = [
  // from, [to], energy multiplier
  [1, [2], 1],
  [2, [1], 1],
  [2, [3, 8], 2],
  [3, [2, 8, 9, 4], 2],
  [4, [3, 9, 10, 5], 2],
  [5, [4, 10, 11, 6], 2],
  [6, [5, 11], 2],
  [6, [7], 1],
  [7, [6], 1],
  [8, [2, 3], 2],
  [9, [3, 4], 2],
  [10, [4, 5], 2],
  [11, [5, 6], 2],
  [8, [12], 1],
  [9, [13], 1],
  [10, [14], 1],
  [11, [15], 1],
  [12, [8], 1],
  [13, [9], 1],
  [14, [10], 1],
  [15, [11], 1],
]

let base_energy = { A: 1, B: 10, C: 100, D: 1000 }
let visited = new Set()

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

  for (let [from, tos, energy] of transitions) {
    for (let to of tos) {
      let from_elt = state[from - 1]
      if (from_elt !== '.' && state[to - 1] === '.') {
        let new_state = Array.from(state)
        new_state[to - 1] = from_elt
        new_state[from - 1] = '.'
        if (!visited.has(new_state)) {
          queue.enq([new_state.join(''), energy_to_here + energy * base_energy[from_elt]])
        }
      }
    }
  }
}
