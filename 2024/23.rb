h = Hash.new { |hash, key| hash[key] = Set[] }
s2 = Set[]
$stdin.readlines(chomp: true).each { |line|
  from, to = line.split /-/
  h[from].add to
  h[to].add from
  s2.add Set[from, to]
}

s = Set[]
h.each.filter { |k, v| k.start_with? 't' }.each { |k, v|
  v.each { |v1|
    v.each { |v2|
      if h[v1].include? v2
        s.add [k, v1, v2].to_set
      end
    }
  }
}
puts s.length

while s2.count > 1
  s3 = Set[]
  s2.each { |s|
    a = s.to_a
    v1 = a.shift
    h[v1].each { |v2|
      if !s.include? v2 and a.all? { |v3| h[v2].include? v3 }
        s3.add s + [v2]
      end
    }
  }
  s2 = s3
end

puts s3.to_a[0].sort.join ','
