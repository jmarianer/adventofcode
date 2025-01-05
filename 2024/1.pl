$\ = "\n";

while (<>) {
  ($a, $b) = split;
  push @a, $a;
  push @b, $b;
}

@a = sort @a;
@b = sort @b;

$out = 0;
for my $i (0 .. $#a) {
  $out += abs($a[$i] - $b[$i]);
}

print $out;


for my $b (@b) {
  $b{$b}++;
}

for my $a (@a) {
  $out2 += $a * $b{$a};
}
print $out2;
