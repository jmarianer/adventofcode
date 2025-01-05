$\ = "\n";

sub sortrule {
  if ($rules{"$a|$b"}) {
    return 1;
  }
  if ($rules{"$b|$a"}) {
    return -1;
  }
  return 0;
}

while (<>) {
  chomp;
  if ($_ eq '') {
    $updates = 1;
    next;
  }
  if ($updates) {
    push @updates, $_;
  } else {
    $rules{$_} = 1;
  }
}

$, = ';';
UPD: for (@updates) {
  @u = split /,/;
  for $i (0..$#u) {
    for $j ($i + 1 .. $#u) {
      if ($rules{"$u[$j]|$u[$i]"}) {
        @u = sort sortrule @u;
        $out2 += $u[$#u / 2];
        next UPD;
      }
    }
  }
  $out += $u[$#u / 2];
}

print $out;
print $out2;
