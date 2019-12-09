words = set()

try:
    for word in iter(input, None):
        for i in range(len(word)):
            word1 = list(word)
            word1[i] = '_'
            word1 = ''.join(word1)
            if word1 in words:
                print(word1)
            words.add(word1)
except:
    # End of input
    pass
