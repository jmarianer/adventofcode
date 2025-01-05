$everything = $stdin.read.split("\n\n")[1]

def swap(x, y)
  $everything.gsub!("-> #{x}", '-> tmp')
  $everything.gsub!("-> #{y}", "-> #{x}")
  $everything.gsub!('-> tmp', "-> #{y}")
end

def rename(a, op, b, target)
  m1 = /#{a} #{op} #{b} -> (...)/.match($everything)
  m2 = /#{b} #{op} #{a} -> (...)/.match($everything)
  m = m1 || m2
  if m.nil?
    return
  end
  old_target = m[1]
  $everything.gsub!(old_target, target)


end

swap 'mvb', 'z08'
swap 'wss', 'z18'
swap 'bmn', 'z23'
swap 'rds', 'jss'

45.times { |i|
  c = i.to_s.rjust(2, '0')
  if i == 0
    rename "x#{c}", "XOR", "y#{c}", "z#{c}"
    rename "x#{c}", "AND", "y#{c}", "c#{c}"
  else
    c1 = (i-1).to_s.rjust(2, '0')
    rename "x#{c}", "XOR", "y#{c}", "q#{c}"
    rename "x#{c}", "AND", "y#{c}", "r#{c}"

    rename "q#{c}", "XOR", "c#{c1}", "z#{c}"
    rename "q#{c}", "AND", "c#{c1}", "s#{c}"

    rename "s#{c}", "OR", "r#{c}", "c#{c}"
  end
}

#puts $everything.lines.sort_by { |c| c[1..2] }

puts ['mvb', 'z08', 'wss', 'z18', 'bmn', 'z23', 'rds', 'jss'].sort.join ','

# x00 XOR y00 => q00
# x00 AND y00 => r00

# q00 XOR c-1 => z00
# q00 AND c-1 => s00

# s00 OR r00 => c00

