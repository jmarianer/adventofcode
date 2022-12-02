const readable = process.stdin

readable.on('readable', () => {
  const contents = readable.read();
  if (!contents) {
    return;
  }
  let elves: number[] = contents.toString()
    .split('\n\n')
    .map((d: string) => d.split('\n').map(a => +a))
    .map((d: number[]) => d.reduce((partialSum, a) => partialSum + a, 0));
  elves = elves.sort((a, b) => b - a);
  console.log(elves[0]);
  console.log(elves[0] + elves[1] + elves[2]);
});

