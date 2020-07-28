import Data.List

-- From Data.List.Extra
anySame :: Eq a => [a] -> Bool
anySame = f []
    where
        f seen (x:xs) = x `elem` seen || f (x:seen) xs
        f seen [] = False

main = do
  c <- getContents
  let phrases = map words $ lines c
  let valid = filter (not . anySame) phrases
  print $ length valid

  let sorted = (map.map) sort phrases
  let valid = filter (not . anySame) sorted
  print $ length valid
