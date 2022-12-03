function prio(a: string) {
  const ascii = a.charCodeAt(0);
  if (ascii >= 'a'.charCodeAt(0)) {
    return ascii - 'a'.charCodeAt(0) + 1;
  } else {
    return ascii - 'A'.charCodeAt(0) + 27;
  }
}

process.stdin.on('readable', () => {
  const contents = process.stdin.read();
  if (!contents) {
    return;
  }
  const lines: string[] = contents.toString().split('\n');
  lines.pop();

  // Part 1
  const compartments = lines.map((s) => [s.substr(0, s.length/2), s.substr(s.length/2)]);
  const dupes = compartments.map(([s, t]) => [...s].filter((q: string) => new Set(t).has(q))[0]);
  console.log(dupes.map(prio).reduce((partialSum, a) => partialSum + a, 0));

  // Part 2
  let total = 0;
  for (let i = 0; i < lines.length; i += 3) {
    const items = [...lines[i]]
      .filter((q: string) => new Set(lines[i+1]).has(q))
      .filter((q: string) => new Set(lines[i+2]).has(q))
      [0];
    total += prio(items);
  }
  console.log(total);
});

