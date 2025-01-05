$\ = "\n";
while (<>) {
  chomp;
  push @a, [split //, "...$_..."];
}
$buffer = [('.') x ($#{$a[0]} + 1)];
push @a, $buffer;
push @a, $buffer;
push @a, $buffer;
unshift @a, $buffer;
unshift @a, $buffer;
unshift @a, $buffer;

$, = ',';

for my $i (0 .. $#a) {
  for my $j (0 .. $#{$a[0]}) {
    for my $di (-1, 0, 1) {
      for my $dj (-1, 0, 1) {
        if (
          $a[$i][$j] eq 'X' and
          $a[$i + $di][$j + $dj] eq 'M' and
          $a[$i + 2 * $di][$j + 2 * $dj] eq 'A' and
          $a[$i + 3 * $di][$j + 3 * $dj] eq 'S') {
          $out++;
        }
      }
    }
  }
}

print $out;

for my $i (0 .. $#a) {
  for my $j (0 .. $#{$a[0]}) {
    if ($a[$i][$j] ne 'A') {
      next;
    }


    $mas1 = ($a[$i + 1][$j + 1] eq 'M' and $a[$i - 1][$j - 1] eq 'S');
    $mas2 = ($a[$i + 1][$j + 1] eq 'S' and $a[$i - 1][$j - 1] eq 'M');
    $mas3 = ($a[$i + 1][$j - 1] eq 'M' and $a[$i - 1][$j + 1] eq 'S');
    $mas4 = ($a[$i + 1][$j - 1] eq 'S' and $a[$i - 1][$j + 1] eq 'M');

    if (($mas1 or $mas2) and ($mas3 or $mas4)) {
      $out2++;
    }
  }
}

print $out2;
