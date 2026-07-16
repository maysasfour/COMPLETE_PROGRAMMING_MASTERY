# 12 — Functional Concepts

[Back to course overview](../README.md) | [Previous: OOP](../11-OOP/README.md)

## Learning Objectives

- Understand that PHP closures capture variables by **value** (a snapshot) by default, and only by reference with an explicit `use (&$var)`.
- Write higher-order functions (functions returning functions) and compose several callables together.
- Use both callable-as-string and first-class callable syntax (`fn_name(...)`) with `array_map`/`array_filter`.

## Prerequisites

[11-OOP](../11-OOP/README.md)

## Concept

PHP closures (anonymous `function`s and arrow `fn`s) support functional-style programming: passing functions as values, returning functions from functions, and composing them. The one genuinely distinctive detail, worth verifying rather than assuming, is exactly **how** outer variables get captured.

## Capture by Value (Default) vs. by Reference (`use (&$var)`)

```php
$counter = 0;
$snapshot = function () use ($counter) {
    return $counter + 1; // captures the VALUE of $counter AT CREATION TIME
};
$counter = 100;
echo $snapshot(); // 1, NOT 101 -- the closure kept its own snapshot, not a live link
```

```php
$total = 0;
$addToTotal = function (int $n) use (&$total) { // & makes this a REFERENCE capture
    $total += $n; // mutates the OUTER $total directly
};
$addToTotal(5);
$addToTotal(10);
echo $total; // 15 -- genuinely mutated
```

Verified live: without `&`, a closure captures a frozen snapshot of the variable's value at the moment the closure is created — later changes to the outer variable are invisible to the closure. With `&$var` in the `use` clause, the closure instead holds a live reference, and any mutation inside the closure is visible outside it (and vice versa). This exactly mirrors the by-value vs. by-reference parameter distinction from Lesson 06, applied to closure captures instead of function parameters.

## Higher-Order Functions

```php
function multiplier(int $factor): Closure {
    return fn(int $x): int => $x * $factor;
}
$double = multiplier(2);
$triple = multiplier(3);
```

## Function Composition

```php
function compose(callable ...$fns): Closure {
    return function ($x) use ($fns) {
        foreach (array_reverse($fns) as $fn) { $x = $fn($x); }
        return $x;
    };
}
$addThenSquare = compose($square, $addOne); // square(addOne(x))
```

## Callable-as-String vs. First-Class Callable Syntax

```php
function isEven(int $n): bool { return $n % 2 === 0; }
array_filter($nums, 'isEven');     // older convention: function name as a string
array_filter($nums, isEven(...));   // PHP 8.1+ first-class callable syntax (Lesson 06)
```

Both produce identical results — the string form is an older PHP convention still common in existing codebases, while `isEven(...)` is the more modern, IDE-friendly, refactor-safe syntax (renaming `isEven` breaks silently with the string form but is caught by static analysis with the `(...)` form).

## Detailed Example

See [example.php](example.php) — all of the above, run and verified, including the live-confirmed value-vs-reference capture distinction (`1` vs. the mutated `15`).

## Run It

```bash
cd 01-Languages/PHP/12-Functional-Concepts
php example.php
```

## Expected Output

Running `php example.php` prints `1` (confirming value-capture froze `$counter` at `0`, not `100`), `total: 15` (confirming reference-capture genuinely mutated the outer variable), `10 15` (the two multiplier closures), `25` (the composed `square(addOne(4))`), and two identical `2, 4, 6` lines (the string-callable and first-class-callable `array_filter` results).

## Common Mistakes

- Assuming a closure automatically sees later changes to a captured outer variable — by default it doesn't; only an explicit `use (&$var)` reference capture provides that, verified live in this lesson.
- Using `use (&$var)` reflexively for every closure "just in case" — reference capture is a real, deliberate choice with mutation side effects; default value-capture is safer and should be the default unless mutation is specifically intended.
- Using the string-callable form (`'functionName'`) in new code without realizing static analyzers and IDEs can't verify it the way they can verify `functionName(...)`.

## Best Practices

- Default to value-capture (`use ($var)`, no `&`) unless a closure specifically needs to mutate an outer variable — reference capture should be a deliberate, visible choice at the call site.
- Prefer first-class callable syntax (`fn_name(...)`) over string/array-based callables in PHP 8.1+ codebases for better refactoring safety and static analysis support.
- Use `Closure` as the return type hint for functions returning closures, for clearer signatures.

## Real-World Usage

The value-vs-reference closure capture distinction matters directly in real PHP code building up aggregate state across callback invocations (event handlers, accumulator patterns in data pipelines) — forgetting the `&` is a genuine, recurring bug source where a closure appears to accumulate state but silently doesn't.

## Summary

- PHP closures capture outer variables by value (a frozen snapshot) by default; `use (&$var)` captures by reference instead, verified live to produce genuinely different behavior.
- Higher-order functions and composition work as in any functional-capable language.
- First-class callable syntax (`fn_name(...)`, PHP 8.1+) is the modern alternative to string/array-based callables.

## Key Terms

- **Capture by value** — a closure's default behavior: it stores a snapshot of an outer variable's value at creation time, not a live link.
- **Capture by reference (`use (&$var)`)** — an explicit closure capture mode creating a live, mutable link to the outer variable.

## Interview Questions

1. **Why did a PHP closure using `use ($var)` fail to see a later change to the outer `$var`, and how would you fix it?**
   By default, PHP's `use` clause captures a variable by value — the closure stores a snapshot of whatever `$var` held at the moment the closure was created, not a live reference to the variable itself. This was verified directly: a closure capturing `$counter` at `0` still returned `1` (based on the captured `0`) even after the outer `$counter` was reassigned to `100`. The fix is to capture by reference instead: `use (&$var)`, which links the closure to the actual outer variable, so later mutations (in either direction) are visible to both.

2. **What's the practical difference between `array_filter($arr, 'isEven')` and `array_filter($arr, isEven(...))`?**
   Both call the same `isEven` function and produce identical runtime results — the difference is entirely about tooling and maintainability. `'isEven'` is a string that PHP resolves to a callable at call time; if `isEven` is renamed, nothing catches the now-broken string reference until runtime. `isEven(...)` (PHP 8.1+ first-class callable syntax) creates an actual `Closure` object referencing the function directly, so IDEs and static analyzers can track the reference and flag it immediately if the function is renamed or removed — a genuine refactoring-safety improvement with no downside once PHP 8.1+ is available.

## Recommended Next Lesson

[13 — Generics](../13-Generics/README.md)
