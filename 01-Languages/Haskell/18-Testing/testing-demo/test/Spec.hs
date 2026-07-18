import Test.Hspec
import Calculator (add, safeDivide)

main :: IO ()
main = hspec $ do
    describe "add" $ do
        it "adds two positive numbers" $
            add 2 3 `shouldBe` 5

        it "handles negative numbers" $
            add (-2) 5 `shouldBe` 3

    describe "safeDivide" $ do
        it "divides normally" $
            safeDivide 10 2 `shouldBe` Just 5

        it "returns Nothing for division by zero" $
            safeDivide 10 0 `shouldBe` Nothing

        it "satisfies: dividing anything by itself is 1 (except 0)" $
            safeDivide 7 7 `shouldSatisfy` (== Just 1)
