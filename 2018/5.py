polymer=input()
letters='abcdefghijklmnopqrstuvwxyz'

while True:
    old_polymer = polymer
    for letter in letters:
        polymer = polymer.replace(letter + letter.upper(), '')
        polymer = polymer.replace(letter.upper() + letter, '')

    if old_polymer == polymer:
        break

print(len(polymer))
