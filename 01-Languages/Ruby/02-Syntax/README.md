# 02 — Syntax

[Back to course overview](../README.md) | [Previous: Setup](../01-Setup/README.md)

## Learning Objectives

- Write Ruby without semicolons, using newlines as statement terminators.
- Close blocks with `end` rather than braces.
- Understand that `if`/`case`/`begin` are expressions with a value, not just control-flow statements.

## Prerequisites

[01-Setup](../01-Setup/README.md)

## Concept

Ruby statements end at a newline; semicolons are legal but optional, used mainly to fit two statements on one line (`a = 1; b = 2`). Blocks — `if`, `def`, `class`, `while`, `case` — are closed with the keyword `end`, not `{ }` (a visible, immediate difference from every C-family language in this repository).

The deeper distinctive feature is that **everything is an expression**. `if`/`case`/`begin` all evaluate to a value — the last expression evaluated in whichever branch actually ran — so they can be assigned directly to a variable or returned from a method, not just used for their side effects.

## Detailed Example

See [example.rb](example.rb) — semicolons, `end`-delimited blocks, `if`/`case` used as expressions assigned to a variable, a method's implicit last-expression return value, postfix `if`/`unless` modifiers, and proof that even a bare integer literal and an assignment expression both have a real `.class`.

## Run It

```bash
cd 01-Languages/Ruby/02-Syntax
ruby example.rb
```

## Expected Output (real, captured)

```
3
HELLO!
a is smaller
B
7
positive
Integer
Integer
```

## Common Mistakes

- Adding semicolons out of C/Java/JavaScript habit — harmless, but unidiomatic; Ruby style omits them.
- Forgetting `end` for every opened block — a missing `end` produces a real `SyntaxError` (often reported several lines later than the actual mistake, since the parser doesn't know where you intended to close it).
- Writing `return` in every method out of habit — legal, but the implicit last-expression-is-the-return-value convention is idiomatic Ruby and used throughout the rest of this course.

## Best Practices

- Prefer the implicit final-expression return value for simple methods; reserve explicit `return` for genuine early exits.
- Use `if`/`case` as expressions (assigning their result directly) instead of declaring a variable above and mutating it inside each branch.
- Use postfix `if`/`unless` for short, single-line conditionals; use the full block form once a body needs more than one line.

## Real-World Usage

Rails controllers and view templates lean heavily on `if`/`case`-as-expression and implicit returns to keep code terse; postfix conditionals are idiomatic throughout the Ruby standard library's own source.

## Summary

- No semicolons required; `end` replaces `{ }` for blocks.
- `if`/`case`/`begin` are expressions with a value — assignable, returnable.
- A method's last evaluated expression is its return value.

## Key Terms

- **Expression** — code that evaluates to a value; in Ruby, this includes control-flow constructs most other languages treat as pure statements.
- **Postfix modifier** — `expr if condition` / `expr unless condition`, a one-line conditional form.

## Interview Questions

1. **Why does `if` being an "expression" matter in practice?**
   It means the result of a conditional can be assigned directly (`status = if cond then x else y end`) instead of declaring a mutable variable above the conditional and reassigning it in each branch — less mutable state, and the compiler/interpreter (and reader) can see every branch produces a value of the same intended shape.

2. **What ends a Ruby block if not a closing brace?**
   The `end` keyword, used for `if`, `def`, `class`, `module`, `while`, `case`, `begin`, and other block-opening constructs — a deliberate, visible syntactic difference from C-family languages.

## Recommended Next Lesson

[03 — Variables and Data Types](../03-Variables-and-Data-Types/README.md)
