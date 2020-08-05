import Data.List
import Primes

primeFactors 1 = []
primeFactors n = f : primeFactors (n `div` f)
  where f = head $ filter (\p -> n `mod` p == 0) primes

sigma n = product $ map s' $ group $ primeFactors n
  where s' l = let p = head l
                   k = length l
               in (p^(k+1)-1) `div` (p-1)

presentCount n = 10 * sigma n

main = do
  print $ presentCount 831600
  print $ sigma 12
  print $ findIndex (>=36000000) $ map presentCount [800000..]
