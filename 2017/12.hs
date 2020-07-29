import Data.Graph
import Data.Tree

lineToEdges line = map (\t -> (source, t)) targets
  where sourceS:_:targetsS = words $ line ++ ","
        source = read sourceS :: Int
        targets = map (read . init) targetsS :: [Int]

main = do
  c <- getContents
  let edges = concat $ map lineToEdges $ lines c
  let graph = buildG (0, 1999) edges
  let comps = map flatten $ components graph
  let comp0 = head $ filter (elem 0) comps
  print $ length comp0
  print $ length comps
