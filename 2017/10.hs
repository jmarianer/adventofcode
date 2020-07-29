import Knothash

lengths = [230,1,2,221,97,252,168,169,57,99,0,254,181,255,235,167]
input = "230,1,2,221,97,252,168,169,57,99,0,254,181,255,235,167"

main = do
  let (finalList, _, _) = foldl doStep initial lengths
  let (x:y:_) = finalList
  print (x*y)

  print $ hashString input
