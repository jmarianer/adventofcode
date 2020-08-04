import Data.List
import Util

added s = 2 + (added' $ init $ tail s)
  where added' :: String -> Int
        added' "" = 0
        added' ('\\':'x':_:_:cs) = added' cs + 3
        added' ('\\':_:cs) = added' cs + 1
        added' (_:cs) = added' cs

additional :: String -> Int
additional s = 2 + (count ((flip elem) "\"\\") s)


main = do
  c <- getContents
  print $ sum $ map added $ lines c
  print $ sum $ map additional $ lines c
