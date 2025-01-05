a = true
board = []
board2 = []
insts = []
$stdin.readlines(chomp: true).each { |line|
  if line == ""
    a = false
    next
  end
  if a
    board.push(line.chars)
    board2.push(line.gsub('.','..').gsub('#','##').gsub('@','@.').gsub('O','[]').chars)
  else
    insts.push(*line.chars)
  end
}

def doit(board, insts)
  dirs = {
    "<" => [0, -1],
    ">" => [0, 1],
    "^" => [-1, 0],
    "v" => [1, 0],
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
  insts.each do |inst|
    di, dj = dirs[inst]
    moves = {[i, j] => '@'}
    skip = false
    while true
      new_moves = {}
      moves.keys.each do |k|
        ii, jj = k
        ii += di
        jj += dj
        if board[ii][jj] == '#'
          skip = true
          break
        elsif board[ii][jj] == 'O'
          new_moves[[ii, jj]] = 'O'
        elsif board[ii][jj] == '['
          new_moves[[ii, jj]] = '['
          new_moves[[ii, jj+1]] = ']'
        elsif board[ii][jj] == ']'
          new_moves[[ii, jj-1]] = '['
          new_moves[[ii, jj]] = ']'
        end
      end

      if new_moves.keys - moves.keys == []
        break
      end
      moves.merge! new_moves
    end

    if skip
      next
    end
    
    moves.keys.each do |k|
      ii, jj = k
      board[ii][jj] = '.'
    end
    moves.each do |k, v|
      ii, jj = k
      ii += di
      jj += dj
      board[ii][jj] = v
    end

    i += di
    j += dj
  end

  total = 0
  (0...board.length).each do |i|
    (0...board[0].length).each do |j|
      if 'O['.include? board[i][j]
        total += 100 * i + j
      end
    end
  end
  return total
end

puts doit(board, insts)
puts doit(board2, insts)
