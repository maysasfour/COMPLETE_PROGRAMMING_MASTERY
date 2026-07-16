<?php
// example.php - PHP has no compile step: the interpreter parses and executes this file
// directly, top to bottom, every time it's invoked (`php example.php`).

echo "Hello, PHP!\n";
echo "PHP version: " . PHP_VERSION . "\n";
echo "This file ran directly -- no build step, no bytecode artifact left on disk.\n";

// phpinfo() would print a huge configuration dump; here we check a few relevant
// settings directly instead, to keep the output readable and verifiable.
echo "\n--- Relevant loaded extensions for this course ---\n";
foreach (["pdo_sqlite", "sqlite3", "curl", "openssl", "json", "mbstring"] as $ext) {
    $loaded = extension_loaded($ext) ? "loaded" : "NOT loaded";
    echo "  {$ext}: {$loaded}\n";
}
