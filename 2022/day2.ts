const readable = process.stdin

const score1: Record<string, number> = {
  'A X': 3 + 1,
  'A Y': 6 + 2,
  'A Z': 0 + 3,
  'B X': 0 + 1,
  'B Y': 3 + 2,
  'B Z': 6 + 3,
  'C X': 6 + 1,
  'C Y': 0 + 2,
  'C Z': 3 + 3,
}

const score2: Record<string, number> = {
  'A Y': 3 + 1,
  'A Z': 6 + 2,
  'A X': 0 + 3,
  'B X': 0 + 1,
  'B Y': 3 + 2,
  'B Z': 6 + 3,
  'C Z': 6 + 1,
  'C X': 0 + 2,
  'C Y': 3 + 3,
}

readable.on('readable', () => {
  const contents = readable.read();
  if (!contents) {
    return;
  }
  const turns: string[] = contents.toString().split('\n');
  const scores1: number[] = turns.map((d: string) => score1[d]);
  console.log(scores1.reduce((partialSum, a) => partialSum + (a ?? 0), 0));
  const scores2: number[] = turns.map((d: string) => score2[d]);
  console.log(scores2.reduce((partialSum, a) => partialSum + (a ?? 0), 0));
});

