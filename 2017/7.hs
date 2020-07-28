import qualified Data.Map.Strict as Map
import Data.List

removeTrailingComma = dropWhileEnd (== ',')

getWeight :: [String] -> (String, Int)
getWeight inputLine = (prog, weight)
  where prog = head inputLine
        weight = read $ init $ tail $ inputLine !! 1

getSubs :: [String] -> (String, [String])
getSubs inputLine = (prog, subs)
  where prog = head inputLine
        subs = map removeTrailingComma $ drop 3 inputLine


main = do
  c <- getContents
  let input = map words $ lines c
  let weights = Map.fromList $ map getWeight input
  let subprogs = Map.fromList $ map getSubs input

  let root = head $ (Map.keys weights) \\ (concat $ Map.elems subprogs)
  print root
