map = $stdin.readlines(chomp: true).map { |line| [nil] + (line.chars.map &:to_i) + [nil] }
map.push [nil] * map[0].length
map.unshift [nil] * map[0].length

scores = (1..map.length).map { [nil] * map[0].length }

(1...map.length).each do |i|
  (1...map.length).each do |j|
    if map[i][j] == 9
      scores[i][j] = [[i,j]]
    end
  end
end
(0..8).to_a.reverse.each do |height|
  (1...map.length).each do |i|
    (1...map.length).each do |j|
      if map[i][j] == height
        score = []
        if map[i][j-1] == height+1
          score += scores[i][j-1]
        end
        if map[i][j+1] == height+1
          score += scores[i][j+1]
        end
        if map[i-1][j] == height+1
          score += scores[i-1][j]
        end
        if map[i+1][j] == height+1
          score += scores[i+1][j]
        end
        scores[i][j] = score
      end
    end
  end
end

total = 0
total2 = 0
(1...map.length).each do |i|
  (1...map.length).each do |j|
    if map[i][j] == 0
      total += scores[i][j].uniq.length
      total2 += scores[i][j].length
    end
  end
end
puts total, total2
