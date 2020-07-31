import Data.List

data Dir = Lt | Rt | Up | Dn deriving (Show, Eq)
data State = State Int Int Dir deriving Show

move :: State -> Dir -> State
move (State i j _) Up = State (i-1) j Up
move (State i j _) Dn = State (i+1) j Dn
move (State i j _) Lt = State i (j-1) Lt
move (State i j _) Rt = State i (j+1) Rt

type Network = [[Char]]

curChar :: Network -> State -> Char
curChar network (State i j _) = network !! i !! j

moveLeftOrRight :: Network -> State -> State
moveLeftOrRight network state@(State i j dir) =
  if network !! i !! (j-1) /= ' '
  then move state Lt
  else move state Rt

moveUpOrDown :: Network -> State -> State
moveUpOrDown network state@(State i j dir) =
  if network !! (i-1) !! j /= ' '
  then move state Up
  else move state Dn
  
nextState :: Network -> State -> State
nextState network state@(State i j dir) =
  case curChar network state of
    ' ' -> state
    '+' -> if dir `elem` [Up, Dn]
             then moveLeftOrRight network state
             else moveUpOrDown    network state
    otherwise -> move state dir

main = do
  c <- getContents
  let network' = map (++ " ") $ lines c
  let network = network' ++ [replicate (length $ head network') ' ']
  let (Just initCol) = elemIndex '|' $ head network
  let initState = State 0 initCol Dn
  let allStates = iterate (nextState network) initState
  let allChars = takeWhile (/= ' ') $ map (curChar network) allStates
  print $ filter (not . (flip elem) "-|+") $ allChars
  print $ length allChars
