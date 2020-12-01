import Combinatorics

swords = [(8,4), (10,5), (25,6), (40,7), (74,8)]
armor  = [(0, 0), (13,1), (31,2), (53,3), (75,4), (102,5)]
ring   = [(0, 0), (0, 0), (25,1), (50,2), (100,3), (20,1), (40,2), (80,3)]

sumt (a,b) (c,d) = (a+c, b+d)

main = do
  let combos = [x:y:z | x <- swords, y <- armor, z <- tuples 2 ring]
  print $ filter (\c -> fst (foldl sumt (0,0) c) == 356) combos
  let totals = map (foldl sumt (0,0)) combos
  print $ maximum [a | (a,b) <- totals, b >= 11]
