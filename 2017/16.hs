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

main = do
  c <- getContents
  let moves = splitOn "," c
  print $ foldl move ['a'..'p'] moves
