-- From Data.List.Tools
setAt :: [a] -> Int -> a -> [a]
setAt xs i x = take i xs ++ [x] ++ drop (i + 1) xs

next :: ([Int], Int) -> (Int -> Int) -> Maybe ([Int], Int)
next (list, cur) offsetRule
  | cur < length list = Just $ next' (list, cur)
  | otherwise         = Nothing
  where next' (list, cur) = (newList, cur + offset)
        offset = list !! cur
        newList = setAt list cur (offsetRule offset)

countSteps :: (Int -> Int) -> [Int] -> Int
countSteps offsetRule list = c' (-1) (Just (list, 0))
  where c' acc (Just x) = c' (acc + 1) (next x offsetRule)
        c' acc Nothing  = acc

offsetRule1 = (1+)
offsetRule2 x
  | x >= 3    = x - 1
  | otherwise = x + 1

main = do
  c <- getContents
  let offsets = map (read :: String -> Int) $ lines c
  print $ countSteps offsetRule1 offsets
  -- This doesn't work :-(
  print $ countSteps offsetRule2 offsets
