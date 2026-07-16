<?php
declare(strict_types=1);
// Exercise: write a variadic function `average(float ...$numbers): float` that returns
// the mean of its arguments, and an arrow function `square` that squares a single number.
// Then use array_map with square(...) (first-class callable syntax) over an array,
// and pass the result to average(...$mapped) using the spread operator.

function average(float ...$numbers): float {
    // TODO: implement
    return 0.0;
}

// TODO: define $square as an arrow function: fn(float $x): float => $x * $x

$values = [1.0, 2.0, 3.0, 4.0];
// TODO: map $values through $square, then compute the average of the squared values
// expected: average of [1, 4, 9, 16] = 7.5
