interface monkey {
  items: number[];
  operation: string;
  testDiv: number;
  ifTrue: number;
  ifFalse: number;
  inspectCount: number;
};

function doIt(monkeys: monkey[], cycles: number, op: (op: string, old: number) => number) {
  for (let i = 0; i < cycles; i++) {
    for (let monkey of monkeys) {
      let items = monkey.items;
      monkey.items = [];
      for (let oldVal of items) {
        let newVal = op(monkey.operation, oldVal);
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
}

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

  // Part I
  doIt(JSON.parse(JSON.stringify(monkeys)), 20, ((op, old) => Math.floor(eval(op) / 3)));

  // Part II
  let allDivs = monkeys.map(m => m.testDiv).reduce((a, b) => a * b);
  doIt(JSON.parse(JSON.stringify(monkeys)), 10000, ((op, old) => eval(op) % allDivs));

//        let newVal = eval(monkey.operation) % allDivs;
});

