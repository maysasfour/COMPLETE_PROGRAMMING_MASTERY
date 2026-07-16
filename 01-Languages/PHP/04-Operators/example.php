<?php
// example.php - arithmetic, comparison, logical, null-safe, spaceship, and PHP-specific operators.

echo "--- Arithmetic (** for exponent, no ++/-- surprises to cover, intdiv for int division) ---\n";
echo 2 ** 10, "\n";          // 1024 -- exponentiation
echo intdiv(10, 3), "\n";     // 3   -- integer division, distinct from 10 / 3 (float)
echo 10 / 3, "\n";              // 3.3333333333333
echo 10 % 3, "\n";                // 1 -- modulo

echo "\n--- Spaceship operator <=> (three-way comparison, used by usort) ---\n";
var_dump(1 <=> 2); // -1
var_dump(2 <=> 2); //  0
var_dump(3 <=> 2); //  1

$nums = [5, 3, 8, 1];
usort($nums, fn($a, $b) => $a <=> $b); // idiomatic ascending sort using the spaceship operator
echo "sorted: " . implode(", ", $nums) . "\n";

echo "\n--- Null-safe operator ?-> (PHP 8+, avoids a chain of isset() checks) ---\n";
class Address { public ?string $city = null; }
class UserRecord { public ?Address $address = null; }
$user = new UserRecord();
echo ($user->address?->city ?? "no city on file") . "\n"; // no error even though address is null

echo "\n--- Logical operators: && / || vs 'and' / 'or' (different precedence!) ---\n";
var_dump(true && false);
var_dump(true || false);
// 'and'/'or' have LOWER precedence than '=' -- a real, documented gotcha:
$a = true and false; // parses as ($a = true) and false -- $a becomes true, NOT false!
var_dump($a);

echo "\n--- Increment/decrement work on strings too (a PHP-specific feature) ---\n";
$letter = "a";
$letter++;
echo $letter, "\n"; // "b" -- PHP defines string increment (Perl-like), unlike most languages
