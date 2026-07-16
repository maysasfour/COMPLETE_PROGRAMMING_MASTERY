# Exercise 01 — FizzBuzz with a Twist

[Back to lesson](../README.md)

## Task

Write a function `fizzBuzzRange(start, end)` that returns an **array of strings**, one per number from `start` to `end` inclusive, where:

- Multiples of both 3 and 5 become `"FizzBuzz"`.
- Multiples of 3 (only) become `"Fizz"`.
- Multiples of 5 (only) become `"Buzz"`.
- Everything else becomes the number itself, converted to a string.

Then write a second function, `countCategory(results, category)`, that takes the array `fizzBuzzRange` produced and a category (`"Fizz"`, `"Buzz"`, `"FizzBuzz"`, or `"Number"`) and returns how many entries fall into it, using a `switch` statement to branch on `category`.

## Constraints

- Use a `for` loop (not array methods) to build the result in `fizzBuzzRange` — this exercise is about control flow, not `map`/`filter` (covered in Lesson 07).
- `countCategory` must use `switch`, with a `default` case handling `"Number"` (plain numeric strings).

## Starter Code

```js
function fizzBuzzRange(start, end) {
  const results = [];
  // your loop here
  return results;
}

function countCategory(results, category) {
  // your switch here
}

console.log(fizzBuzzRange(1, 15));
console.log(countCategory(fizzBuzzRange(1, 15), "Fizz"));
```

## Expected Output

```
[
  '1', '2', 'Fizz', '4', 'Buzz',
  'Fizz', '7', '8', 'Fizz', 'Buzz',
  '11', 'Fizz', '13', '14', 'FizzBuzz'
]
4
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.js](../Solutions/solution-01.js).
