module Base (rebase) where

-- base >= 4.8 re-exports Control.Applicative.(<$>)
import Control.Applicative -- This is only need for <$>,  if GHC <  7.10
import Prelude             -- This trick avoids a warning if GHC >= 7.10

import Control.Monad (foldM)
import Data.List     (unfoldr)
import Data.Tuple    (swap)

rebase :: Integral a => a -> a -> [a] -> Maybe [a]
rebase ibase obase ds
    | ibase < 2 = Nothing
    | obase < 2 = Nothing
    | otherwise = toDigits obase <$> fromDigits ibase ds
  where

    fromDigits base = foldM f 0
      where
        f acc x | x >= 0 && x < base = Just (acc * base + x)
                | otherwise          = Nothing

    toDigits base n = reverse . unfoldr f $ n
      where
        f 0 = Nothing
        f x = Just . swap $ x `divMod` base
