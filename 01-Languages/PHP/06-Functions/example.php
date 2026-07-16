<?php
// example.php - default/named/variadic parameters, type declarations, by-reference params,
// return types, arrow functions, and first-class callable syntax (PHP 8.1+).

declare(strict_types=1); // enforces exact type matches (no int->float coercion) for THIS file

function greet(string $name, string $greeting = "Hello"): string {
    return "{$greeting}, {$name}!";
}
echo greet("Ada"), "\n";
echo greet(name: "Grace", greeting: "Hi"), "\n"; // named arguments (PHP 8+), order-independent
echo greet(greeting: "Hey", name: "Linus"), "\n";

function sum(int ...$numbers): int { // variadic parameter
    return array_sum($numbers);
}
echo sum(1, 2, 3, 4), "\n"; // 10

// By-reference parameter -- mutates the caller's variable directly, unlike everything else
// so far in this course, which passes by value (arrays/objects have their own semantics too).
function increment(int &$n): void {
    $n++;
}
$counter = 5;
increment($counter);
echo "counter after increment: {$counter}\n"; // 6 -- genuinely mutated by the function

// Arrow functions (PHP 7.4+): implicit single-expression body, AUTO-CAPTURES outer scope
// (unlike a plain anonymous function, which needs an explicit `use (...)` clause).
$multiplier = 3;
$triple = fn(int $x): int => $x * $multiplier;
echo $triple(7), "\n"; // 21 -- $multiplier captured automatically, no `use` needed

// Plain anonymous function requires explicit `use`
$add = function (int $a, int $b) use ($multiplier): int {
    return ($a + $b) * $multiplier;
};
echo $add(2, 3), "\n"; // 15

// First-class callable syntax (PHP 8.1+): strlen(...) creates a Closure without calling it
$lengths = array_map(strlen(...), ["a", "bb", "ccc"]);
echo implode(", ", $lengths), "\n"; // 1, 2, 3
