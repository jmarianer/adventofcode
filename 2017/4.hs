import Data.List
import Data.List.Extra

main = do
  c <- getContents
  let phrases = map words $ lines c
  let valid = filter (not . anySame) phrases
  print $ length valid

  let sorted = (map.map) sort phrases
  let valid = filter (not . anySame) sorted
  print $ length valid
