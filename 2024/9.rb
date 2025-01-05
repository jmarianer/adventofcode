map = $stdin.read.chomp
a = []
fnum = 0
map.chars.each do |c|
  a.push *([fnum] * c.to_i)
  fnum += 1
end

i = 0
while i < a.length
  while a[i] % 2 == 1
    a[i] = a.pop
    while a[-1] % 2 == 1
      a.pop
    end
  end
  i += 1
end

puts a.each.with_index.map { |k, v| k * v / 2 }.reduce :+

b = []
loc = 0
fnum = 0
map.chars.each do |c|
  b.push [fnum, loc, c.to_i]
  loc += c.to_i
  fnum += 1
end
fnum += 1

while fnum >= 0
  fnum -= 2

  _, loc, len = b[fnum]
  i = b.index { |onum, oloc, olen|
    onum % 2 == 1 && oloc < loc && olen >= len
  }
  if i == nil
    next
  end
  b[fnum][1] = b[i][1]
  b[i][1] += len
  b[i][2] -= len
end
puts b.map { |num, loc, len|
  if num % 2 == 1
    0
  else
    ((loc ... loc + len).reduce :+) * num / 2
  end
}.reduce :+
