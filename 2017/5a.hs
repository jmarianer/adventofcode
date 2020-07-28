import qualified Data.Map.Strict as Map

next :: (Map.Map Int Int, Int) -> (Int -> Int) -> Maybe (Map.Map Int Int, Int)
next (map, cur) offsetRule = do
  offset <- Map.lookup cur map
  let newMap = Map.update (Just . offsetRule) cur map
  return (newMap, cur + offset)

countSteps :: Map.Map Int Int -> (Int -> Int) -> Int
countSteps initialMap offsetRule = c' (Just (initialMap, 1)) (-1)
  where c' (Just x) acc = c' (next x offsetRule) $! (acc + 1)
        c' Nothing  acc = acc

offsetRule1 = (1+)
offsetRule2 x
  | x >= 3    = x - 1
  | otherwise = x + 1

main = do
  c <- getContents
  let offsets = map (read :: String -> Int) $ lines c
  let offsetsMap = Map.fromList ([1..] `zip` offsets)
  print $ countSteps offsetsMap offsetRule1
  print $ countSteps offsetsMap offsetRule2
