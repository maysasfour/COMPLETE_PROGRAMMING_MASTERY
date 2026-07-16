# Solution 01 — FizzBuzz with a Twist

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- `fizzBuzzRange` checks the `%3 && %5` combined case **first** — checking `%3` or `%5` alone first would incorrectly short-circuit multiples of 15 into `"Fizz"` before the combined check ever ran.
- `String(n)` converts the fallback number explicitly, keeping the return type a uniform `string[]` rather than a mixed array of numbers and strings — this matters if a caller later does `.join(", ")` or string comparisons on the result.
- `countCategory` uses `switch (category)` as required, with each case checking the actual entry value; `"Number"` falls to `default` and is validated with `Number.isNaN(Number(entry))` since a numeric fallback entry is stored as a string (e.g., `"4"`), not a number.

## Verification

Actually run with `node Solutions/solution-01.js` (output copied verbatim, not hand-computed):

```
[
  '1', '2', 'Fizz', '4', 'Buzz',
  'Fizz', '7', '8', 'Fizz', 'Buzz',
  '11', 'Fizz', '13', '14', 'FizzBuzz'
]
4
Buzz count: 2
FizzBuzz count: 1
Number count: 8
```

The four category counts add up correctly: 4 (Fizz: 3, 6, 9, 12) + 2 (Buzz: 5, 10) + 1 (FizzBuzz: 15) + 8 (plain numbers: 1, 2, 4, 7, 8, 11, 13, 14) = 15, matching the full range.
