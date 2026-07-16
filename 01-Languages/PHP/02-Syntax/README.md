# 02 — Syntax

[Back to course overview](../README.md) | [Previous: Setup](../01-Setup/README.md)

## Learning Objectives

- Use PHP's opening/closing tags, statement/comment syntax, and `echo`/`print`.
- Distinguish single-quoted (literal) from double-quoted (interpolated) strings.
- Use `var_dump()` to inspect a value's real type — essential given PHP's dynamic typing.

## Prerequisites

[01-Setup](../01-Setup/README.md)

## Concept

PHP code lives inside `<?php ... ?>` tags — everything outside them is treated as literal output (a holdover from PHP's original design as an HTML templating layer). Pure-PHP files (like every example in this course) conventionally omit the closing `?>` tag entirely.

## A Genuine, Verified Gotcha: `?>` Inside a Comment Still Closes PHP Mode

While writing this lesson's own example file, a `//` comment describing the closing tag contained the literal characters `?>` — and PHP's parser switched out of PHP mode **immediately at that point, mid-comment**, treating everything after it as raw text to print verbatim. Running the file printed the rest of the source code itself instead of executing it, confirmed live, not assumed:

```php
// Everything PHP executes must be inside <?php ... ?> tags -- BREAKS HERE
```

The parser looks for the `?>` character sequence to end PHP mode **regardless of whether it appears inside a comment**, since tokenizing happens before comment content is semantically understood as "just a comment." The practical lesson: never write a literal `?>` inside PHP source, including inside comments and strings, unless you specifically intend to end PHP mode there.

## Comments, Statements, and Output

```php
// single-line comment
# also single-line (shell-style)
/* multi-line
   comment */

echo "Statements end with a semicolon.\n";
print "print is an alternative to echo (a language construct, not a function).\n";
```

## Single vs. Double Quotes

```php
$name = "World";
echo "Hello, {$name}!\n";      // double quotes: variables ARE interpolated
echo 'Hello, $name!' . "\n";   // single quotes: $name stays LITERAL, no interpolation
```

Single-quoted strings are marginally faster (no interpolation scanning) and are the idiomatic choice for strings with no variables or escape sequences; double-quoted strings are used whenever interpolation or escape sequences (`\n`, `\t`) are needed.

## `var_dump()` for Type Inspection

```php
var_dump(42);      // int(42)
var_dump(3.14);    // float(3.14)
var_dump("text");  // string(4) "text"
var_dump(true);    // bool(true)
var_dump(null);    // NULL
```

Since PHP is dynamically typed (Lesson 03 covers this in depth), `var_dump()` is the standard way to inspect a value's actual runtime type and content rather than guessing from surrounding code.

## Detailed Example

See [example.php](example.php) — the comment/statement/string-interpolation/`var_dump()` demonstrations above, with the `?>`-in-comment gotcha fixed and explained inline as a code comment (without repeating the literal sequence that caused it).

## Run It

```bash
cd 01-Languages/PHP/02-Syntax
php example.php
```

## Expected Output

Running `php example.php` prints the two `echo`/`print` lines, the interpolated vs. literal string lines, and five `var_dump()` lines showing `int`, `float`, `string`, `bool`, and `NULL` types respectively.

## Common Mistakes

- Writing a literal `?>` sequence anywhere in PHP source — including inside a comment or a string — not realizing it terminates PHP mode immediately, exactly as reproduced above.
- Using single quotes when interpolation was intended (`'Hello, $name!'` prints the literal text `$name`, not the variable's value) — a genuinely common beginner mix-up given how similar single/double quotes look.

## Best Practices

- Omit the closing `?>` tag in pure-PHP files — it prevents accidental trailing whitespace/newlines after it from being sent as output, and sidesteps the "literal `?>` inside a comment" gotcha entirely for the file's own closing tag.
- Use single quotes by default for strings with no variables/escapes; switch to double quotes only when interpolation or escape sequences are actually needed.

## Real-World Usage

Because PHP's tags allow mixing HTML and PHP freely, older PHP code and simple scripts often interleave `<?php ?>` blocks directly inside HTML; modern PHP applications (frameworks like Laravel/Symfony) instead use dedicated templating engines and keep PHP logic in pure-PHP files like the ones in this course, precisely to avoid the readability and gotchas of mixed-mode files.

## Summary

- PHP code lives inside `<?php ... ?>` tags; pure-PHP files omit the closing tag.
- A literal `?>` sequence ends PHP mode immediately, even inside a comment — verified live in this lesson.
- Double-quoted strings interpolate variables; single-quoted strings don't.
- `var_dump()` reveals a value's real type, essential for PHP's dynamic typing.

## Key Terms

- **PHP tags** — `<?php` and `?>`, delimiting PHP code from surrounding output.
- **String interpolation** — embedding a variable's value directly inside a double-quoted string.

## Interview Questions

1. **What happens if a literal `?>` appears inside a PHP comment?**
   PHP's tokenizer ends PHP mode at that exact point, regardless of comment context — everything after it is treated as raw output text, not executed code. This was verified directly in this lesson: a `//` comment describing the closing tag itself contained `?>` and broke the file, printing the remainder of the source as literal text instead of running it. The fix is to never write the literal closing-tag sequence anywhere in PHP source unless intentionally ending PHP mode there.

2. **What's the difference between single-quoted and double-quoted strings in PHP?**
   Double-quoted strings interpolate variables (`"Hello, {$name}"` embeds the variable's value) and process escape sequences like `\n`/`\t`. Single-quoted strings treat their content almost entirely literally — `$name` stays as the literal text `$name`, and only `\\` and `\'` are recognized as escapes. Single quotes are marginally faster since PHP skips interpolation scanning, making them the idiomatic default for strings without variables or escapes.

## Recommended Next Lesson

[03 — Variables and Data Types](../03-Variables-and-Data-Types/README.md)
