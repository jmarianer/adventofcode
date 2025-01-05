inputs = %w(029 980 179 456 379)
inputs = %w(670 974 638 319 508)

keypad = %w(
789
456
123
X0A
<v>)
pad = {}
(0...keypad.length).each { |i|
  (0...keypad[i].length).each { |j|
    pad[keypad[i][j]] = [i,j]
  }
}
pad['^'] = pad['0']
pad.delete 'X'

def getstring(pad, string)
  i, j = pad['A']
  out = ''
  string.chars.each { |c|
    ii, jj = pad[c]
    if jj == 0 and i == 3 # e.g. 0 to 7, need to avoid the gap
      if ii > i
        out += 'v' * (ii - i)
      end
      if ii < i
        out += '^' * (i - ii)
      end
      if jj < j
        out += '<' * (j - jj)
      end
      if jj > j
        out += '>' * (jj - j)
      end
    elsif j == 0 and ii == 3 # vice versa
      if jj < j
        out += '<' * (j - jj)
      end
      if jj > j
        out += '>' * (jj - j)
      end
      if ii > i
        out += 'v' * (ii - i)
      end
      if ii < i
        out += '^' * (i - ii)
      end
    else # try to end on ^ or > which are closer to A
      if jj < j
        out += '<' * (j - jj)
      end
      if ii > i
        out += 'v' * (ii - i)
      end
      if ii < i
        out += '^' * (i - ii)
      end
      if jj > j
        out += '>' * (jj - j)
      end
    end
    out += 'A'
    i, j = ii, jj
  }
  return out
end

puts inputs.map { |i|
  s = getstring(pad, i + 'A')
  2.times {
    s = getstring(pad, s)
  }
  s.length * i.to_i
}.reduce &:+

puts inputs.map { |i|
  s = getstring(pad, i + 'A').split(/A/).tally
  s[""] = 0
  25.times {
    new_s = Hash.new(0)
    s.each { |key, val|
      getstring(pad, key + 'A').split(/A/).tally.each { |k2, v2|
        new_s[k2] += val * v2
      }
    }
    new_s[""] += s[""]
    s = new_s
  }
  l = s.each.map { |k, v| v * (k.length + 1) }.reduce &:+
  l * i.to_i
}.reduce &:+
