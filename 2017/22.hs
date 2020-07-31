import Data.List
import qualified Data.Map.Strict as Map

data Node = Clean | Infected | Weakened | Flagged deriving Eq
type Field = Map.Map (Int, Int) Node
data Direction = Up | Dn | Lt | Rt deriving Show

data State = State { field :: Field,
                     coords :: (Int, Int),
                     dir :: Direction,
                     infectionCount ::Int }

turnLeft :: Direction -> Direction
turnLeft Up = Lt
turnLeft Lt = Dn
turnLeft Dn = Rt
turnLeft Rt = Up

turnRight :: Direction -> Direction
turnRight Up = Rt
turnRight Rt = Dn
turnRight Dn = Lt
turnRight Lt = Up

turnAround :: Direction -> Direction
turnAround Up = Dn
turnAround Dn = Up
turnAround Lt = Rt
turnAround Rt = Lt

move :: Direction -> (Int, Int) -> (Int, Int)
move Up (i, j) = (i-1, j)
move Dn (i, j) = (i+1, j)
move Lt (i, j) = (i, j-1)
move Rt (i, j) = (i, j+1)

toggle :: (Int, Int) -> Field -> Field
toggle = Map.alter f
  where f Nothing = Just Infected
        f (Just Infected) = Just Clean
        f (Just Clean) = Just Infected

nextState :: State -> State
nextState (State field coords dir infectionCount) = State newField newCoords newDir newInfectionCount
  where newField = toggle coords field
        newCoords = move newDir coords
        newDir = if wasInfected
                 then turnRight dir
                 else turnLeft dir
        newInfectionCount = if wasInfected then infectionCount else infectionCount + 1
        wasInfected = Infected == Map.findWithDefault Clean coords field

toggle1 :: (Int, Int) -> Field -> Field
toggle1 = Map.alter f
  where f Nothing = Just Weakened
        f (Just Infected) = Just Flagged
        f (Just Flagged) = Just Clean
        f (Just Clean) = Just Weakened
        f (Just Weakened) = Just Infected

nextState1 :: State -> State
nextState1 (State field coords dir infectionCount) =
    seq newField $ seq newCoords $ seq newDir $ seq newInfectionCount $
    State newField newCoords newDir newInfectionCount
  where newField = toggle1 coords field
        newCoords = move newDir coords
        newDir = case currentState of
                   Clean -> turnLeft dir
                   Infected -> turnRight dir
                   Flagged -> turnAround dir
                   Weakened -> dir
        newInfectionCount = if currentState == Weakened then infectionCount + 1 else infectionCount
        currentState = Map.findWithDefault Clean coords field


main = do
  c <- getContents
  let ls = lines c
      w = length $ head ls
      h = length ls
      withCols = map (zip [-(w `div` 2)..]) ls
      withRows = zipWith (\r l -> map (\(c, x) -> ((r, c), (if x == '#' then Infected else Clean))) l) [-(h `div` 2)..] withCols
      initialField :: Field
      initialField = Map.fromList $ concat withRows
      initialState :: State
      initialState = State initialField (0, 0) Up 0
  
  print $ infectionCount $ (iterate' nextState initialState) !! 10000
  print $ infectionCount $ (iterate' nextState1 initialState) !! 10000000
