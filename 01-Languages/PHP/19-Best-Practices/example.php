<?php
declare(strict_types=1);
// example.php - Before/after: three genuine PHP anti-patterns and their fixes, each
// reproduced live to show the bad version actually misbehaving, not just described.

echo "--- Anti-pattern 1: loose (==) comparison on user input ---\n";
function isAdminBad($role): bool {
    return $role == 0; // loose comparison
}
function isAdminGood($role): bool {
    return $role === 0; // strict comparison
}
// A real login-like scenario: role is normally an int, but user input often arrives as a string.
var_dump(isAdminBad("admin"));   // true in PHP 7 (== coerces "admin" to 0), false in PHP 8+
var_dump(isAdminGood("admin")); // false -- correctly rejects a non-numeric string, on ANY PHP version
var_dump(isAdminBad("0"));        // true -- "0" == 0 is true even in PHP 8 (numeric string)
var_dump(isAdminGood("0"));       // false -- strict comparison correctly distinguishes string "0" from int 0
echo "(isAdminGood is correct and version-independent; isAdminBad's behavior depends on the PHP version\n";
echo " AND still incorrectly accepts the STRING \"0\" as if it were the int 0)\n";

echo "\n--- Anti-pattern 2: building SQL by concatenation instead of parameterized queries ---\n";
function findUserBad(PDO $pdo, string $username): array|false {
    // NEVER do this -- string concatenation makes SQL injection trivial
    $sql = "SELECT * FROM users WHERE username = '{$username}'";
    return $pdo->query($sql)->fetch(PDO::FETCH_ASSOC) ?: false;
}
function findUserGood(PDO $pdo, string $username): array|false {
    $stmt = $pdo->prepare("SELECT * FROM users WHERE username = :username");
    $stmt->execute(["username" => $username]);
    return $stmt->fetch(PDO::FETCH_ASSOC) ?: false;
}

$pdo = new PDO("sqlite::memory:");
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$pdo->exec("CREATE TABLE users (id INTEGER PRIMARY KEY, username TEXT)");
$pdo->exec("INSERT INTO users (username) VALUES ('alice')");

$maliciousInput = "nonexistent' OR '1'='1"; // classic SQL injection payload
$badResult = findUserBad($pdo, $maliciousInput);
$goodResult = findUserGood($pdo, $maliciousInput);
echo "bad (vulnerable) query returned: " . ($badResult ? "a row! ({$badResult['username']}) -- INJECTION SUCCEEDED\n" : "no row\n");
echo "good (parameterized) query returned: " . ($goodResult ? "a row\n" : "no row -- correctly rejected the malicious input\n");

echo "\n--- Anti-pattern 3: not checking file operation return values ---\n";
function readConfigBad(string $path): array {
    $contents = file_get_contents($path); // no check -- if this fails, $contents is false
    return json_decode($contents, true); // json_decode(false, true) -- TypeError, or silently null
}
function readConfigGood(string $path): array {
    $contents = file_get_contents($path);
    if ($contents === false) {
        throw new RuntimeException("could not read config file: {$path}");
    }
    $decoded = json_decode($contents, true);
    if ($decoded === null && json_last_error() !== JSON_ERROR_NONE) {
        throw new RuntimeException("invalid JSON in config file: {$path}");
    }
    return $decoded;
}

try {
    readConfigBad(__DIR__ . "/does-not-exist.json");
} catch (\Throwable $e) {
    echo "bad version's actual failure: " . get_class($e) . ": " . $e->getMessage() . "\n";
}
try {
    readConfigGood(__DIR__ . "/does-not-exist.json");
} catch (\Throwable $e) {
    echo "good version's clear, intentional failure: " . get_class($e) . ": " . $e->getMessage() . "\n";
}
