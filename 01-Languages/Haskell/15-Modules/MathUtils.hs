module MathUtils
  ( add
  , multiply
  ) where

add :: Int -> Int -> Int
add x y = x + y

multiply :: Int -> Int -> Int
multiply x y = x * y

-- Deliberately NOT in the export list above -- invisible to any importer,
-- demonstrating that a module's export list is its real public API boundary.
helperNotExported :: Int -> Int
helperNotExported x = x + 1
