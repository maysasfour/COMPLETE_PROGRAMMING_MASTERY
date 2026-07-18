-- The type signature (`main :: IO ()`) is optional here but written explicitly
-- on purpose -- GHC would infer it, but every top-level binding in this course
-- gets an explicit signature so the type is always visible, not just inferred.
main :: IO ()
main = putStrLn "Hello, Haskell!"
