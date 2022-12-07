process.stdin.on('readable', () => {
  const contents = process.stdin.read();
  if (!contents) {
    return;
  }
  const lines: string[] = contents.toString().split('\n');
  lines.pop();

  interface File { type: 'file'; size: number; }
  interface Dir {
    type: 'dir';
    contents: Record<string, File | Dir>;
    size?: number;
  }

  const root: Dir = { type: 'dir', contents: {} };
  let stack: Dir[] = [root];

  for (let line of lines) {
    if (line[0] === '$') {
      const cmd = line.substr(2, 2);
      if (cmd === 'cd') {
        const dir = line.substr(5);
        if (dir === '/') {
          stack = [root];
        } else if (dir === '..') {
          stack.shift();
        } else {
          stack.unshift(stack[0].contents[dir] as Dir);
        }
      }
    } else {
      const [size, name] = line.split(' ');
      if (size === 'dir') {
        stack[0].contents[name] = { type: 'dir', contents: {} };
      } else {
        stack[0].contents[name] = { type: 'file', size: +size };
      }
    }
  }

  let tot_under_10k = 0;

  function traverse_tree(dir: Dir) {
    let size = 0;
    for (let i of Object.values(dir.contents)) {
      if (i.type === 'dir') {
        traverse_tree(i);
      }
      size += i.size!;
    }
    dir.size = size;
    if (size < 100000) {
      tot_under_10k += size;
    }
  }
  traverse_tree(root);

  console.log(tot_under_10k);

  const fs_size = 70000000;
  const used = root.size!;
  const required = 30000000;
  const needed = used - (fs_size - required);

  let min = used;
  function get_min(dir: Dir) {
    for (let i of Object.values(dir.contents)) {
      if (i.type === 'dir') {
        get_min(i);
      }
    }
    if (dir.size! < min && dir.size! > needed) {
      min = dir.size!;
    }
  }
  get_min(root);
  console.log(min);
});

