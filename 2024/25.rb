keys = []
locks = []

$stdin.read.split("\n\n").each do |schema|
  lines = schema.split "\n"
  code = [-1, -1, -1, -1, -1]
  lines.each { |line|
    line.chars.each_with_index { |c, i|
      if c == '#'
        code[i] += 1
      end
    }
  }
  if lines[0] == '.....'
    keys.push code
  else
    locks.push code
  end
end

total = 0
keys.each { |key|
  locks.each { |lock|
    if key.zip(lock).all? { |x| x[0] + x[1] < 6 }
      total += 1
    end
  }
}
p total