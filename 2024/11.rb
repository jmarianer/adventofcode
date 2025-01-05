stones = $stdin.readline.split.map &:to_i
stones_h = Hash.new 0
stones.each { |it| stones_h[it] += 1 }

def new_stones(i)
  if i == 0
    [1]
  elsif i.to_s.length % 2 == 0
    s = i.to_s
    s.chars.each_slice(s.length/2).map { |subs| subs.join.to_i }
  else
    [i * 2024]
  end
end

(1..25).each {
  stones = stones.flat_map { |i| new_stones(i) }
}
puts stones.length

(1..75).each {
  stones_h_new = Hash.new 0
  stones_h.each { |i, count|
    new_stones(i).each { |j|
      stones_h_new[j] += count
    }
  }
  stones_h = stones_h_new
}
puts stones_h.values.reduce :+
