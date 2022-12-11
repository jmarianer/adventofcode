let cycle = 0;
let x = 1;
let signal_sum = 0;
let current_line = '';

function inc_cycle() {
  cycle++;
  if ((cycle - 20) % 40 === 0) {
    signal_sum += cycle * x;
  }
  
  const crt_x = (cycle - 1) % 40;
  if (Math.abs(crt_x - x) <= 1) {
    current_line += '#';
  } else {
    current_line += '.';
  }
  if (crt_x === 39) {
    console.log(current_line);
    current_line = '';
  }
}

process.stdin.on('readable', () => {
  const contents = process.stdin.read();
  if (!contents) {
    return;
  }
  const lines: string[] = contents.toString().split('\n');
  lines.pop();

  for (let line of lines) {
    if (line === 'noop') {
      inc_cycle();
    } else {
      let [_, delta] = line.split(' ');
      inc_cycle();
      inc_cycle();
      x += +delta;
    }
  }
  console.log(signal_sum);
});

