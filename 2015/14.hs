-- I don't feel like writing a bad parser this time, so I'll just hardcode the input

input :: [(String, Int, Int, Int)] -- Name, speed, fly time, rest time
input = [
  ("Vixen",    8,  8,  53),
  ("Blitzen", 13,  4,  49),
  ("Rudolph", 20,  7, 132),
  ("Cupid",   12,  4,  43),
  ("Donner",   9,  5,  38),
  ("Dasher",  10,  4,  37),
  ("Comet",    3, 37,  76),
  ("Prancer",  9, 12,  97),
  ("Dancer",  37,  1,  36)]

distance :: (String, Int, Int, Int) -> Int -> Int
distance (_, speed, fly, rest) time =
  (full * fly + (min fly part)) * speed
  where (full, part) = time `divMod` (fly + rest)

points :: [Int] -> [Int]
points ds = map (\x -> if x == maximum ds then 1 else 0) ds

main = do
  print $ maximum $ map ((flip distance) 2503) input

  let distances = map (\d -> map ((flip distance) d) input) [1..2503]
  print $ maximum $ foldr (zipWith (+)) [0,0,0,0,0,0,0,0,0] $ map points distances
