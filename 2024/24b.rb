pins = []
$stdin.readlines.each { |line|
  if m = /^(...): (.)/.match(line)
  elsif m = /^(...) (OR|AND|XOR) (...) -> (...)/.match(line)
    a, op, b, p = m.captures
    pins.push [p, a, op, b]
  end
}

rename = Hash.new { |hash, key| hash[key] = key }
pins.each { |it|
  p, a, op, b = it
  a = rename[a]
  b = rename[b]
  if a[1..] == b[1..]
    if op == 'XOR'
      rename[p] = 's' + a[1..]
    else
      rename[p] = 'c' + a[1..]
    end
  end
}

pins.sort.each { |it|
  p, a, op, b = it
  puts "#{rename[p]} = #{rename[a]} #{op} #{rename[b]}"
}