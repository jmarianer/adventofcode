function part1(stacks: string[][], lines: string[]) {
  for (let line of lines) {
    let [_, count, fromStack, toStack] = line.split(/[a-z ]+/).map(x => +x);
    let temp = [];
    for (let i = 0; i < count; i++) {
      stacks[toStack - 1].push(stacks[fromStack - 1].pop()!);
    }
  }
  console.log(stacks.map(stack => stack.pop()).join(''));
}

function part2(stacks: string[][], lines: string[]) {
  for (let line of lines) {
    let [_, count, fromStack, toStack] = line.split(/[a-z ]+/).map(x => +x);
    let temp = [];
    for (let i = 0; i < count; i++) {
      temp.push(stacks[fromStack - 1].pop()!);
    }
    for (let i = 0; i < count; i++) {
      stacks[toStack - 1].push(temp.pop()!);
    }
  }
  console.log(stacks.map(stack => stack.pop()).join(''));
}

process.stdin.on('readable', () => {
  const contents = process.stdin.read();
  if (!contents) {
    return;
  }
  const sections: string[] = contents.toString().split('\n\n');

  let lines = sections[0].split('\n');
  lines.pop();
  let stackCount = (lines[0].length + 1) / 4;

  let stacks: string[][] = [...Array(stackCount)].map(_ => []);
  for (let line of lines) {
    for (let stack = 0; stack < stackCount; stack++) {
      let item = line[stack * 4 + 1];
      if (item != ' ') {
        stacks[stack].unshift(item);
      }
    }
  }

  lines = sections[1].split('\n');
  lines.pop();

  part1(JSON.parse(JSON.stringify(stacks)), lines);
  part2(JSON.parse(JSON.stringify(stacks)), lines);
});

