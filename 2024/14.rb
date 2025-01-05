a = $stdin.readlines.map { |line|
  /^p=(.*),(.*) v=(.*),(.*)$/.match(line).captures.to_a.map &:to_i
}

max_x = 101
max_y = 103

new_poses = a.map { |line|
  x, y, dx, dy = line
 [(x + dx * 100) % max_x, (y + dy * 100) % max_y]
}
quadrants = [0, 0, 0, 0]
new_poses.each { |pos|
  x, y = pos
  if x < (max_x - 1) / 2 and y < (max_y - 1) / 2
    quadrants[0] += 1
  elsif x < (max_x - 1) / 2 and y > (max_y - 1) / 2
    quadrants[1] += 1
  elsif x > (max_x - 1) / 2 and y < (max_y - 1) / 2
    quadrants[2] += 1
  elsif x > (max_x - 1) / 2 and y > (max_y - 1) / 2
    quadrants[3] += 1
  end
}
puts quadrants.reduce &:*


(0..max_x*max_y).each { |i|
  new_poses = a.map { |line|
    x, y, dx, dy = line
    [(x + dx * i) % max_x, (y + dy * i) % max_y]
  }
  xs = new_poses.map { |xy| xy[0] }
  width = xs.max - xs.min
  ys = new_poses.map { |xy| xy[1] }
  height = ys.max - ys.min

  if width < 100 and height < 102
    puts [i, width, height].to_s
    display = (1..max_y).map { '.' * max_x }
    new_poses.each { |pos|
      x, y = pos
      display[y][x] = '*'
    }
    puts display
  end
}
