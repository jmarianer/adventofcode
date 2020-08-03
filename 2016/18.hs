import Util
import Data.List
import Data.List.Split

input = "^^^^......^...^..^....^^^.^^^.^.^^^^^^..^...^^...^^^.^^....^..^^^.^.^^...^.^...^^.^^^.^^^^.^^.^..^.^"

nextRow :: String -> String
nextRow row = map nextRule $ divvy 3 1 ("." ++ row ++ ".")
  where nextRule "..." = '.'
        nextRule "..^" = '^'
        nextRule ".^." = '.'
        nextRule ".^^" = '^'
        nextRule "^.." = '^'
        nextRule "^.^" = '.'
        nextRule "^^." = '^'
        nextRule "^^^" = '.'

main = do
  print $ count (=='.') $ concat $ take 40 $ iterate nextRow input
  print $ count (=='.') $ concat $ take 400000 $ iterate nextRow input
