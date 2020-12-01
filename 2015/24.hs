import Combinatorics

weights = [1, 2, 3, 7, 11, 13, 17, 19, 23, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113]

main = do
  let target = sum weights `div` 4
  let possibilities = variate 4 weights
  print $ minimum [product p | p <- possibilities, sum p == target]
