<?php

declare(strict_types=1);

/**
 * Exercise 01 — Match-Based Grade Calculator
 *
 * match(true) works because match compares its subject (true) against each
 * arm's expression with === ; writing a boolean condition as an arm turns
 * match into a range check. A plain switch ($score) or match ($score) can
 * only test $score for exact equality against each case/arm, which cannot
 * express "80 <= $score <= 89" at all.
 */
function letterGrade(int $score): string
{
    if ($score < 0 || $score > 100) {
        // ValueError is PHP's own built-in exception for a correctly-typed
        // argument that is nonetheless semantically invalid -- no custom
        // exception class needed for a case the standard library already covers.
        throw new ValueError("score must be between 0 and 100, got {$score}");
    }

    return match (true) {
        $score >= 90 => 'A',
        $score >= 80 => 'B',
        $score >= 70 => 'C',
        $score >= 60 => 'D',
        default => 'F',
    };
}

foreach ([100, 90, 89, 60, 59, 0] as $score) {
    echo "{$score} -> " . letterGrade($score) . "\n";
}

try {
    letterGrade(105);
} catch (ValueError $e) {
    echo "Caught expected ValueError: {$e->getMessage()}\n";
}
