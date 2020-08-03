import Site

import qualified Data.Map as Map
import qualified Data.Set as Set
import Data.List
import Data.List.Ordered

type State = [Set.Set String]

{- Test data
source :: State
source = [Set.fromList ["E", "HM", "LM"],
          Set.singleton "HG",
          Set.singleton "LG",
          Set.empty]
-}

-- Real data
-- bottomFloor = Set.fromList ["E", "SG", "SM", "PG", "PM"]
-- part 2
bottomFloor = Set.fromList ["E", "SG", "SM", "PG", "PM", "EG", "EM", "DG", "DM"]
source = [bottomFloor,
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

-- This is an idea I got from Reddit. The gist is we replace the first
-- character with a digit, where the digits are in the order that the
-- characters appear in the state. That way if EM, EG are on floor 1 and CM, CG
-- are on floor 2, it gets distilled the same as if E and G were replaced.
-- With this optimization, part I runs in 14s instead of 4m, and part II
-- finishes in under four minutes instead of me getting pissed off and
-- aborting.
distillState :: State -> State
distillState s = map (Set.map inNewOrder) s
  where newOrder :: [Char]
        newOrder = map head $ filter (\s -> length s == 2 && s !! 1 == 'M') $ concat $ map Set.toList s
        inNewOrder :: String -> String
        inNewOrder "E" = "E"
        inNewOrder (c:cs) = show o ++ cs
          where Just o = elemIndex c newOrder

adjacent state = targetStates
  where Just elevFloor = findIndex (Set.member "E") state
        sameFloor = Set.delete "E" $ state !! elevFloor
        targetFloors :: Int -> [Int]
        targetFloors 0 = [1]
        targetFloors 1 = [0, 2]
        targetFloors 2 = [1, 3]
        targetFloors 3 = [2]
        targetStates = [(distillState $ updateState state elevFloor targetFloor ["E", item1, item2], (targetFloor, item1, item2)) |
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

targetState :: State -> Bool
targetState s = (init s) == [Set.empty, Set.empty, Set.empty]

main = do
  let directions = bfs source adjacentAndValid targetState Nothing
      finalState = filter (targetState . fst) $ Map.toList directions
  print $ length $ snd $ head finalState
