{-# Language TupleSections #-}

import Site

import qualified Data.Map as Map

import Data.Char
import Data.List
import Data.List.Split
import Debug.Trace

toAtoms :: String -> [String]
toAtoms [] = []
toAtoms [c] = [[c]]
toAtoms (c:d:rest) = if isLower d
                     then [c,d] : toAtoms rest
                     else [c]   : toAtoms (d:rest)

replacements :: [String] -> [(String, [String])]
replacements lines = map r lines
  where r line = (from, toAtoms to)
          where [from, to] = splitOn " => " line

sequences :: [a] -> [([a], a, [a])]
sequences = s' [] 
  where s' prev []     = []
        s' prev (x:xs) = (prev, x, xs) : s' (x:prev) xs

singleRepl :: [(String, [String])] -> [String] -> [[String]]
singleRepl repls atoms = concatMap oneReplacement $ sequences atoms
  where oneReplacement (prev, cur, next) = [reverse prev ++ replacement ++ next | (atom, replacement) <- repls, atom == cur]

getTo repls target = getTo' target
  where getTo' target = map (\(from, to) -> traceShow to $ to `isPrefixOf` target) repls

main = do
  c <- getContents
  let target = toAtoms $ last $ lines c
      repls = replacements $ init $ init $ lines c
  print $ length $ nub $ singleRepl repls $ target

  let adjacency atoms = map (,()) $ filter (\l -> length l <= length target) $ singleRepl repls atoms
      counts = bfs ["e"] adjacency (==target) (Just 10)
  print $ Map.lookup target counts
