<?php
declare(strict_types=1);
// example.php - closures, capture-by-value vs capture-by-reference (`use (&$var)`),
// higher-order functions, function composition, and PHP's callable-as-string/array quirk.

echo "--- Closures capture by VALUE by default -- a snapshot, not a live reference ---\n";
$counter = 0;
$incrementSnapshot = function () use ($counter) {
    return $counter + 1; // uses the VALUE of $counter at closure-creation time
};
$counter = 100;
echo $incrementSnapshot(), "\n"; // 1, NOT 101 -- captured 0, not a live reference to $counter

echo "\n--- use (&\$var): capture BY REFERENCE, a live link to the outer variable ---\n";
$total = 0;
$addToTotal = function (int $n) use (&$total) {
    $total += $n; // mutates the OUTER $total directly
};
$addToTotal(5);
$addToTotal(10);
echo "total: {$total}\n"; // 15 -- genuinely mutated via reference capture

echo "\n--- Higher-order functions: a function returning a function ---\n";
function multiplier(int $factor): Closure {
    return fn(int $x): int => $x * $factor;
}
$double = multiplier(2);
$triple = multiplier(3);
echo $double(5), " ", $triple(5), "\n"; // 10 15

echo "\n--- Function composition ---\n";
function compose(callable ...$fns): Closure {
    return function ($x) use ($fns) {
        foreach (array_reverse($fns) as $fn) {
            $x = $fn($x);
        }
        return $x;
    };
}
$addOne = fn($x) => $x + 1;
$square = fn($x) => $x * $x;
$addThenSquare = compose($square, $addOne); // square(addOne(x))
echo $addThenSquare(4), "\n"; // (4+1)^2 = 25

echo "\n--- array_map/array_filter/array_reduce with named functions, not just closures ---\n";
function isEven(int $n): bool { return $n % 2 === 0; }
$nums = [1, 2, 3, 4, 5, 6];
$evens = array_filter($nums, 'isEven'); // callable-as-string -- an older PHP convention
echo implode(", ", $evens), "\n";
// modern equivalent using first-class callable syntax (Lesson 06):
$evensModern = array_filter($nums, isEven(...));
echo implode(", ", $evensModern), "\n";
