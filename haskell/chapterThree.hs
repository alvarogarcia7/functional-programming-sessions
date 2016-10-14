module ChapterThree where

import Test.Hspec
import Text.Printf (printf)
import Data.List


data List' a = Nil
             | Cons a (List' a) deriving (Show, Eq)

instance Foldable List' where
    foldr function accumulator Nil = accumulator 
    foldr function accumulator (Cons x xs) = function x (foldr function accumulator xs)

head' :: List' a -> a
head' Nil = error "head of nothing???"
head' (Cons a _) = a

tail' :: List' a -> List' a
tail' Nil = error "tail of nothing???"
tail' (Cons _ xs) = xs

sum' :: List' Int -> Int
sum' Nil = 0
sum' (Cons x xs) = x + sum' xs

product' :: List' Int -> Int
product' Nil = 1
product' (Cons x xs) = x * product' xs

apply' :: [a] -> List' a
apply' [] = Nil
apply' (x:xs) = Cons x $ apply' xs


setHead' :: a -> List' a -> List' a
setHead' element Nil = Nil
setHead' newHead (Cons head tail) = (Cons newHead tail)

drop' :: Int -> List' a -> List' a
drop' 0 xs = xs
--drop' n xs = tail' (drop' (n-1) xs)
drop' n (Cons x xs) = drop' (n - 1) xs

scanr' :: (a -> b -> b) -> b -> List' a -> List' b
scanr' _ acc Nil = (Cons acc Nil)
scanr' f acc (Cons x xs) = Cons (f x (head' x')) x'
    where x' = scanr' f acc xs

scanl'' :: (a -> b -> b) -> b -> [a] -> [b]
scanl'' f init xs =  scanl''' [init] f xs  where
    scanl''' current f [] = current
    scanl''' current f (x : xs) = scanl''' x' f xs where
        x' = current ++ [(f x (last current))]

--scanl'' =  scanl''' Nil where
--    scanl''' current f acc Nil = current
--    scanl''' current f acc (Cons x xs) = scanl''' (current ++ (f x acc)) acc xs


main = hspec $ do
    describe "head" $ do
        it (printf "should return first element of list") $
            head' (Cons 4 (Cons 3 (Cons 2 (Nil)))) `shouldBe` 4

    describe "tail" $ do
        it (printf "should return tail of a list") $
            tail' (Cons 4 (Nil)) `shouldBe` Nil

    describe "sum" $ do
        it (printf "should sum a list") $
            sum' (Cons 4 (Cons 3 (Cons 2 (Nil)))) `shouldBe` 9

    describe "product" $ do
        it (printf "should multiply a list") $
            product' (Cons 4 (Cons 3 (Cons 2 (Nil)))) `shouldBe` 24

    describe "apply" $ do
        it (printf "should create our type of list from a list") $
            apply' [1..3] `shouldBe` (Cons 1 $ Cons 2 $ Cons 3 Nil)

    describe "setHead" $ do
        it (printf "should set the head of a list with a new value") $
            setHead' 3 (apply' [1,2,3]) `shouldBe` (Cons 3 $ Cons 2 $ Cons 3 Nil)

    describe "drop'" $ do
        it ("should remove the first n element of our list") $
            drop' 2 (apply' [1..5]) `shouldBe` (Cons 3 $ Cons 4 $ Cons 5 Nil)

    describe "foldr" $ do
        it "should return the default element on the empty list" $
            foldr (-) 0 (apply' []) `shouldBe` 0

        it "should loop over the elements from the right" $
            foldr (\ele acc -> acc - ele) 0 (apply' [1,2,3]) `shouldBe` -6

    describe "foldl" $ do
        it "should return the default element on the empty list" $
            foldl (-) 0 (apply' []) `shouldBe` 0

        it "should loop over the elements from the right" $
            foldl (\ele acc -> acc + ele) 0 (apply' [1,2,3]) `shouldBe` 6

    describe "scanr" $ do
        it "cumulates the results of executing the function" $
            (scanr' (-) 0 $ apply' []) `shouldBe` apply' [0]

        it "cumulates the results of executing the function" $
            (scanr' (-) 0 $ apply' [1,2,3]) `shouldBe` apply' [2,-1,3,0]

    describe "scanl" $ do
        it "with an empty, it is just the initial value" $
            (scanl'' (+) 1 $  []) `shouldBe`  [1]
        
        it "cumulates the result of executing the function, from the left" $
            (scanl'' (+) 1 $  [1,2,3]) `shouldBe`  [1,2,4,7]
