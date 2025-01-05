pins = {}
$stdin.readlines.each { |line|
  if m = /^(...): (.)/.match(line)
    p, v = m.captures
    pins[p] = v.to_i
  elsif m = /^(...) (OR|AND|XOR) (...) -> (...)/.match(line)
    a, op, b, p = m.captures
    pins[p] = [a, op, b]
  end
}

ops = {
  "OR" =>  lambda { |x, y| x | y },
  "AND" => lambda { |x, y| x & y },
  "XOR" => lambda { |x, y| x ^ y },
}

while pins.values.any? { |v| v.is_a? Array }
  pins.each { |k, v|
    a, op, b = v
    if pins[a].is_a? Integer and pins[b].is_a? Integer
      pins[k] = ops[op].(pins[a], pins[b])
    end
  }
end

n = 0
(0..100).reverse_each { |i|
  k = "z%02d" % i
  if pins.key? k
    n = n * 2 + pins[k]
  end
}
puts n
