import Site

import qualified Data.Map as Map
import qualified Data.Set as Set
import Data.List
import Data.List.Ordered

type State = [Set.Set String]

{- Test data
target :: State
target = [Set.empty, Set.empty, Set.empty, Set.fromList ["E", "HG", "HM", "LG", "LM"]]

source :: State
source = [Set.fromList ["E", "HM", "LM"],
          Set.singleton "HG",
          Set.singleton "LG",
          Set.empty]
-}

-- Real data 1
target = [Set.empty, Set.empty, Set.empty, Set.fromList ["E", "SG", "SM", "PG", "PM", "RG", "RM", "TG", "TM", "CG", "CM"]]
source = [Set.fromList ["E", "SG", "SM", "PG", "PM"],
          Set.fromList ["TG", "RG", "RM", "CG", "CM"],
          Set.singleton "TM",
          Set.empty]

updateList :: [a] -> Int -> (a->a) -> [a]
updateList [] _ _ = []
updateList (x:xs) index fn =
  if index == 0
  then (fn x):xs
  else x:(updateList xs (index-1) fn)

updateState state oldFloor newFloor elems = finalState
  where state1 = updateList state oldFloor (\s -> Set.difference s $ Set.fromList elems)
        finalState = updateList state1 newFloor (\s -> Set.union s $ Set.fromList elems)

adjacent state = targetStates
  where Just elevFloor = findIndex (Set.member "E") state
        sameFloor = Set.delete "E" $ state !! elevFloor
        targetFloors :: Int -> [Int]
        targetFloors 0 = [1]
        targetFloors 1 = [0, 2]
        targetFloors 2 = [1, 3]
        targetFloors 3 = [2]
        targetStates = [(updateState state elevFloor targetFloor ["E", item1, item2], (targetFloor, item1, item2)) |
                         item1 <- Set.toList sameFloor, item2 <- Set.toList sameFloor,
                         targetFloor <- targetFloors elevFloor]

validFloor :: Set.Set String -> Bool
validFloor floor = gens == "" || chips `subset` gens
  where gens = find 'G' $ Set.toList floor
        chips = find 'M' $ Set.toList floor
        is _ "E" = False
        is c (_:d:[]) = (c==d)
        find c es = sort $ map head $ filter (is c) es

validState :: State -> Bool
validState = all validFloor

adjacentAndValid = filter valid . adjacent
  where valid = validState . fst

main = do
  let directions = bfs source adjacentAndValid (== target) Nothing
      Just dir = Map.lookup target directions
  print $ length dir
