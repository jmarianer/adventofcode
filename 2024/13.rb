require "matrix"
a = $stdin.read.split "\n\n"

total = 0
total2 = 0
a.each { |it|
  m = /.*X\+(\d+), Y\+(\d+).*X\+(\d+), Y\+(\d+).*X=(\d+), Y=(\d+).*/m.match it
  ax, ay, bx, by, px, py = m.captures.map &:to_i

  m = Matrix[[ax, ay], [bx, by]]
  v = Matrix.row_vector([px, py])
  a, b = (v / m).to_a[0]
  if a.denominator == 1 and b.denominator == 1
    total += a * 3 + b
  end

  v = Matrix.row_vector([px + 10000000000000, py + 10000000000000])
  a, b = (v / m).to_a[0]
  if a.denominator == 1 and b.denominator == 1
    total2 += a * 3 + b
  end
}
puts total.to_i
puts total2.to_i
