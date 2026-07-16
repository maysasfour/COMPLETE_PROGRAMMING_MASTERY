<?php
// example.php - if/elseif/else, switch (fall-through by default, like C/JS), match (PHP 8+,
// strict comparison + no fall-through), loops, and alternative syntax for templating contexts.

$score = 85;
if ($score >= 90) {
    echo "A\n";
} elseif ($score >= 80) {
    echo "B\n";
} else {
    echo "C or below\n";
}

echo "\n--- switch: falls through by default, like C/JS/C++ (NOT like Go) ---\n";
$day = 3;
switch ($day) {
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
        echo "Weekday\n";
        break; // required, or execution falls into the next case
    case 6:
    case 7:
        echo "Weekend\n";
        break;
    default:
        echo "Invalid day\n";
}

echo "\n--- match (PHP 8+): strict comparison, no fall-through, is an EXPRESSION ---\n";
$grade = match (true) {
    $score >= 90 => "A",
    $score >= 80 => "B",
    default => "C or below",
};
echo "match result: {$grade}\n";

// match uses === under the hood -- unlike switch, which uses ==
$value = "1";
$result = match ($value) {
    1 => "matched the integer 1",
    "1" => "matched the string \"1\"",
    default => "no match",
};
echo "strict match: {$result}\n"; // matches the STRING case, since match uses strict comparison

echo "\n--- Loops ---\n";
for ($i = 0; $i < 3; $i++) {
    echo "for: {$i}\n";
}
$i = 0;
while ($i < 3) {
    echo "while: {$i}\n";
    $i++;
}
foreach (["a", "b", "c"] as $index => $letter) {
    echo "foreach: {$index} => {$letter}\n";
}
