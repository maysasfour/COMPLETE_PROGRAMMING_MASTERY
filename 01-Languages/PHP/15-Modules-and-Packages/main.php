<?php
declare(strict_types=1);
// main.php - namespaces, require_once, and a hand-written PSR-4-style autoloader (the same
// mechanism Composer's `composer install` generates automatically -- shown here manually
// so this lesson runs with zero external tooling, since Composer isn't installed).

echo "--- Manual require_once (works, but doesn't scale past a few files) ---\n";
require_once __DIR__ . "/src/Math/Calculator.php";
$calc = new \Math\Calculator(); // \Math\ -- fully-qualified namespace path from the global namespace
echo $calc->add(2, 3), "\n";

echo "\n--- PSR-4 autoloading: register a loader instead of require_once-ing every file ---\n";
// PSR-4 (a PHP-FIG standard Composer implements) maps a namespace PREFIX to a base directory;
// classes are loaded on first use, lazily, with no manual require_once calls at all.
spl_autoload_register(function (string $class): void {
    $prefix = "App\\";
    $baseDir = __DIR__ . "/src2/";
    if (!str_starts_with($class, $prefix)) {
        return; // not our namespace -- let another registered autoloader (if any) try
    }
    $relativeClass = substr($class, strlen($prefix));
    $file = $baseDir . str_replace("\\", "/", $relativeClass) . ".php";
    if (file_exists($file)) {
        require $file;
    }
});

$greeter = new \App\Greeter(); // Greeter.php has NEVER been require_once'd -- autoloaded on first use
echo $greeter->greet("World"), "\n";

echo "\n--- use: import a namespaced class with a short alias ---\n";
use Math\Calculator as Calc;
$calc2 = new Calc();
echo $calc2->multiply(4, 5), "\n";
