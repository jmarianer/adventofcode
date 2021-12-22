let fs = require('fs');
let path = process.cwd();
let buffer = fs.readFileSync('input22');
let steps = buffer.toString().split('\n').filter(x => x).map(x => x.split(/ |.=|\.\.|,/).filter(y => y).map(y =>
y === 'on' ? true : y === 'off' ? false : parseInt(y)))

// Solve part 1 the easy way
let state = {}
for (let [toggle, x1, x2, y1, y2, z1, z2] of steps) {
  if (x1 < -50 || x2 > 50 ||
      y1 < -50 || y2 > 50 ||
      z1 < -50 || z2 > 50) continue;

  for (let x = x1; x <= x2; x++) {
    for (let y = y1; y <= y2; y++) {
      for (let z = z1; z <= z2; z++) {
        state[[x,y,z]] = toggle;
      }
    }
  }
}

let count = 0
for (let coord in state) {
  if (state[coord]) count++
}
console.log(count)


// As a test, solve part 1 in just two dimensions (also the easy way)
state = {}
for (let [toggle, x1, x2, y1, y2, z1, z2] of steps) {
  if (x1 < -50 || x2 > 50 ||
      y1 < -50 || y2 > 50 ||
      z1 < -50 || z2 > 50) continue;

  for (let x = x1; x <= x2; x++) {
    for (let y = y1; y <= y2; y++) {
      state[[x,y]] = toggle;
    }
  }
}

count = 0
for (let coord in state) {
  if (state[coord]) count++
}
console.log(count)


// Solve it again for two dimensions, using rectangle unions and intersections
function subtract(rect1, rect2) {
  // Calculate a set of rects such that their union is rect1-rect2.
  let [x11, x12, y11, y12] = rect1
  let [x21, x22, y21, y22] = rect2

  let rects = []
  // Let's look at the options for x. There are six:
  // 1. x11<x12<x21<x22
  // 2. x11<x21<x12<x22
  // 3. x21<x11<x12<x22
  // 4. x11<x21<x22<x12
  // 5. x21<x11<x22<x12
  // 6. x21<x22<x11<x12
  // (where inequalities are sometimes strict and sometimes weak)

  // Options 1 and 6: no overlap at all
  // Strong inequality, because if they are equal then there's an overlap of 1.
  if (x12 < x21 || x22 < x11) {
    // Ditch immediately. There is no overlap between the two rects.
    return [rect1]
  }

  // Option 3: rect1 is completely inside rect2. Keep the rects as is.
  else if (x21 <= x11 && x12 <= x22) {
  }

  /* previously...
  // Option 4: rect2 is completely inside rect1. Split out the left and right parts of rect1 and set it to be just the middle.
  else if (x11 <= x21 && x22 <= x12) {
    rects.push([x11, x21-1, y11, y12])
    rects.push([x22+1, x12, y11, y12])
    x11 = x21
    x12 = x22
  }

  // Option 2: Right part of rect2 overlaps with the left part of rect1. Create
  // a rectangle that is just the right part of rect1
  else if (x11 < x21) {
    rects.push([x11, x21-1, y11, y12])
    x11 = x21
  }

  // Option 5: Same as 2 but with the directions reversed
  else if (x22 < x12) {
    rects.push([x22+1, x12, y11, y12])
    x12 = x22
  }*/

  // Handle options 2, 4, 5 simultaneously:
  else {
    if (x11 < x21) {
      rects.push([x11, x21-1, y11, y12])
      x11 = x21
    }
    if (x22 < x12) {
      rects.push([x22+1, x12, y11, y12])
      x12 = x22
    }
  }


  // OK, now copy that over for y.
  if (y12 < y21 || y22 < y11) {
    return [rect1]
  }
  else if (y21 <= y11 && y12 <= y22) {
  }
  else {
    if (y11 < y21) {
      rects.push([x11, x12, y11, y21-1])
      y11 = y21
    }
    if (y22 < y12) {
      rects.push([x11, x12, y22+1, y12])
      y12 = y22
    }
  }

  return rects
  
  /* Old version for posterity
  if (x21 <= x11) {
    // rect2 starts to the left of rect1. Split rect1 into two, and only deal
    // with the left-hand side from now on.  Unless rect2 ends to the right of
    // rect1, then don't do that.
    if (x22 >= x12 || x22 < x11) {
      // Nothing
    } else {
      rects.push([x22+1, x12, y11, y12])
      x12 = x22
    }
  } else if (x21 < x22) {
    // rect2 starts in the middle of rect1. Same kind of split except in the
    // other direction, and no need to worry about that special case.
    rects.push([x11, x21-1, y11, y12])
    x11 = x21-1
  } else {
    // rect2's leftmost corner is to the right of all of rect1, so just return rect1.
    return [rect1]
  }
  if (y21 <= y11) {
    // rect2 starts to the left of rect1. Split rect1 into two, and only deal
    // with the left-hand side from now on.  Unless rect2 ends to the right of
    // rect1, then don't do that.
    if (y22 >= y12 || x22 < x11) {
      // Nothing
    } else {
      rects.push([x11, x12, y22+1, y12])
      y12 = y22
    }
  } else if (y21 < y22) {
    // rect2 starts in the middle of rect1. Same kind of split except in the
    // other direction, and no need to worry about that special case.
    rects.push([x11, x12, y11, y21-1])
    y11 = y21-1
  } else {
    // rect2's leftmost corner is to the right of all of rect1, so just return rect1.
    return [rect1]
  }
  return [...rects, [x11, x12, y11, y12]]*/
}

//console.log(subtract([11, 13, 11, 13], [10, 12, 10, 12]))

let rects = []
for (let [toggle, x1, x2, y1, y2, z1, z2] of steps) {
  if (x1 < -50 || x2 > 50 ||
      y1 < -50 || y2 > 50 ||
      z1 < -50 || z2 > 50) continue;

  if (toggle) {
    let newRects = [[x1, x2, y1, y2]]
    for (let oldRect of rects) {
      let newNewRects = []
      for (let newRect of newRects) {
        newNewRects.push(...subtract(newRect, oldRect))
      }
      newRects = newNewRects
    }
    rects.push(...newRects)
  } else {
    let newRects = []
    for (let oldRect of rects) {
      newRects.push(...subtract(oldRect, [x1, x2, y1, y2]))
    }
    rects = newRects
  }
}
count = 0
for (let [x1, x2, y1, y2] of rects) {
  count += (x2-x1+1) * (y2-y1+1)
}
console.log(count)



// Solve again for three dimensions with cube subtraction
function subtract(cube1, cube2) {
  // Calculate a set of cubes such that their union is cube1-cube2.
  let [x11, x12, y11, y12, z11, z12] = cube1
  let [x21, x22, y21, y22, z21, z22] = cube2

  let cubes = []

  // X
  if (x12 < x21 || x22 < x11) {
    return [cube1]
  }
  else if (x21 <= x11 && x12 <= x22) {
  }
  else {
    if (x11 < x21) {
      cubes.push([x11, x21-1, y11, y12, z11, z12])
      x11 = x21
    }
    if (x22 < x12) {
      cubes.push([x22+1, x12, y11, y12, z11, z12])
      x12 = x22
    }
  }

  // Y
  if (y12 < y21 || y22 < y11) {
    return [cube1]
  }
  else if (y21 <= y11 && y12 <= y22) {
  }
  else {
    if (y11 < y21) {
      cubes.push([x11, x12, y11, y21-1, z11, z12])
      y11 = y21
    }
    if (y22 < y12) {
      cubes.push([x11, x12, y22+1, y12, z11, z12])
      y12 = y22
    }
  }

  // Z
  if (z12 < z21 || z22 < z11) {
    return [cube1]
  }
  else if (z21 <= z11 && z12 <= z22) {
  }
  else {
    if (z11 < z21) {
      cubes.push([x11, x12, y11, y12, z11, z21-1])
      z11 = z21
    }
    if (z22 < z12) {
      cubes.push([x11, x12, y11, y12, z22+1, z12])
      z12 = z22
    }
  }

  return cubes
}

//console.log(subtract([11, 13, 11, 13], [10, 12, 10, 12]))

let cubes = []
for (let [toggle, x1, x2, y1, y2, z1, z2] of steps) {
  /*
  if (x1 < -50 || x2 > 50 ||
      y1 < -50 || y2 > 50 ||
      z1 < -50 || z2 > 50) continue;*/

  if (toggle) {
    let newCubes = [[x1, x2, y1, y2, z1, z2]]
    for (let oldCube of cubes) {
      let newNewCubes = []
      for (let newCube of newCubes) {
        newNewCubes.push(...subtract(newCube, oldCube))
      }
      newCubes = newNewCubes
    }
    cubes.push(...newCubes)
  } else {
    let newCubes = []
    for (let oldCube of cubes) {
      newCubes.push(...subtract(oldCube, [x1, x2, y1, y2, z1, z2]))
    }
    cubes = newCubes
  }
  let count = 0
  for (let [x1, x2, y1, y2, z1, z2] of cubes) {
    count += (x2-x1+1) * (y2-y1+1) * (z2-z1+1)
  }
}
count = 0
for (let [x1, x2, y1, y2, z1, z2] of cubes) {
  count += (x2-x1+1) * (y2-y1+1) * (z2-z1+1)
}
console.log(count)
