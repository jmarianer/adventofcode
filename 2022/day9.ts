type Point = [number, number];

process.stdin.on('readable', () => {
  const contents = process.stdin.read();
  if (!contents) {
    return;
  }
  const lines: string[] = contents.toString().split('\n');
  lines.pop();

  let knots: Point[] = [...Array(10)].map((_, i) => [0, 0]);
  let visited = new Set<string>();
  for (const line of lines) {
    const [dir, count] = line.split(' ');
    for (let foo = 0; foo < +count; foo++) {
      switch (dir) {
        case 'R':
          knots[0][0]++;
          break;
        case 'U':
          knots[0][1]++;
          break;
        case 'L':
          knots[0][0]--;
          break;
        case 'D':
          knots[0][1]--;
          break;
      }

      for (let tail = 1; tail < 2; tail++) {
        let hx = knots[tail-1][0], hy = knots[tail-1][1];
        let tx = knots[tail][0], ty = knots[tail][1];

        if (Math.abs(hy - ty) <= 1 && Math.abs(hx - tx) <= 1) {
          // Touching; do nothing
        } else if (hx === tx && Math.abs(hy - ty) === 2) {
          ty += Math.sign(hy - ty);
        } else if (hy === ty && Math.abs(hx - tx) === 2) {
          tx += Math.sign(hx - tx);
        } else {
          ty += Math.sign(hy - ty);
          tx += Math.sign(hx - tx);
        }

        knots[tail] = [tx, ty];
      }
      visited.add(JSON.stringify(knots[1]));
    }
  }
  console.log(visited.size);
});

