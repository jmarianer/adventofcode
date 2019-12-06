def valid(p):
    digits = []
    while p > 0:
        digits.append(p % 10)
        p //= 10
    digits = list(reversed(digits))

    double = False
    for i in range(1,6):
        if digits[i] == digits[i-1]:
            # Part I:
            # double = True
            # Part II:
            if (i == 1 or digits[i-2] != digits[i]) and \
               (i == 5 or digits[i+1] != digits[i]):
                   double = True

        if digits[i] > digits[i-1]:
            return False
    return double

count = 0

for i in range(234208,765870):
    if valid(i):
        print(i)
        count += 1

print(count)
