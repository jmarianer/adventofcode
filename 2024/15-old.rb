a = true
board = []
insts = []
$stdin.readlines(chomp: true).each { |line|
  if line == ""
    a = false
    next
  end
  if a
    board.push(line.chars)
  else
    insts.push(*line.chars)
  end
}

pos = []
(0...board.length).each do |i|
  (0...board[0].length).each do |j|
    if board[i][j] == '@'
      pos = [i, j]
    end
  end
end

i, j = pos
dirs = {
  "<" => [0, -1],
  ">" => [0, 1],
  "^" => [-1, 0],
  "v" => [1, 0],
}
insts.each do |inst|
  di, dj = dirs[inst]
  ii, jj = i, j
  skip = false
  while true
    ii += di
    jj += dj
    if board[ii][jj] == '#'
      skip = true
      break
    elsif board[ii][jj] == '.'
      skip = false
      break
    end
  end
  if skip
    next
  end
  
  ii, jj = i, j
  o = '@'
  board[ii][jj] = '.'
  while true
    ii += di
    jj += dj
    oo = board[ii][jj]
    board[ii][jj] = o
    if oo == '.'
      break
    end
    o = oo
  end
  i += di
  j += dj
end

total = 0
(0...board.length).each do |i|
  (0...board[0].length).each do |j|
    if board[i][j] == 'O'
      total += 100 * i + j
    end
  end
end
puts total
