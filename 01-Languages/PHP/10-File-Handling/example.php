<?php
declare(strict_types=1);
// example.php - file_put_contents/file_get_contents (simplest API), fopen/fwrite/fclose
// (lower-level, streaming), json_encode/json_decode (built in -- PHP, unlike Java/C++/Rust,
// has genuinely built-in JSON support, no external library needed).

$dir = __DIR__ . "/scratch";
if (!is_dir($dir)) {
    mkdir($dir);
}
$path = "{$dir}/notes.txt";

echo "--- file_put_contents / file_get_contents (simplest API) ---\n";
file_put_contents($path, "line one\nline two\n");
$contents = file_get_contents($path);
echo $contents;

echo "\n--- Appending with FILE_APPEND ---\n";
file_put_contents($path, "line three\n", FILE_APPEND);
echo file_get_contents($path);

echo "\n--- Reading line by line with fopen/fgets/fclose ---\n";
$handle = fopen($path, "r");
$lineNum = 1;
while (($line = fgets($handle)) !== false) {
    echo "{$lineNum}: " . rtrim($line) . "\n";
    $lineNum++;
}
fclose($handle);

echo "\n--- Handling a missing file (no exception by default -- returns false + a warning) ---\n";
$missing = @file_get_contents("{$dir}/does-not-exist.txt"); // @ suppresses the warning
var_dump($missing); // bool(false)
if ($missing === false) {
    echo "file not found -- checked via === false, not an exception\n";
}

echo "\n--- Built-in JSON support (unlike Java/C++/Rust, no library needed) ---\n";
$data = ["name" => "Ada", "age" => 30, "active" => true];
$json = json_encode($data, JSON_PRETTY_PRINT);
echo $json, "\n";
$decoded = json_decode($json, true); // true = associative array, not stdClass
echo "decoded name: {$decoded['name']}\n";

// clean up generated files -- this course never leaves scratch artifacts behind
unlink($path);
rmdir($dir);
