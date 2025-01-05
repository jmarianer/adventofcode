ss = $stdin.readlines.map &:to_i
tot = 0
monkeys = []
ss.each { |s|
  monkey = []
  2000.times {
    s ^= s * 64
    s %= 16777216

    s ^= s / 32
    s %= 16777216

    s ^= s * 2048
    s %= 16777216
  
    monkey.push s
  }
  monkeys.push monkey
}
puts monkeys.map { |m| m[-1] }.reduce &:+

total_sales = Hash.new 0
monkeys.each { |m|
  prices = m.map { |x| x % 10 }
  diffs = prices.each_cons(2).map { |q| q[1] - q[0] }
  diff_to_price = Hash.new
  diffs.each_cons(4).each_with_index { |d, i|
    unless diff_to_price.key? d
      diff_to_price[d] = prices[i + 4]
    end
  }
  diff_to_price.each { |k, v|
    total_sales[k] += v
  }
}
k, v = total_sales.max_by { |k, v| v }
puts v