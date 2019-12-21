def is_valid(p, allow_larger_group=True):
    digits = []
    while p > 0:
        digits.append(p % 10)
        p //= 10
    digits = list(reversed(digits))

    has_double_digit = False
    for i in range(1,6):
        if digits[i] == digits[i-1]:
            if allow_larger_group:
                has_double_digit = True
            else:
                if (i == 1 or digits[i-2] != digits[i]) and \
                   (i == 5 or digits[i+1] != digits[i]):
                       has_double_digit = True

        if digits[i] > digits[i-1]:
            return False
    return has_double_digit

input_range = range(234208,765870)
print(len([i for i in input_range if is_valid(i, True)]))
print(len([i for i in input_range if is_valid(i, False)]))
