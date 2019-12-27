elf1 = 0
elf2 = 1
recipes = [3, 7]

INPT=939601

done1 = False
done2 = False

def append_recipe(r):
    recipes.append(r)
    desired = str(INPT)
    last = ''.join(str(r) for r in recipes[-len(desired):])
    #print(len(recipes), last, desired)
    if last == desired:
        print(len(recipes) - len(desired))
        exit()

while True:
    if len(recipes) >= INPT+10 and not done1:
        print(''.join(str(i) for i in recipes[INPT:INPT+10]))
        done1 = True

    sum = recipes[elf1] + recipes[elf2]
    if sum >= 10:
        append_recipe(1)
        sum -= 10
    append_recipe(sum)

    elf1 += recipes[elf1] + 1
    elf2 += recipes[elf2] + 1
    elf1 %= len(recipes)
    elf2 %= len(recipes)

