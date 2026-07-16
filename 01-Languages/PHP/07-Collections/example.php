<?php
declare(strict_types=1);
// example.php - PHP's array is BOTH a list and a map (an ordered hash map internally) --
// there is no separate "array" vs. "dictionary"/"map" type distinction, unlike Python's
// list/dict split or Go's slice/map split.

$list = [1, 2, 3];               // sequential integer keys, 0-indexed
$assoc = ["name" => "Ada", "age" => 30]; // string keys -- same underlying `array` type

echo "list: " . implode(", ", $list) . "\n";
echo "assoc: name={$assoc['name']}, age={$assoc['age']}\n";

echo "\n--- Mixing keys in one array (legal, since it's one type) ---\n";
$mixed = ["a", "b", 5 => "c", "key" => "d"];
var_dump($mixed);

echo "\n--- array_map / array_filter / array_reduce ---\n";
$nums = [1, 2, 3, 4, 5];
$doubled = array_map(fn($n) => $n * 2, $nums);
$evens = array_filter($nums, fn($n) => $n % 2 === 0);
$total = array_reduce($nums, fn($carry, $n) => $carry + $n, 0);
echo "doubled: " . implode(", ", $doubled) . "\n";
echo "evens: " . implode(", ", $evens) . "\n"; // NOTE: keys are preserved by array_filter!
echo "total: {$total}\n";

echo "\n--- array_filter preserves original keys -- a common gotcha ---\n";
var_dump($evens); // keys are 1 and 3 (the ORIGINAL indices), NOT re-indexed to 0, 1
var_dump(array_values($evens)); // array_values() re-indexes from 0 if that's needed

echo "\n--- Destructuring (list assignment) ---\n";
[$first, $second, $third] = $list;
echo "destructured: {$first}, {$second}, {$third}\n";
["name" => $n, "age" => $a] = $assoc; // keyed destructuring too
echo "keyed destructure: {$n}, {$a}\n";

echo "\n--- Spread operator in array literals (PHP 7.4+) ---\n";
$combined = [...$list, ...[4, 5]];
echo "combined: " . implode(", ", $combined) . "\n";

echo "\n--- sort() vs usort() -- mutates in place, returns bool not the array ---\n";
$unsorted = [3, 1, 4, 1, 5];
sort($unsorted); // mutates $unsorted directly
echo "sorted: " . implode(", ", $unsorted) . "\n";
