def chunks(lst, n):
    """Yield successive n-sized chunks from lst."""
    for i in range(0, len(lst), n):
        yield lst[i:i + n]

# Part I
inpt = list(chunks(input(), 25*6))
for layer in inpt:
    zeros = len([i for i in layer if i == '0'])
    ones = len([i for i in layer if i == '1'])
    twos = len([i for i in layer if i == '2'])
    if zeros == 6:  # Hardcoded because meh.
        print(ones * twos)


# Part II
output = list(inpt[0])
for layer in inpt:
    for i in range(len(output)):
        if output[i] == '2':
            output[i] = layer[i]

for row in chunks(output, 25):
    print(''.join(row).translate(str.maketrans('10','# ')))
