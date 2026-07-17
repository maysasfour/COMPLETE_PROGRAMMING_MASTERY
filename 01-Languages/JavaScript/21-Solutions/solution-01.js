// solution-01.js - FizzBuzz Variant
// See: ../20-Exercises/README.md#exercise-01--fizzbuzz-variant-beginner
//
// Run with:
//   node solution-01.js

function fizzbuzz(n) {
  const result = [];
  for (let i = 1; i <= n; i++) {
    // Check "divisible by both" first - if you checked %3 and %5 as
    // separate independent branches, multiples of 15 would hit whichever
    // branch is checked first and never reach the combined case.
    if (i % 15 === 0) result.push("FizzBuzz");
    else if (i % 3 === 0) result.push("Fizz");
    else if (i % 5 === 0) result.push("Buzz");
    else result.push(String(i));
  }
  return result;
}

console.log(fizzbuzz(15));
