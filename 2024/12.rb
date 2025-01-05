$field = $stdin.readlines.map(&:chomp).map(&:chars)

def find_region(i, j, c)
  if i < 0 || i >= $field.length || j < 0 || j >= $field[0].length || $field[i][j] != c
    return {}
  end

  $field[i][j] = nil
  return {[i, j] => 1}.merge(
    find_region(i, j+1, c),
    find_region(i, j-1, c),
    find_region(i+1, j, c),
    find_region(i-1, j, c)
  )
end

regions = []
(0...$field.length).each { |i|
  (0...$field[0].length).each { |j|
    if $field[i][j]
      regions.push find_region(i, j, $field[i][j])
    end
  }
}

def region_perimeter(region)
  sum = 0
  region.each{ |key, _|
    i, j = key
    if !region[[i, j+1]]
      sum += 1
    end
    if !region[[i, j-1]]
      sum += 1
    end
    if !region[[i+1, j]]
      sum += 1
    end
    if !region[[i-1, j]]
      sum += 1
    end
  }
  return sum
end

puts regions.map { |r|
  region_perimeter(r) * r.keys.length
}.reduce &:+

def perimeter_sides(region)
  s1 = Hash.new { |hash, key| hash[key] = [] } 
  s2 = Hash.new { |hash, key| hash[key] = [] } 
  s3 = Hash.new { |hash, key| hash[key] = [] } 
  s4 = Hash.new { |hash, key| hash[key] = [] } 
  region.each{ |key, _|
    i, j = key
    if !region[[i, j+1]]
      s1[j].push(i)
    end
    if !region[[i, j-1]]
      s2[j-1].push(i)
    end
    if !region[[i+1, j]]
      s3[i].push(j)
    end
    if !region[[i-1, j]]
      s4[i-1].push(j)
    end
  }

  sum = 0
  as = s1.values + s2.values + s3.values + s4.values
  as.each do |a|
    a.sort!
    while a.length > 0
      sum += 1
      while a[0] + 1 == a[1]
        a.shift
      end
      a.shift
    end
  end

  return sum
end

regions.each do |r|
  puts r.to_s
  puts perimeter_sides(r)
end

puts regions.map { |r|
  perimeter_sides(r) * r.keys.length
}.reduce &:+

