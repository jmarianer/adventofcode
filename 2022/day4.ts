process.stdin.on('readable', () => {
  const contents = process.stdin.read();
  if (!contents) {
    return;
  }
  const lines: string[] = contents.toString().split('\n');
  lines.pop();

  // Part 1
  let total = 0;
  for (let line of lines) {
    const [a, b] = line.split(',');
    const [s1, e1] = a.split('-');
    const [s2, e2] = b.split('-');

    if (+s1 <= +s2 && +e1 >= +e2 || +s2 <= +s1 && +e2 >= +e1) {
      total++;
    }
  }
  console.log(total);

  // Part 2
  total = 0;
  for (let line of lines) {
    const [a, b] = line.split(',');
    const [s1, e1] = a.split('-');
    const [s2, e2] = b.split('-');

    if (+e1 < +s2 || +e2 < +s1) {
      console.log(s1, e1, s2, e2);
    } else {
      total++;
    }
  }
  console.log(total);
});

