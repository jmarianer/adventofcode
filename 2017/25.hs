import qualified Data.Map.Strict as Map
import Data.List

data Direction = Lt | Rt deriving Show
type StateRule = (Bool, Direction, Char)
type Machine = Map.Map Char (StateRule, StateRule)

-- Gonna skip the parsing and hardcode the test input
testMachine = Map.fromList [
  ('A', ((True, Rt, 'B'), (False, Lt, 'B'))),
  ('B', ((True, Lt, 'A'), (True,  Rt, 'A')))]
prodMachine = Map.fromList [
  ('A', ((True, Rt, 'B'), (False, Lt, 'E'))),
  ('B', ((True, Lt, 'C'), (False, Rt, 'A'))),
  ('C', ((True, Lt, 'D'), (False, Rt, 'C'))),
  ('D', ((True, Lt, 'E'), (False, Lt, 'F'))),
  ('E', ((True, Lt, 'A'), (True,  Lt, 'C'))),
  ('F', ((True, Lt, 'E'), (True,  Rt, 'A')))]

type State = ([Bool], [Bool], Char)

headOrFalse :: [Bool] -> Bool
headOrFalse (x:_) = x
headOrFalse [] = False

ht :: [Bool] -> (Bool, [Bool])
ht (x:xs) = (x, xs)
ht [] = (False, [])

replFirst :: [Bool] -> Bool -> [Bool]
replFirst (x:xs) n = n:xs
replFirst [] n = [n]

move :: Direction -> [Bool] -> [Bool] -> ([Bool], [Bool])
move Lt left right = (xs, x:right) where (x, xs) = ht left
move Rt left right = (x:left, xs)  where (x, xs) = ht right

runOne :: Machine -> State -> State
runOne machine (left, right, state) = seq newLeft $ seq newRight $ seq newState $
                                      (newLeft, newRight, newState)
  where (newLeft, newRight) = move direction left right'
        cur = headOrFalse right
        which = if cur then snd else fst
        rules = Map.findWithDefault ((True, Rt, 'A'), (True, Rt, 'A')) state machine
        (newCur, direction, newState) = which $ rules
        right' = replFirst right newCur

main = do
  let machineRun = iterate (runOne testMachine) $ ([], [], 'A')
  let (left, right, _) = machineRun !! 6
  let tape = left ++ right
  print $ length $ filter id tape

  let machineRun = iterate' (runOne prodMachine) $ ([], [], 'A')
  let (left, right, _) = machineRun !! 12208951
  let tape = left ++ right
  print $ length $ filter id tape
