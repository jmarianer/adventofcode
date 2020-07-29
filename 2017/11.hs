import Data.List.Split

dir :: String -> (Int, Int)
dir "n" = (1, 0)
dir "s" = (-1, 0)
dir "ne" = (0, 1)
dir "nw" = (1, -1)
dir "se" = (-1, 1)
dir "sw" = (0, -1)

pairplus (x, y) (x1, y1) = (x+x1, y+y1)
distance (x, y)
  | x == 0       = y
  | y == 0       = x
  | x > 0, y > 0 = x + y
  | x < 0, y < 0 = -x - y
  | x > 0, y < 0 = max x (-y)
  | x < 0, y > 0 = max (-x) y

main = do
  c <- getContents
  let points = scanl pairplus (0, 0) $ map dir $ splitOn "," $ init c
  let distances = map distance points
  print $ last distances
  print $ maximum distances
