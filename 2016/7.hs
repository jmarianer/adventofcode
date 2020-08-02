import Data.List.Split

isAbba :: String -> Bool
isAbba (a:b:c:d:[]) = a == d && b == c && a /= b

hasAbba :: String -> Bool
hasAbba = any isAbba . divvy 4 1

brackets :: String -> ([String], [String])
brackets "" = ([], [])
brackets ('[':cs) = (nb, this:b)
  where (this, rest) = span (/= ']') cs
        (nb, b) = brackets rest
brackets (']':cs) = (this:nb, b)
  where (this, rest) = span (/= '[') cs
        (nb, b) = brackets rest
brackets cs = (this:nb, b)
  where (this, rest) = span (/= '[') cs
        (nb, b) = brackets rest
 
supportsTLS :: ([String], [String]) -> Bool
supportsTLS (nb, b) = any hasAbba nb && not (any hasAbba b)

abas :: String -> [(Char, Char)]
abas s = getAbas [] $ divvy 3 1 s
  where getAbas acc [] = acc
        getAbas acc ((a:b:c:[]):xs) =
          if a == c && a /= b
          then getAbas ((a, b):acc) xs
          else getAbas acc xs

babs :: String -> [(Char, Char)]
babs = map (\(a, b) -> (b, a)) . abas

supportsSSL :: ([String], [String]) -> Bool
supportsSSL (nb, b) = any (`elem` allAbas) $ allBabs
  where allAbas = concatMap abas nb
        allBabs = concatMap babs b

main = do
  c <- getContents
  print $ length $ filter supportsTLS $ map brackets $ lines c
  print $ length $ filter supportsSSL $ map brackets $ lines c
