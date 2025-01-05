def totals1(nums)
  if nums.length == 1
    return nums
  end
  return totals1(nums[1..]).flat_map { |i|
    [nums[0] + i, nums[0] * i]
  }
end

def totals2(nums)
  if nums.length == 1
    return nums
  end
  return totals2(nums[1..]).flat_map { |i|
    [nums[0] + i, nums[0] * i, "#{i}#{nums[0]}".to_i]
  }
end


ans1 = 0
ans2 = 0
$stdin.readlines.each do |line|
  total, nums = line.split(':')
  total = total.to_i
  nums = nums.split.map &:to_i
  if totals1(nums.reverse).include?(total)
    ans1 += total
  end
  if totals2(nums.reverse).include?(total)
    ans2 += total
  end
end

puts ans1
puts ans2
