<?php
declare(strict_types=1);

namespace App;

class Calculator {
    public function add(int $a, int $b): int { return $a + $b; }

    public function divide(float $a, float $b): float {
        if ($b === 0.0) {
            throw new \InvalidArgumentException("division by zero");
        }
        return $a / $b;
    }

    public function isPalindrome(string $s): bool {
        $cleaned = strtolower(preg_replace('/[^a-zA-Z0-9]/', '', $s));
        return $cleaned === strrev($cleaned);
    }
}
