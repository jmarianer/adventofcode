track = $stdin.readlines(chomp: true).map &:chars

startpos = endpos = 9
(0...track.length).each do |i|
  (0...track[0].length).each do |j|
    if track[i][j] == 'S'
      startpos = [i, j]
    end
    if track[i][j] == 'E'
      endpos = [i, j]
    end
  end
end

def bfs(track, i, j)
  queue = [[i, j, 0]]
  until queue.empty?
    i, j, len = queue.shift
    if i > track.length or j > track[i].length or i < 0 or j < 0 or !['S','E','.'].include?(track[i][j])
      next
    end
    track[i][j] = len
    queue.push(
      [i + 1, j, len + 1],
      [i - 1, j, len + 1],
      [i, j + 1, len + 1],
      [i, j - 1, len + 1],
    )
  end
end

bfs(track, *startpos)
i, j = endpos

total = 0
(1...(track.length - 1)).each do |i|
  (1...(track[0].length - 1)).each do |j|
    if track[i][j] == '#'
      if track[i-1][j].is_a? Integer and track[i+1][j].is_a? Integer
        saved = track[i-1][j] - track[i+1][j]
      elsif track[i][j-1].is_a? Integer and track[i][j+1].is_a? Integer
        saved = track[i][j-1] - track[i][j+1]
      else
        saved = 2
      end
      if saved.abs > 100
        total += 1
      end
    end
  end
end
puts total

cheats = Hash.new { |hash, key| hash[key] = Set[] }
(1...track.length).each do |i|
  (1...track[0].length).each do |j|
    if track[i][j].is_a? Integer
      (-20..20).each do |di|
        max_dj = 20 - di.abs
        (-max_dj..max_dj).each do |dj|
          ni = i + di
          nj = j + dj
          if ni >= 0 and nj >= 0 and !track[ni].nil? and track[ni][nj].is_a? Integer
            saved = track[ni][nj] - track[i][j] - di.abs - dj.abs
            cheats[saved].add [i, j, ni, nj]
          end
        end
      end
    end
  end
end

#puts track.map { |l|
#  l.map { |v|
#    v.to_s.rjust 3
#  }.join
#}
p cheats.filter { |k, v|
  k >= 100
}.map { |k, v|
  v.length
}.reduce &:+
