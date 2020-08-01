module Site where

data Direction = Up | Dn | Lt | Rt deriving (Show, Eq)

turnLeft :: Direction -> Direction
turnLeft Up = Lt
turnLeft Lt = Dn
turnLeft Dn = Rt
turnLeft Rt = Up

turnRight :: Direction -> Direction
turnRight Up = Rt
turnRight Rt = Dn
turnRight Dn = Lt
turnRight Lt = Up

turnAround :: Direction -> Direction
turnAround Up = Dn
turnAround Dn = Up
turnAround Lt = Rt
turnAround Rt = Lt

move :: Direction -> (Int, Int) -> (Int, Int)
move Up (i, j) = (i-1, j)
move Dn (i, j) = (i+1, j)
move Lt (i, j) = (i, j-1)
move Rt (i, j) = (i, j+1)

