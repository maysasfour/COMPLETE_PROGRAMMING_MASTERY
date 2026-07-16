<?php
declare(strict_types=1);

function average(float ...$numbers): float {
    return array_sum($numbers) / count($numbers);
}

$square = fn(float $x): float => $x * $x;

$values = [1.0, 2.0, 3.0, 4.0];
$squared = array_map($square, $values);
echo "squared: " . implode(", ", $squared) . "\n";
echo "average of squares: " . average(...$squared) . "\n"; // spread operator unpacks the array
