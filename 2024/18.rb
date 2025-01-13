$max = 70
all_bytes = $stdin.readlines

def fill_mem(lines)
  mem = (0..$max).map { ['.'] * ($max+1) }
  lines.each { |line|
    i,j = line.split(',').map(&:to_i)
    mem[i][j] = '#'
  }
  return mem
end

def bfs(mem)
  queue = [[0, 0, 0]]
  until queue.empty?
    i, j, len = queue.shift
    if i == $max and j == $max
      return len
    end
    if i > $max or j > $max or i < 0 or j < 0 or mem[i][j] != '.'
      next
    end
    mem[i][j] = 'O'
    queue.push(
      [i + 1, j, len + 1],
      [i - 1, j, len + 1],
      [i, j + 1, len + 1],
      [i, j - 1, len + 1],
    )
  end
end

puts bfs(fill_mem(all_bytes.take(1024)))

# Invariant: min <= first byte that doesn't work <= max
min = 1024
max = all_bytes.length

while min < max
  middle = (min + max) / 2

  if bfs(fill_mem(all_bytes.take(middle)))
    min = middle + 1
  else
    max = middle
  end
end
puts all_bytes[max - 1]

