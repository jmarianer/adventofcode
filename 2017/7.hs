import qualified Data.Map.Strict as Map
import Data.List.Extra
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

totalWeight weights subprogs prog = thisWeight + foldl (+) 0 subWeights
  where thisWeight :: Int
        thisWeight = Map.findWithDefault 0 prog weights
        subWeights :: [Int]
        subWeights = map (totalWeight weights subprogs) $ Map.findWithDefault [] prog subprogs

isBalanced weights subprogs prog = allSame $ map (totalWeight weights subprogs) $ Map.findWithDefault [] prog subprogs

main = do
  c <- getContents
  let input = map words $ lines c
  let weights = Map.fromList $ map getWeight input
  let subprogs = Map.fromList $ map getSubs input

  let root = head $ (Map.keys weights) \\ (concat $ Map.elems subprogs)
  print root

  let unbalanced = filter (not . isBalanced weights subprogs) $ Map.keys weights
  let minimalUnbalanced = head $ filter (\node -> not $ any (\node1 -> node1 `elem` Map.findWithDefault [] node subprogs) unbalanced) unbalanced
  let children = Map.findWithDefault [] minimalUnbalanced subprogs 
  -- Cheating here because I can't be bothered to fix this: this prints out all the children of the unbalanced node, their individual weights and their total weights.
  print children
  print $ map (\n -> Map.findWithDefault 0 n weights) children
  print $ map (totalWeight weights subprogs) children
