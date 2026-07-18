<?php

declare(strict_types=1);

/**
 * Exercise 05 — The Split Error / Exception / Throwable Hierarchy
 *
 * ValidationException (extends Exception) and ArgumentCountError (built-in,
 * extends Error) share NO common ancestor other than the Throwable
 * interface itself -- PHP deliberately keeps "expected failure" (Exception)
 * and "programming mistake" (Error) as two unrelated trees so catch blocks
 * can choose how broad or narrow to be.
 */
final class ValidationException extends Exception
{
}

function requireAdult(int $age, string $name): string
{
    if ($age < 18) {
        throw new ValidationException("{$name} is {$age}, which is under 18");
    }
    return "{$name} is an adult.";
}

// A strictly-typed function requiring two parameters -- calling it with one
// triggers PHP's own built-in ArgumentCountError, not anything hand-written.
function requireTwoArgs(string $a, string $b): string
{
    return "{$a}-{$b}";
}

$attempts = [
    fn () => requireAdult(15, "Sam"),
    // @phpstan-ignore-next-line -- deliberately wrong arg count, that's the point
    fn () => requireTwoArgs("only-one"),
];

foreach ($attempts as $i => $attempt) {
    try {
        echo $attempt() . "\n";
    } catch (Throwable $t) {
        // instanceof against Error vs. Exception is how code distinguishes
        // "this needs a bug fix" from "this was an expected, handled failure"
        // even though both were caught through the same Throwable catch clause.
        $branch = $t instanceof Error ? 'Error' : 'Exception';
        echo "Attempt {$i} caught a {$branch}: " . get_class($t) . " -- {$t->getMessage()}\n";
    }
}
