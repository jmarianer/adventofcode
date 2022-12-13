process.stdin.on('readable', () => {
  const contents = process.stdin.read();
  if (!contents) {
    return;
  }
  const lines: string[] = contents.toString().split('\n');
  lines.pop();


  let start: [number, number] = [-1, -1];
  let end: [number, number] = [-1, -1];
  let heights = lines.map((line, y) =>
    line.split('')
        .map((letter, x) => {
          if (letter === 'S') {
            start = [x, y];
            return 1;
          }
          if (letter === 'E') {
            end = [x, y];
            return 26;
          }
          return letter.charCodeAt(0) - 96
        })
  );
  //console.log(heights, start, end);

  let dists = heights.map(row => row.map(_ => -1));

  let queue: Array<[[number, number], number]> = [[end, 0]];
  let s: typeof queue[0] | undefined;
  while (s = queue.shift()) {
    let [[x, y], dist] = s;
    if (dists[y][x] !== -1) {
      continue;
    }
    dists[y][x] = dist;
    for (let [dx, dy] of [[-1, 0], [1, 0], [0, 1], [0, -1]]) {
      if (x + dx < 0 || x + dx >= heights[0].length ||
          y + dy < 0 || y + dy >= heights.length) {
        continue;
      }
      if (heights[y][x] > heights[y + dy][x + dx] + 1) {
        continue;
      }
      queue.push([[x + dx, y + dy], dist + 1]);
    }
  }
  console.log(dists[start[1]][start[0]]);

  let min = dists[start[1]][start[0]];
  for (let x = 0; x < heights[0].length; x++) {
    for (let y = 0; y < heights.length; y++) {
      if (heights[y][x] === 1 && dists[y][x] !== -1 && dists[y][x] < min) {
        min = dists[y][x];
      }
    }
  }
  console.log(min);
});

