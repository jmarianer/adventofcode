$\ = "\n";

sub safe {
  my @a = @_;
  $inc = ($a[1] > $a[0]);
  for my $i (1..$#a) {
    $inc2 = ($a[$i] > $a[$i-1]);
    if ($inc != $inc2 || abs($a[$i] - $a[$i-1]) > 3 || $a[$i] == $a[$i-1]) {
      return 0;
    }
  }
  return 1;
}

OUTER: while (<>) {
  @a = split;
  if (safe(@a)) {
    $out++;
    $out2++;
    next;
  }

  for my $i (0..$#a) {
    @b = @a[0..$i-1,$i+1..$#a];
    if (safe(@b)) {
      $out2++;
      next OUTER;
    }
  }
}

print $out;
print $out2;
