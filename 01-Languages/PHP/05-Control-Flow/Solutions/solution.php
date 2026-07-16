<?php
// Solution to the FizzBuzz exercise using match (true) { ... }.

function fizzbuzz(int $n): string {
    return match (true) {
        $n % 15 === 0 => "FizzBuzz",
        $n % 3 === 0 => "Fizz",
        $n % 5 === 0 => "Buzz",
        default => (string) $n,
    };
}

for ($i = 1; $i <= 15; $i++) {
    echo fizzbuzz($i) . "\n";
}
