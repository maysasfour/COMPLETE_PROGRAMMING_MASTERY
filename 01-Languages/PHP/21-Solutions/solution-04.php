<?php

declare(strict_types=1);

/**
 * Exercise 04 — Closures: use (&$var) vs. use ($var)
 *
 * use (&$count) binds the closure to the SAME storage location as the
 * enclosing $count variable at the time the closure literal is evaluated --
 * both returned closures keep referring to that one location for as long as
 * either closure lives, even after makeCounter() itself has returned.
 */
function makeCounter(): array
{
    $count = 0;

    $increment = function () use (&$count): int {
        return ++$count;
    };
    $reset = function () use (&$count): void {
        $count = 0;
    };

    return [$increment, $reset];
}

[$inc, $reset] = makeCounter();
echo "increment: {$inc()}, {$inc()}, {$inc()}\n"; // 1, 2, 3 -- shared state
$reset();
echo "after reset: {$inc()}\n"; // back to 1, proving reset() touched the SAME $count

/**
 * use ($start) by contrast copies the value of $start into the closure at
 * creation time -- each closure gets its own independent snapshot, and later
 * changes to the original variable (or to another closure's copy) never
 * propagate anywhere else.
 */
function makeSnapshot(int $start): Closure
{
    $value = $start;

    $peek = function () use ($value): int {
        return $value;
    };
    // Mutating this local $value only affects THIS closure's own copy --
    // $peek's captured $value was already frozen when the closure was built.
    $value = 999;

    return $peek;
}

$snapshotA = makeSnapshot(10);
$snapshotB = makeSnapshot(20);
echo "snapshotA: {$snapshotA()}, snapshotB: {$snapshotB()}\n"; // 10, 20 -- independent, and the later $value = 999 inside makeSnapshot never leaked out

// A real-world-shaped by-reference example: accumulating a total via array_walk.
$numbers = [4, 8, 15, 16, 23, 42];
$total = 0;
array_walk($numbers, function (int $n) use (&$total): void {
    $total += $n;
});
echo "array_walk total: {$total}\n";
