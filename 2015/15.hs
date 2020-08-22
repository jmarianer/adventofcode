import Data.List
import Data.Ord

{-
ingredients = [
  (-1, -2, 6, 3),
  (2, 3, -2, -1)]
-}
ingredients = [
  (4,-2,0,0,5),
  (0,5,-1,0,8),
  (-1,0,5,0,6),
  (0,0,-2,2,1)]

add (a, b, c, d, e) (a1, b1, c1, d1, e1) = (a+a1, b+b1, c+c1, d+d1, e+e1)

mult (a, b, c, d, _) = if a<0 || b<0 || c<0 || d<0 then 0 else a*b*c*d

addOne tuple = maximumBy (comparing mult) (map (add tuple) ingredients)

zeros = (0, 0, 0, 0, 0)

main = do
  let oneOfEach = foldl add zeros ingredients
  print $ (iterate addOne oneOfEach) !! 96
