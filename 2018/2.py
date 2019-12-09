from collections import defaultdict

twos = 0
threes = 0

try:
    for word in iter(input, None):
        freq = defaultdict(lambda: 0)
        for i in word:
            freq[i] += 1
        if 2 in freq.values():
            twos += 1
        if 3 in freq.values():
            threes += 1
except:
    # End of input
    pass

print(twos * threes)
