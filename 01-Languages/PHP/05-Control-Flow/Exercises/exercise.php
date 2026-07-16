<?php
// Exercise: FizzBuzz using `match`, PHP 8's expression-based alternative to switch.
// Write a function fizzbuzz(int $n): string that returns:
//   "FizzBuzz" if $n is divisible by both 3 and 5
//   "Fizz"     if divisible by 3 only
//   "Buzz"     if divisible by 5 only
//   otherwise, the number itself, as a string
// Use `match (true) { ... }` (the same pattern shown in example.php) rather than if/elseif.

function fizzbuzz(int $n): string {
    // TODO: implement using match (true) { condition => result, ... }
    return "";
}

for ($i = 1; $i <= 15; $i++) {
    echo fizzbuzz($i) . "\n";
}
