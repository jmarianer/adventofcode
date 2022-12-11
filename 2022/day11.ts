interface monkey {
  items: number[];
  operation: string;
  testDiv: number;
  ifTrue: number;
  ifFalse: number;
  inspectCount: number;
};

process.stdin.on('readable', () => {
  let monkeys: monkey[] = [];
  const contents = process.stdin.read();
  if (!contents) {
    return;
  }
  const paras: string[] = contents.toString().split('\n\n');

  for (let para of paras) {
    const lines = para.split('\n');
    let items = lines[1].split(':')[1].split(',').map(x => +x);
    let operation = lines[2].split('= ')[1];
    let testDiv = +(lines[3].split('by')[1]);
    let ifTrue = +(lines[4].split('monkey')[1]);
    let ifFalse = +(lines[5].split('monkey')[1]);

    monkeys.push({
      items, operation, testDiv, ifTrue, ifFalse,
      inspectCount: 0,
    });
  }

  console.log(monkeys);
  for (let i = 0; i < 20; i++) {
    for (let monkey of monkeys) {
      let items = monkey.items;
      monkey.items = [];
      for (let old of items) {
        let newVal = Math.floor(eval(monkey.operation) / 3);
        if (newVal % monkey.testDiv == 0) {
          monkeys[monkey.ifTrue].items.push(newVal);
        } else {
          monkeys[monkey.ifFalse].items.push(newVal);
        }
      }
      monkey.inspectCount += items.length;
    }
  }
  const sortedCounts = monkeys.map(m => m.inspectCount).sort((a, b) => b - a);
  console.log(sortedCounts[0] * sortedCounts[1]);
});

