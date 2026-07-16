<?php
// example.php - dynamic typing, loose vs. strict comparison, type juggling.

$age = 30;             // int
$price = 19.99;         // float
$name = "Ada";           // string
$active = true;           // bool
$nothing = null;           // null

echo "age is a " . gettype($age) . "\n";
$age = "now a string";     // dynamic typing: the SAME variable can hold a different type
echo "age is now a " . gettype($age) . "\n";

echo "\n--- Loose (==) vs strict (===) comparison ---\n";
var_dump(0 == "abc");    // false in PHP 8+ (changed from true in PHP 7! -- a real, versioned gotcha)
var_dump("1" == "01");    // true  -- both numeric strings, compared as numbers
var_dump("10" == "1e1");  // true  -- "1e1" is numeric, equals 10
var_dump(100 == "100abc"); // false in PHP 8+ ("100abc" is not a well-formed numeric string)
var_dump(1 === "1");       // false -- strict comparison checks type too

echo "\n--- Type juggling in arithmetic ---\n";
$result = "5" + 3;       // numeric string coerced to int for arithmetic
var_dump($result);
$concat = "5" . 3;        // . is the concatenation operator (NOT +)
var_dump($concat);

echo "\n--- Null coalescing ---\n";
$config = ["debug" => false];
$mode = $config["mode"] ?? "production"; // ?? -- use default if null/unset, no warning
echo "mode: {$mode}\n";

echo "\n--- Constants ---\n";
define("MAX_USERS", 100);     // classic style
const MIN_USERS = 1;            // modern style, compile-time, must be top-level or in a class
echo "MAX_USERS: " . MAX_USERS . ", MIN_USERS: " . MIN_USERS . "\n";
