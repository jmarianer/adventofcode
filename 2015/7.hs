{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}
import Site

import qualified Data.Map.Strict as Map

import Data.Bits
import Data.Char
import Data.Function.Memoize
import Data.List.Split
import Debug.Trace

data Wire = And String String | Or String String | Not String | Shift String Int | Value String deriving Show

getWire :: String -> Wire
getWire s =
  case op of
    "AND" -> And a b
    "OR" -> Or a b
    "NOT" -> Not $ drop 4 s
    "LSHIFT" -> Shift a (read b)
    "RSHIFT" -> Shift a (-read b)
    ""       -> Value s
  where op = filter isUpper s
        [a, b] = splitOn (" " ++ op ++ " ") s

parseInputLine :: String -> (String, Wire)
parseInputLine s = (reg, getWire d)
  where [d, reg] = splitOn (" -> ") s

type Wires = Map.Map String Wire

preorder :: Wires -> String -> [String]
preorder wires rootReg = preAcc [] rootReg
  where preAcc acc reg =
          case (reads reg :: [(Int, String)]) of
            [(x, _)]  -> acc
            otherwise -> if reg `elem` acc
                         then acc
                         else reg:(foldl preAcc acc $ regsToAdd reg)
        regsToAdd reg = case Map.findWithDefault (Value "") reg wires of
          And s t   -> [s, t]
          Or s t    -> [s, t]
          Not s     -> [s]
          Shift s i -> [s]
          Value s   -> [s]

valuesAcc :: Wires -> Map.Map String Int -> String -> Map.Map String Int
valuesAcc wires prevValues newReg = Map.insert newReg newValue prevValues
  where newValue = case Map.findWithDefault (Value "") newReg wires of
                     And s t   -> value s .&. value t
                     Or s t    -> value s .|. value t
                     Not s     -> value s `xor` 65535
                     Shift s i -> value s `shift` i
                     Value s   -> value s
        value s = case (reads s :: [(Int, String)]) of
          [(x, _)]  -> x
          otherwise -> Map.findWithDefault 0 s prevValues

{-
values :: Wires -> String -> Map String Int
values wires rootReg = mapAccum Map.empty rootReg
  where mapAccum :: Map String Int -> String -> Map String Int
        mapAccum regs reg =
          case reads reg of
            [(x, _)] -> x
            otherwise -> 
Map.findWithDefault (doCalc reg) reg regs



valueWithMemoize Map.empty reg
  where valueWithMemoize :: Map String Int -> String -> Int
        valueWithMemoize regs reg =
          case reads reg of
            [(x, _)] -> x
            otherwise -> Map.findWithDefault (doCalc reg) reg regs
        doCalc reg = case Map.findWithDefault (Value "") reg regs of
-}
    

main = do
  c <- getContents
  let wires = Map.fromList $ map parseInputLine $ lines c
      order = reverse $ (preorder wires) "a"
      a = Map.findWithDefault 0 "a" $ foldl (valuesAcc wires) Map.empty $ order
  print a

  let wires2 = Map.insert "b" (Value $ show a) wires
      a2 = Map.findWithDefault 0 "a" $ foldl (valuesAcc wires2) Map.empty $ order
  print a2
