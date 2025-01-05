perl -ne 's/mul\((\d+),(\d+)\)/$out += $1*$2/ge; END{print "$out\n"}' < input3


perl -ne 'BEGIN {$k = 1; } s/(do)(n'\''t)?\(\)|mul\((\d+),(\d+)\)/$k=($2 eq "" ? 1 : 0) if $1; $out += $3*$4*$k/ge; END{print "$out\n"}' < input3
