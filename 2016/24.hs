import Site

import qualified Data.Map as Map
import qualified Data.Set as Set

import Data.List

type Field = [String]
type State = ((Int, Int), Set.Set Char)

(!!!) :: Field -> (Int, Int) -> Char
field !!! (x, y) = field !! y !! x

adjacent :: Field -> State -> [(State, Direction)]
adjacent field (loc, set) = concatMap newState [Up, Dn, Lt, Rt]
  where newState dir = case field !!! newLoc of
                         '#' -> []
                         '.' -> [((newLoc, set), dir)]
                         '0' -> [((newLoc, set), dir)]
                         c   -> [((newLoc, Set.insert c set), dir)]
                       where newLoc = move dir loc

main = do
  c <- getContents
  let field = transpose $ lines c
      digits = Set.fromList $ filter ((flip elem) ['1'..'9']) c
      Just startY = findIndex (elem '0') field
      Just startX = findIndex (== '0') $ field !! startY
      goal :: State -> Bool
      goal (_, collected) = collected == digits
      source = ((startX, startY), Set.empty)

      directions = bfs source (adjacent field) goal Nothing

  print $ length $ snd $ head $ filter (goal . fst) $ Map.toList directions

  let goal = (== ((startX, startY), digits))
      directions = bfs source (adjacent field) goal Nothing
  print $ length $ snd $ head $ filter (goal . fst) $ Map.toList directions
