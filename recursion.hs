{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Move guards forward" #-}
{-# HLINT ignore "Redundant bracket" #-}

-- TODO: read through an edit comments

-- Recursive Functions

--   - functions that are used within their own function definition (inside their function body)
--   - a way to declare what something is
--   - used in functional languages instead of for and while loops as they can perform the same actions in a more elegant manner

-- Accessing Every Element in a Collection

--   - instead of defining how every element is received using a for or while loop
--   - declarative languages tell you what it expects by using (x : xs) to accees every element in an iterable
--   - meaning (head : tail):
--       - the above syntatic meaning is extract the head of an iterable and return the tail
--       - the tail is the rest of the list after the head is poped off / ommited
--       - while purely functional programming uses immutability the syntax (x : xs) can be viewed as poping thr head off of a list
--         assigning the head of the list (the first element) to x and the rest of the list (the tail) to xs
--       - this syntax allows you to exhaustively iterate over every element in a List while still retaining immutability
--       - (head `cons` tail) where cons is the prepend operation in constant-time O(1) can be seen as poping of the head of a list in constant time

-- Edge Condition (Base Case)

--   - typically explicity defined
--   - required for a recursive function to terminate

fibonacci :: (Integral a) => a -> a
fibonacci 0 = 0 -- edge condition
fibonacci 1 = 1 -- edge condition
fibonacci n = fibonacci (n - 1) + fibonacci (n - 2)

fibonacci' :: (Integral a) => a -> a
fibonacci' n = getFib n
  where
    getFib 0 = 0
    getFib 1 = 1
    getFib n = fibonacci (n - 1) + fibonacci (n - 2)

fibonacci'' :: (Integral a) => a -> a
fibonacci'' n =
  let getFib 0 = 0
      getFib 1 = 1
      getFib n = fibonacci (n - 1) + fibonacci (n - 2)
   in getFib n

fibonacci''' :: (Integral a) => a -> a
fibonacci''' n = case n of
  0 -> 0 -- edge condition
  1 -> 1 -- edge condition
  n ->
    let getFib n = fibonacci (n - 1) + fibonacci (n - 2)
     in getFib n

getLargeEvenFibonacci :: (Integral a) => [a] -> [a]
getLargeEvenFibonacci xs =
  [ x
    | x <-
        [ getFib x
          | x <- xs,
            let getFib 0 = 0
                getFib 1 = 1
                getFib n = getFib (n - 1) + getFib (n - 2)
        ],
      even x && x > 200 -- predicate to check if x is even
  ]

getLargeOddFibonacci :: (Integral a) => [a] -> [a]
getLargeOddFibonacci xs =
  [ x
    | x <- fibCollection,
      odd x && x > 99 -- predicate to check if x is even
  ]
  where
    fibCollection =
      [ getFib x
        | x <- xs,
          let getFib 0 = 0
              getFib 1 = 1
              getFib n = getFib (n - 1) + getFib (n - 2)
      ]

-- Maximum' Example:

maximum' :: (Ord a) => [a] -> a
maximum' [] = error "an empty list does not have a maximum element." -- pattern 1 && edge condition 1
maximum' [x] = x -- pattern 2 && edge condition 2
maximum' (x : xs) -- pattern 3 with guards
  | x > maxTail = x
  | otherwise = maxTail
  where
    maxTail = maximum' xs

-- Replicate' Example:
replicate' :: (Num i, Ord i) => i -> a -> [a]
replicate' n x
  | n <= 0 = [] -- pattern 1 and edge condition
  | otherwise = x : replicate' (n - 1) x -- pattern 2 and catch-all

-- Take' Example:
take' :: (Num i, Ord i) => i -> [a] -> [a]
take' n _
  | n <= 0 = [] -- pattern 1 and edge condition 1
take' _ [] = [] -- pattern 2 and edge condition 2
take' n (x : xs) = x : take' (n - 1) xs -- pattern 3 and catch-all

-- Why do we need the type class (Num i, Ord i) => in the examples above

-- Reverse' Example:

reverse' :: (Num a, Ord a) => [a] -> [a]
reverse' [] = [] -- when there is an empty list passed in either initally or when all elements have been iterated over return an empty list to concatenate too
reverse' (x : xs) = (reverse' xs) ++ [x]

-- Repeat Example:

repeat' :: a -> [a]
repeat' x = x : repeat' x

-- Zip

zip' :: [a] -> [b] -> [(a, b)]
zip' _ [] = []
zip' [] _ = []
zip' (x : xs) (y : ys) = (x, y) : zip' xs ys

-- Elem' Example:

elem' :: (Eq a) => a -> [a] -> Bool
elem' _ [] = False
elem' ele (x : xs)
  | ele == x = True
  | otherwise = elem' ele xs

-- Quick Sort Example:

quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x : xs) =
  let smallerList = quicksort [n | n <- xs, n <= x]
      biggerList = quicksort [n | n <- xs, n > x]
   in smallerList ++ [x] ++ biggerList

-- What is The Pattern When Defining Recursive Functions??

-- Try to create a toLower case function
-- toLower :: String -> String

-- toLower "" = ""

-- toLower (char:s)
--     |  elem char ['A'..'Z'] =