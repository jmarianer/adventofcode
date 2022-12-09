process.stdin.on('readable', () => {
  const contents = process.stdin.read();
  if (!contents) {
    return;
  }
  const lines: string[] = contents.toString().split('\n');
  lines.pop();

  let hx = 0, hy = 0, tx = 0, ty = 0;
  let visited = new Set<string>();
  for (const line of lines) {
    const [dir, count] = line.split(' ');
    for (let foo = 0; foo < +count; foo++) {
      switch (dir) {
        case 'R':
          hx++;
          break;
        case 'U':
          hy++;
          break;
        case 'L':
          hx--;
          break;
        case 'D':
          hy--;
          break;
      }
      if (hx === tx && Math.abs(hy - ty) === 2) {
        ty += Math.sign(hy - ty);
      } else if (hy === ty && Math.abs(hx - tx) === 2) {
        tx += Math.sign(hx - tx);
      } else if (Math.abs(hy - ty) <= 1 && Math.abs(hx - tx) <= 1) {
        // Touching; do nothing
      } else {
        ty += Math.sign(hy - ty);
        tx += Math.sign(hx - tx);
      }
      console.log(hx, hy, tx, ty);
      visited.add(`${tx},${ty}`);
    }
    console.log(visited.size);
  }
});

