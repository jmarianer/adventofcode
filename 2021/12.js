let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync(path + '/input12');
let edges = buffer.toString().split('\n').filter(x => x).map(x => x.split('-'))

let graph = {}
for (let edge of edges) {
  if (!(edge[0] in graph)) {
    graph[edge[0]] = []
  }
  if (!(edge[1] in graph)) {
    graph[edge[1]] = []
  }

  graph[edge[0]].push(edge[1])
  graph[edge[1]].push(edge[0])
}
for (let a in graph) {
  graph[a].sort()
}

function part1(path, target) {
  current = path[path.length - 1]
  if (current == target) {
    return 1
  }

  let count = 0
  for (let next of graph[current]) {
    if (next == next.toUpperCase() || !path.includes(next)) {
      path.push(next)
      count += part1(path, target)
      path.pop()
    }
  }
  return count
}

console.log(part1(['start'], 'end'))

function part2(path, target) {
  current = path[path.length - 1]
  if (current == target) {
    console.log(path.join(','))
    return 1
  }
  let smallCaves = path.filter(x => x == x.toLowerCase()).sort()
  let smallCavesCount = smallCaves.reduce(function(rv, x) {
    rv[x] = (rv[x] + 1) || 1;
    return rv
  }, {})

  let visitedTwice = Object.values(smallCavesCount).includes(2)
  if (visitedTwice) {
    console.log(path)
  }

  let count = 0
  for (let next of graph[current]) {
    if (next === path[0]) {
      continue
    }
    if (next == next.toUpperCase() || !path.includes(next) || !visitedTwice) {
      path.push(next)
      count += part2(path, target)
      path.pop()
    }
  }
  return count
}

console.log(part2(['start'], 'end'))
