patterns = $stdin.readline.chomp.split /, /
$stdin.readline
requests = $stdin.readlines(chomp: true)

$g = { '' => 1 }
def possible(p, patterns)
  if $g.include? p
    return $g[p]
  end
  total = 0
  patterns.each { |prefix|
    if p.start_with? prefix 
      total += possible(p.delete_prefix(prefix), patterns)
    end
  }
  return $g[p] = total
end


pp = requests.map { |p| possible(p, patterns) }
puts pp.count { |i| i > 0 }
puts pp.reduce &:+
