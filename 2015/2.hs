import Data.List.Split

type Triple = (Int, Int, Int)

getSize :: String -> Triple
getSize s = (read x, read y, read z)
  where (x:y:z:[]) = splitWhen (=='x') s

paperNeeded :: Triple -> Int
paperNeeded (x, y, z) = 2 * sum sides + minimum sides
  where sides = [x*y, y*z, x*z]

ribbonNeeded :: Triple -> Int
ribbonNeeded (x, y, z) = 2 * minimum semiperimeters + x*y*z
  where semiperimeters = [x+y, y+z, x+z]


main = do
  c <- getContents
  let sizes = map getSize $ lines c
  print $ sum $ map paperNeeded sizes
  print $ sum $ map ribbonNeeded sizes
