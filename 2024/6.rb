map = $stdin.readlines(chomp: true).map &:chars
i = map.find_index { |l| l.include? '^' }
j = map[i].find_index '^'

def positions(map, i, j)
  di, dj = -1, 0
  visited = Set[[i, j, di, dj]]

  while true
    ni = i + di
    nj = j + dj
    if ni < 0 or nj < 0 or map[ni] == nil or map[ni][nj] == nil
      return visited
    end

    if map[ni][nj] == '#'
      di, dj = dj, -di
    else
      i, j = ni, nj
    end
    if visited.include? [i, j, di, dj]
      return nil
    end
    visited.add [i, j, di, dj]
  end
end

path = positions(map, i, j).map { |x| x[0..1] }.to_set
puts path.length

blocks = Set[]
path.each { |ij|
  ii, jj = ij
  if map[ii][jj] == '.'
    map[ii][jj] = '#'
    if positions(map, i, j).nil?
      blocks.add [ii, jj]
    end
    map[ii][jj] = '.'
  end
}
puts blocks.length
