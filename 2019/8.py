import more_itertools

LAYER_WIDTH = 25
LAYER_HEIGHT = 6

inpt = list(more_itertools.chunked(input(), LAYER_WIDTH * LAYER_HEIGHT))

# Part I
number_counts = [tuple(len([i for i in layer if i == val]) for val in '012') for layer in inpt]
fewest_zeros = sorted(number_counts)[0]
print(fewest_zeros[1] * fewest_zeros[2])

# Part II
output = list(inpt[0])
for layer in inpt:
    for i in range(len(output)):
        if output[i] == '2':
            output[i] = layer[i]

for row in more_itertools.chunked(output, LAYER_WIDTH):
    print(''.join(row).translate(str.maketrans('10','# ')))
