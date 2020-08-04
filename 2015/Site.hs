{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE RankNTypes #-}

module Site where

import qualified Data.ByteString as BS
import qualified Data.Map as Map
import qualified Data.Sequence as Seq
import qualified Data.Text as T
import Data.Text.Encoding

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

-- Insert a value into a map, but only if it wasn't already there.
maybeInsert :: Ord k => k -> v -> Map.Map k v -> Map.Map k v
maybeInsert k v map = Map.alter alteration k map
  where alteration (Just o) = Just o
        alteration Nothing  = Just v

bfs :: forall a b . (Ord a, Eq a) =>
       a -- start
    -> (a -> [(a, b)]) -- adjacency
    -> (a -> Bool) -- goal
    -> Maybe Int -- Max depth
    -> Map.Map a [b] -- directions (to everywhere else in the graph)
bfs start adjacency goal depth = bfs' (Map.singleton start []) (Seq.singleton start)
  where bfs' :: Map.Map a [b] -> Seq.Seq a -> Map.Map a [b]
        bfs' directions Seq.Empty = directions
        bfs' directions (current Seq.:<| rest) =
          if goal current
          then directions
          else if length currentDirections `gtMaybe` depth
          then bfs' directions rest
          else bfs' (directions `Map.union` newDirections) newQueue
            where adjacent :: [(a, b)]
                  adjacent = filter (\(a, _) -> not $ a `Map.member` directions) $ adjacency current
                  currentDirections :: [b]
                  Just currentDirections = Map.lookup current directions
                  newDirections ::  Map.Map a [b]
                  newDirections = Map.fromList $ map (\(a, b) -> (a, b:currentDirections)) adjacent
                  newQueue :: Seq.Seq a
                  newQueue = rest Seq.>< Seq.fromList (map fst adjacent)
                  gtMaybe :: Int -> Maybe Int -> Bool
                  a `gtMaybe` Just b = a > b-1
                  a `gtMaybe` nothing = False

hashes :: (BS.ByteString -> BS.ByteString) -> T.Text -> [BS.ByteString]
hashes hashfunc s = map hash [0..]
  where hash :: Int -> BS.ByteString
        hash n = hashfunc $ encodeUtf8 $ T.concat [s, T.pack $ show n]
