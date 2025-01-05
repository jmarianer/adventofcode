class Comp
  def initialize(a, b, c, prog)
    @a = a
    @b = b
    @c = c
    @p = prog
    @ip = 0
  end

  def combo(x)
    case x
    when 0..3
      return x
    when 4
      return @a
    when 5
      return @b
    when 6
      return @c
    end
  end

  def inst(op, x)
    case op
    when 0
      @a >>= combo(x)
    when 1
      @b ^= x
    when 2
      @b = combo(x) % 8
    when 3
      if @a > 0
        @ip = x - 2
      end
    when 4
      @b ^= @c
    when 5
      @out.push(combo(x) % 8)
    when 6
      @b = @a >> combo(x)
    when 7
      @c = @a >> combo(x)
    end
  end

  def run_prog
    @out = []
    while @ip < @p.length
      inst(@p[@ip], @p[@ip+1])
      @ip += 2
    end
    return @out
  end
end

p = [2,4,1,2,7,5,0,3,1,7,4,1,5,5,3,0]
# b = a % 8 ^ 2
# c = (a >> b) % 8
# b ^= 7 ^ c
# output b
# a = a >> 3
puts Comp.new(
  27334280, 0, 0, p
).run_prog.join(',')

#p = [0,3,5,4,3,0]
def get_a(reverse_prog, a, p)
  if !reverse_prog || reverse_prog.empty?
    return a / 8
  end
  (0...8).each do |x|
    out = Comp.new(a + x, 0, 0, p).run_prog
    last = out[0]
    if last == reverse_prog[0]
      new_a = (a + x) * 8
      maybe = get_a(reverse_prog[1..], new_a, p)
      if maybe
        return maybe
      end
    end
  end
  return nil
end

puts get_a(p.reverse, 0, p)
puts Comp.new(
  23794261549176, 0, 0, p
).run_prog.join(',')

puts Comp.new(
  190615597431823, 0, 0, p
).run_prog.join(',')
