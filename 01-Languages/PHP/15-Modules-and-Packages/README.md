# 15 — Modules and Packages

[Back to course overview](../README.md) | [Previous: Async and Concurrency](../14-Async-and-Concurrency/README.md)

## Learning Objectives

- Use `namespace`/`use`/fully-qualified class names, and `require`/`require_once`.
- Understand PSR-4 autoloading: mapping a namespace prefix to a directory by *convention*, loading classes lazily on first use with no manual `require_once` calls.
- Understand Composer's role (PHP's de facto standard package manager) even without it installed in this environment.

## Prerequisites

[14-Async-and-Concurrency](../14-Async-and-Concurrency/README.md)

## Concept

PHP namespaces (`namespace Math;`) organize classes hierarchically and prevent naming collisions, similar to C#/Java's packages/namespaces — but PHP's namespace-to-file mapping is **not enforced by the language** the way Java enforces package-directory matching. Instead, the **PSR-4** standard (a PHP-FIG community convention that Composer implements) maps namespace prefixes to base directories by agreement, and an autoloader function resolves a class name to a file path only when the class is first referenced.

## Namespaces and Fully-Qualified Names

```php
namespace Math;

class Calculator {
    public function add(float $a, float $b): float { return $a + $b; }
}
```

```php
require_once __DIR__ . "/src/Math/Calculator.php";
$calc = new \Math\Calculator(); // fully-qualified from the global namespace (leading \)
```

## `use`: Importing a Short Alias

```php
use Math\Calculator as Calc;
$calc2 = new Calc();
```

## PSR-4 Autoloading: No Manual `require_once` Per File

```php
spl_autoload_register(function (string $class): void {
    $prefix = "App\\";
    $baseDir = __DIR__ . "/src2/";
    if (!str_starts_with($class, $prefix)) return;
    $relativeClass = substr($class, strlen($prefix));
    $file = $baseDir . str_replace("\\", "/", $relativeClass) . ".php";
    if (file_exists($file)) require $file;
});

$greeter = new \App\Greeter(); // Greeter.php loaded lazily, on first reference -- no require_once
```

Verified live: `\App\Greeter` was instantiated with **no** `require_once` for its file anywhere in the script — `spl_autoload_register()`'s callback ran automatically the moment the class name was first referenced, translated `App\Greeter` into `src2/Greeter.php`, and loaded it just-in-time. This hand-written loader is exactly the mechanism Composer generates and wires up automatically via `composer.json`'s `autoload.psr-4` section and the generated `vendor/autoload.php` — shown manually here since Composer itself isn't installed in this environment, but functionally identical to what `require 'vendor/autoload.php';` provides in a real Composer-managed project.

## Composer (Not Installed Here, but the De Facto Standard)

```json
{
    "require": { "php": ">=8.1" },
    "autoload": { "psr-4": { "App\\": "src/" } }
}
```

A real Composer project declares its PSR-4 mapping in `composer.json`; running `composer install`/`composer dump-autoload` generates `vendor/autoload.php`, which any script includes once (`require 'vendor/autoload.php';`) to get every mapped class autoloading for free, plus dependency resolution from Packagist (PHP's public package registry) — conceptually identical to npm/Cargo/NuGet covered in this repository's other language courses, though not runnable in this specific environment.

## Detailed Example

See [main.php](main.php), [src/Math/Calculator.php](src/Math/Calculator.php), and [src2/Greeter.php](src2/Greeter.php) — the `require_once` approach, the hand-written PSR-4 autoloader, and the `use`-alias import, all run and verified together in one script.

## Run It

```bash
cd 01-Languages/PHP/15-Modules-and-Packages
php main.php
```

## Expected Output

Running `php main.php` prints `5` (from the manually-required `Calculator::add`), `Hello, World! (autoloaded, never require_once'd)` (confirming the PSR-4-style autoloader loaded `Greeter.php` lazily), and `20` (from `Calculator::multiply`, accessed via the `use`-imported short alias `Calc`).

## Common Mistakes

- Assuming a class's namespace must match its directory path by *language rule* — PHP doesn't enforce this at all (unlike Java, which does); PSR-4 is purely a widely-adopted *convention* that autoloaders (including Composer's) rely on, but nothing prevents a namespace from diverging from the actual file layout.
- Registering an autoloader that doesn't check the namespace prefix before attempting to load a file — this can cause confusing behavior when multiple autoloaders are registered (Composer's own, plus a custom one) and one swallows a class it shouldn't handle.
- Forgetting the leading `\` when referencing a fully-qualified class name from inside a different namespace — omitting it causes PHP to look for the class relative to the *current* namespace instead of the global one.

## Best Practices

- Use Composer and its PSR-4 autoloading in any real, non-trivial PHP project — hand-written `spl_autoload_register` loaders (as shown here) are useful for understanding the mechanism, but Composer's tooling (dependency resolution, version constraints, `vendor/autoload.php` generation) is the practical standard.
- Keep an autoloader's namespace-to-directory mapping simple and consistent — deviating from PSR-4 conventions makes a codebase harder for new contributors (and tooling) to navigate.
- Use `use` imports for readability instead of writing fully-qualified `\Long\Namespace\Path\ClassName` repeatedly.

## Real-World Usage

Virtually every modern, professionally-maintained PHP project (Laravel, Symfony, and the vast majority of Packagist packages) uses Composer with PSR-4 autoloading as the standard dependency-management and class-loading mechanism — understanding what `vendor/autoload.php` actually does under the hood (exactly what this lesson's hand-written `spl_autoload_register` demonstrates) is valuable for debugging autoloading issues in real projects.

## Summary

- `namespace`/`use` organize and reference classes hierarchically; fully-qualified names start with a leading `\`.
- PHP does not enforce namespace-to-directory matching at the language level — PSR-4 is a widely-adopted convention, implemented by autoloaders like Composer's, not a compiler rule.
- `spl_autoload_register()` is the underlying mechanism enabling lazy, on-first-use class loading with no manual `require_once` per file — verified live in this lesson, and exactly what Composer's generated autoloader does automatically.

## Key Terms

- **PSR-4** — a PHP-FIG community standard mapping namespace prefixes to base directories for autoloading purposes.
- **`spl_autoload_register()`** — registers a callback PHP invokes automatically when an as-yet-undefined class is first referenced.

## Interview Questions

1. **Does PHP enforce that a class's namespace matches its file's directory path, the way Java enforces package-directory matching?**
   No — PHP itself has no such rule; a class's `namespace` declaration and its actual file location are completely independent as far as the language is concerned. PSR-4 (the convention Composer and most autoloaders implement) *establishes* a namespace-to-directory mapping, but this is enforced by the autoloader's logic (checking a prefix and constructing a file path), not by the PHP interpreter itself — a class could technically live anywhere and still be `require`d manually with no name-based restriction at all.

2. **How does a class get loaded with no explicit `require`/`require_once` call anywhere in the calling code?**
   Through `spl_autoload_register()`, which registers a callback PHP invokes automatically the first time an as-yet-undefined class name is referenced (e.g., `new \App\Greeter()`). The callback receives the class name as a string, and is responsible for translating it to a file path and `require`ing it if found — verified directly in this lesson, where `Greeter.php` was loaded lazily on first use with no `require_once` call for it anywhere in the script. Composer's generated `vendor/autoload.php` registers exactly this kind of callback automatically, based on the PSR-4 mapping declared in a project's `composer.json`.

## Recommended Next Lesson

[16 — Database Access](../16-Database-Access/README.md)
