import qualified Data.Map as Map
import Data.List
import Data.List.Split

type Happiness = Map.Map (String, String) Int

parseLine :: String -> ((String, String), Int)
parseLine s =
  let [a,second] = splitOn " happiness units by sitting next to " s
      [first, b:_:_:_:dhString] = splitOn " would " a
      dh = if b == 'l' then -(read dhString) else read dhString
  in ((first, init second), dh)

totalHappiness :: Happiness -> [String] -> Int
totalHappiness _ [] = 0
totalHappiness h (a:rest) = totalHappiness' h (a:rest ++ [a])

totalHappiness' h [a] = 0
totalHappiness' h (a:b:rest) =
      Map.findWithDefault 0 (a, b) h +
      Map.findWithDefault 0 (b, a) h +
      totalHappiness' h (b:rest)

main = do
  c <- getContents
  let dhs = Map.fromList $ map parseLine $ lines c
  let people = nub $ map fst $ Map.keys dhs

  print dhs
  print people

  print $ maximum $ map (totalHappiness dhs) $ permutations people
  print $ maximum $ map (totalHappiness' dhs) $ permutations people
