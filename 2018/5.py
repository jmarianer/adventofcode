polymer=input()
letters='abcdefghijklmnopqrstuvwxyz'

def react(polymer):
    while True:
        old_polymer = polymer
        for letter in letters:
            polymer = polymer.replace(letter + letter.upper(), '')
            polymer = polymer.replace(letter.upper() + letter, '')

        if old_polymer == polymer:
            return polymer

# Part I
print(len(react(polymer)))

# Part II
lens = {}
for letter in letters:
    polymer1 = polymer.replace(letter, '').replace(letter.upper(), '')
    lens[letter] = len(react(polymer1))
print(min(lens.values()))
