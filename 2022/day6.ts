process.stdin.on('readable', () => {
  const contents = process.stdin.read();
  if (!contents) {
    return;
  }
  const input: string = contents.toString().trim();

  for (let i = 0; i < input.length; i++) {
    if (new Set(input.substr(i, 4)).size === 4) {
      console.log(i + 4);
      break;
    }
  }

  for (let i = 0; i < input.length; i++) {
    if (new Set(input.substr(i, 14)).size === 14) {
      console.log(i + 14);
      break;
    }
  }
});

