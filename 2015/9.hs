import qualified Data.Map as Map
import Data.List
import Data.List.Split

type Map = Map.Map (String, String) Int

parseLine :: String -> [((String, String), Int)]
parseLine s =
  let [a,dist] = splitOn " = " s
      [source, dest] = splitOn " to " a
      distance = read dist :: Int
  in [((source, dest), distance),
      ((dest, source), distance)]

totalDistance :: Map -> [String] -> Int
totalDistance _ []         = 0
totalDistance _ [a]        = 0
totalDistance m (a:b:rest) = Map.findWithDefault 0 (a, b) m + totalDistance m (b:rest)

main = do
  c <- getContents
  let distances = Map.fromList $ concatMap parseLine $ lines c
  let cities = nub $ map fst $ Map.keys distances
      
  print $ minimum $ map (totalDistance distances) $ permutations cities
  print $ maximum $ map (totalDistance distances) $ permutations cities
