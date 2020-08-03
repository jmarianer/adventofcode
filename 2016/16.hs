import Data.List.Split

input = "00101000101111010"

expand :: String -> String
expand s = s ++ "0" ++ revrev s
  where revrev = map (\c -> if c == '1' then '0' else '1') . reverse

expandToSize :: String -> Int -> String
expandToSize s size = take size $ head $ filter (\s -> length s >= size) $ iterate expand s

same :: String -> Char
same "00" = '1'
same "10" = '0'
same "01" = '0'
same "11" = '1'

checksum s =
  if even $ length s
  then checksum $ map same $ chunksOf 2 s
  else s

main = do
  print $ checksum $ expandToSize input 272
  print $ checksum $ expandToSize input 35651584
