# while true ; do cat input1 ; done | python3 1a.py 

total = 0
freqs = {total}

for line in iter(input, None):
    total += int(line)
    if total in freqs:
        print(total)
        exit()
    freqs.add(total)
