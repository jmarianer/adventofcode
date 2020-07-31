import Data.Char
import Data.List
import Data.List.Index
import Data.List.Split
import Data.Maybe

rotate :: Int -> [a] -> [a]
rotate i xs = back ++ front
  where (front, back) = splitAt (length xs - i) xs

exchange :: Int -> Int -> [a] -> [a]
exchange a b list = setAt a origB $ setAt b origA list
  where origA = list !! a
        origB = list !! b

move :: String -> String -> String
move order ('s':n) = rotate (read n) order
move order ('x':r) = exchange a b order
  where [a', b'] = splitOn "/" r
        a = read a'
        b = read b'
move order ('p':a:'/':b:[]) = exchange a' b' order
  where a' = fromJust $ elemIndex a order
        b' = fromJust $ elemIndex b order

runPermutation source permutation = map (\c -> source !! (ord c - ord 'a')) permutation

permutationPower :: Int -> String -> String
permutationPower n permutation =
  if (n == 1)
  then permutation
  else if even n
       then let halfPerm = permutationPower (n `div` 2) permutation
             in runPermutation halfPerm halfPerm
       else runPermutation (permutationPower (n-1) permutation) permutation


lastChar = 'p'
main = do
  c <- getContents
  let moves = splitOn "," $ dropWhileEnd isSpace c
  print $ foldl move ['a'..lastChar] moves

  let numberMoves = filter (\m -> head m /= 'p') moves
  let numberPermutation = foldl move ['a'..lastChar] numberMoves
  let letterMoves = filter (\m -> head m == 'p') moves
  let letterPermutation = foldl move ['a'..lastChar] letterMoves

  let times = 1000000
  let afterNumbers = runPermutation ['a'..lastChar] (permutationPower times numberPermutation)
  let afterLetters = runPermutation (permutationPower times letterPermutation) afterNumbers    
  print afterLetters
