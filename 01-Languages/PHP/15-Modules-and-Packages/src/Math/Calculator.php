<?php
declare(strict_types=1);

namespace Math; // groups this class under the Math\ namespace, unrelated to the directory
                // name by LANGUAGE RULE -- but PSR-4 autoloading (shown in main.php) maps
                // namespace segments to directory paths BY CONVENTION, not by compiler enforcement.

class Calculator {
    public function add(float $a, float $b): float { return $a + $b; }
    public function multiply(float $a, float $b): float { return $a * $b; }
}
