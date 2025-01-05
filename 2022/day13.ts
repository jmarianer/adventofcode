enum tristate { leftfirst = -1, rightfirst = 1, equal = 0 };

function compare(left, right): tristate {
  if (typeof(left) === 'number' && typeof(right) === 'number') {
    if (left === right) {
      return tristate.equal;
    }
    return left < right ? tristate.leftfirst : tristate.rightfirst;
  }

  if (typeof(left) === 'number') {
    left = [left];
  }
  if (typeof(right) === 'number') {
    right = [right];
  }

  if (left.length === 0 && right.length === 0) {
    return tristate.equal;
  }

  if (left.length === 0) {
    return tristate.leftfirst;
  }
  if (right.length === 0) {
    return tristate.rightfirst;
  }


  let compareHead = compare(left[0], right[0]);
  if (compareHead !== tristate.equal) {
    return compareHead;
  }

  return compare(left.slice(1), right.slice(1));
}

process.stdin.on('readable', () => {
  const contents = process.stdin.read();
  if (!contents) {
    return;
  }
  const pairs: string[] = contents.toString().split('\n\n').map(pair => pair.trim().split('\n').map(JSON.parse));

  let ordered = 0;
  pairs.forEach((pair, index) => {
    const [left, right] = pair;
    if (compare(left, right) === tristate.leftfirst) {
      ordered += index + 1;
    }
  });
  console.log(ordered);

  let allPackets = [...pairs.flatMap(a => a), [[2]], [[6]]];
  allPackets.sort(compare);
  allPackets = allPackets.map(JSON.stringify);
  console.log((allPackets.indexOf('[[2]]') + 1) * (allPackets.indexOf('[[6]]') + 1));
});
