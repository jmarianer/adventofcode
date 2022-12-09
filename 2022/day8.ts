process.stdin.on('readable', () => {
  const contents = process.stdin.read();
  if (!contents) {
    return;
  }
  const lines: string[] = contents.toString().split('\n');
  lines.pop();
  const trees: number[][] = lines.map(line => line.split('').map(t => +t));

  let width = trees[0].length;
  let length = trees.length;

  const visibleTrees = new Set<string>();
  for (let x = 0; x < width; x++) {
    let maxHeight = -1;
    for (let y = 0; y < length; y++) {
      const curHeight = trees[y][x];
      if (maxHeight < curHeight) {
        maxHeight = curHeight;
        visibleTrees.add(JSON.stringify([y, x]));
      }
    }
    maxHeight = -1;
    for (let y = length - 1; y >= 0; y--) {
      const curHeight = trees[y][x];
      if (maxHeight < curHeight) {
        maxHeight = curHeight;
        visibleTrees.add(JSON.stringify([y, x]));
      }
    }
  }
  for (let y = 0; y < length; y++) {
    let maxHeight = -1;
    for (let x = 0; x < width; x++) {
      const curHeight = trees[y][x];
      if (maxHeight < curHeight) {
        maxHeight = curHeight;
        visibleTrees.add(JSON.stringify([y, x]));
      }
    }
    maxHeight = -1;
    for (let x = length - 1; x >= 0; x--) {
      const curHeight = trees[y][x];
      if (maxHeight < curHeight) {
        maxHeight = curHeight;
        visibleTrees.add(JSON.stringify([y, x]));
      }
    }
  }
  console.log(visibleTrees.size);

  let maxScenicScore = 1;
  for (let x = 0; x < width; x++) {
    for (let y = 0; y < length; y++) {
      let scenicScore = 1;
      for (let [dx, dy] of [[-1, 0], [1, 0], [0, 1], [0, -1]]) {
        let treeCount = 0;
        for (let xx = x + dx, yy = y + dy; xx >= 0 && yy >= 0 && xx < length && yy < width; xx += dx, yy += dy) {
          treeCount++;
          if (trees[yy][xx] >= trees[y][x]) {
            break;
          }
        }
        scenicScore *= treeCount;
      }
      if (scenicScore > maxScenicScore) {
        maxScenicScore = scenicScore;
      }
    }
  }
  console.log(maxScenicScore);
});

