places = Hash.new { |hash, key| hash[key] = [] }

$stdin.readlines(chomp: true).each.with_index do |line, x|
  line.chars.each.with_index do |char, y|
    if char != '.'
      places[char].push([x, y])
    end
  end
end

max = 50

antinodes1 = {}
places.each do |key, val|
  val.each do |a|
    val.each do |b|
      if a != b
        x1, y1 = a
        x2, y2 = b
        x = x1 + (x2-x1) * 2
        y = y1 + (y2-y1) * 2
        if x >= 0 && x < max && y >= 0 && y < max
          antinodes1["#{x} #{y}"] = 1
        end
      end
    end
  end
end
puts antinodes1.count

antinodes2 = {}
places.each do |key, val|
  val.each do |a|
    val.each do |b|
      if a != b
        x1, y1 = a
        x2, y2 = b
        x = x1
        y = y1
        while x >= 0 && x < max && y >= 0 && y < max
          antinodes2["#{x} #{y}"] = 1
          x += (x2-x1)
          y += (y2-y1)
        end
      end
    end
  end
end
puts antinodes2.count
