import Data.List
import Data.List.Split
import Util

vowels :: String -> Int
vowels = count ((flip elem) "aeiou")

hasDoubleLetter :: String -> Bool
hasDoubleLetter (a:b:xs) = if a == b then True else hasDoubleLetter (b:xs)
hasDoubleLetter _ = False

hasNaughtySubstring :: String -> Bool
hasNaughtySubstring s = any (\x -> any (==x) $ divvy 2 1 s) ["ab", "cd", "pq", "xy"]

niceString :: String -> Bool
niceString s = (vowels s >= 3) && hasDoubleLetter s && (not $ hasNaughtySubstring s)

hasAba :: String -> Bool
hasAba s = any id [a == c | (a:b:c:_) <- tails s]

hasDoubleDouble :: String -> Bool
hasDoubleDouble s = any id [[a, b] `isInfixOf` rest | a:b:rest <- tails s]

niceString2 :: String -> Bool
niceString2 s = hasAba s && hasDoubleDouble s

main = do
  c <- getContents
  print $ count niceString $ lines c
  print $ count niceString2 $ lines c
