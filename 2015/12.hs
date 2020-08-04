{-# LANGUAGE OverloadedStrings #-}

import qualified Data.HashMap.Strict as Map
import qualified Data.Vector as Vector

import Data.Aeson

sumNumbers (Object o) = sum $ map sumNumbers $ Map.elems o
sumNumbers (Array a)  = sum $ map sumNumbers $ Vector.toList a
sumNumbers (Number n) = n
sumNumbers _ = 0

sumNumbers2 (Object o) = if String "red" `elem` Map.elems o then 0 else sum $ map sumNumbers2 $ Map.elems o
sumNumbers2 (Array a)  = sum $ map sumNumbers2 $ Vector.toList a
sumNumbers2 (Number n) = n
sumNumbers2 _ = 0

main = do
  Just c <- decodeFileStrict "input12.txt" :: IO (Maybe Value)
  print $ sumNumbers c
  print $ sumNumbers2 c
