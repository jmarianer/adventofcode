$\ = "\n\n";
while (<>) {
  chomp;
  push @a, [split //, "$_"];
}
$, = "\n";

A: for $ii (0 .. $#a) {
  for $jj (0 .. $#{$a[0]}) {
    if ($a[$ii][$jj] eq '^') {
      $i = $ii;
      $j = $jj;
      last A;
    }
  }
}

$di = -1;
$dj = 0;

while (1) {
  $ni = $i + $di;
  $nj = $j + $dj;


  last if ($ni > $#a or $ni < 0 or $nj > $#{$a[0]} or $nj < 0);

# print "$i $j $ni $nj $a[$ni][$nj]";
  if ($a[$ni][$nj] eq '#') {
    ($di, $dj) = ($dj, -$di);
  } else {
    ($i, $j) = ($ni, $nj);
    $a[$i][$j] = 'X';
  }
}

for $i (0 .. $#a) {
  for $j (0 .. $#{$a[0]}) {
    if ($a[$i][$j] eq 'X' or $a[$i][$j] eq '^') {
      $out++;
    }
  }
}

print $out;
