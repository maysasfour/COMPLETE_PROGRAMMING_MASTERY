<?php
declare(strict_types=1);
// example.php - string functions, heredoc/nowdoc, multibyte (mb_*) vs. byte-based functions,
// sprintf, and str_contains/str_starts_with/str_ends_with (PHP 8+).

$s = "Hello, World!";
echo strtoupper($s), "\n";
echo strtolower($s), "\n";
echo strlen($s), "\n";              // BYTE length
echo str_replace("World", "PHP", $s), "\n";
echo substr($s, 7, 5), "\n";          // "World"

echo "\n--- str_contains / str_starts_with / str_ends_with (PHP 8+) ---\n";
var_dump(str_contains($s, "World"));
var_dump(str_starts_with($s, "Hello"));
var_dump(str_ends_with($s, "!"));

echo "\n--- sprintf for formatted output ---\n";
echo sprintf("%s is %d years old, %.2f%% done\n", "Ada", 30, 66.666);

echo "\n--- Heredoc (interpolated) vs Nowdoc (literal, like single quotes) ---\n";
$name = "Ada";
$heredoc = <<<EOT
Hello, {$name}!
This interpolates, like double quotes.
EOT;
echo $heredoc, "\n";

$nowdoc = <<<'EOT'
Hello, {$name}!
This does NOT interpolate, like single quotes.
EOT;
echo $nowdoc, "\n";

echo "\n--- Multibyte strings: strlen (bytes) vs mb_strlen (characters) ---\n";
$multibyte = "héllo"; // é is a 2-byte UTF-8 character
echo "strlen (bytes): " . strlen($multibyte) . "\n";      // 6 -- byte count
echo "mb_strlen (chars): " . mb_strlen($multibyte) . "\n";  // 5 -- character count
// This mirrors the byte-vs-rune distinction from the Go and Rust courses exactly.
