# 00 — Programming Fundamentals

The concepts in this module are language-agnostic. Every code example uses Python (chosen for readability), but the concept applies to every language you'll meet later in [01-Languages](../01-Languages/).

## What This Is

The mental model of how programs actually work: how source code becomes running behavior, what a variable really is, how control flow directs execution, how functions and scope work, what happens in memory, how errors propagate, how code is organized into modules, and a first taste of concurrency.

## Why It Matters

Every language-specific course in this repository assumes you already understand these ideas. Skipping this module means you'll be memorizing syntax without understanding *why* it behaves the way it does — which falls apart the moment you hit an edge case or a new language.

## Where It's Used

Everywhere. Literally every program you will ever write touches every topic in this module.

## Advantages of Learning Fundamentals First

- Transfers instantly across languages — a closure in Python and a closure in JavaScript are the same idea with different syntax.
- Makes debugging far faster — most bugs are fundamentals problems (wrong scope, mutable default argument, unhandled exception) wearing a language-specific disguise.
- Makes interviews easier — most "trick questions" are fundamentals questions.

## Disadvantages / Trade-offs

- Feels abstract before you've written real programs — pair each lesson with real code, don't just read.
- Can be over-studied; the goal is working understanding, not academic completeness. Move on once you can explain a concept and use it correctly.

## How to Install

You need Python 3.10+ to run every example in this module.

- **Windows:** Download from [python.org](https://www.python.org/downloads/) or run `winget install Python.Python.3.12` in PowerShell.
- **macOS:** `brew install python@3.12`
- **Linux (Debian/Ubuntu):** `sudo apt install python3`

Verify with:

```bash
python --version   # or python3 --version on macOS/Linux
```

## How to Run the Examples

Each lesson folder has an `example.py`. Run it with:

```bash
python example.py
```

Expected output is documented directly in each lesson's README, right next to the code.

## Common Beginner Mistakes

- Confusing assignment (`=`) with equality comparison (`==`).
- Not understanding that a variable is a *name bound to a value*, not a box that holds the value directly (matters a lot once you reach mutable objects).
- Writing deeply nested conditionals instead of using early returns / guard clauses.
- Catching exceptions too broadly (`except:` with no type) and hiding real bugs.
- Believing floating-point numbers are exact (`0.1 + 0.2 != 0.3` in almost every language).

## Best Practices

- Name things for what they represent, not their type (`age`, not `intAge`).
- Prefer early returns over deep nesting.
- Keep functions small and single-purpose.
- Handle only the exceptions you can meaningfully recover from; let the rest propagate.
- Write code assuming the next reader has no context beyond the code itself.

## Interview Questions

1. What's the difference between a compiler and an interpreter?
2. What's the difference between the stack and the heap?
3. What is a closure, and why is it useful?
4. Why is recursion sometimes preferred over iteration, and what's the risk?
5. What's the difference between value semantics and reference semantics?

(Detailed answers are in each lesson's own README and in [21-Interview-Preparation](../21-Interview-Preparation/) once that module is built out.)

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [How Computers Run Programs](01-How-Computers-Run-Programs/README.md) | Compilers, interpreters, runtimes, paradigms |
| 02 | [Variables and Types](02-Variables-and-Types/README.md) | Variables, constants, type systems, casting |
| 03 | [Control Flow](03-Control-Flow/README.md) | Conditions, loops, expressions vs statements |
| 04 | [Functions and Scope](04-Functions-and-Scope/README.md) | Parameters, return values, scope, closures, recursion |
| 05 | [Memory Concepts](05-Memory-Concepts/README.md) | Stack, heap, value vs reference, mutability |
| 06 | [Error Handling](06-Error-Handling/README.md) | Exceptions, try/except, defensive vs fail-fast code |
| 07 | [Modules and Packages](07-Modules-and-Packages/README.md) | Organizing code, imports, dependency management |
| 08 | [Concurrency Basics](08-Concurrency-Basics/README.md) | Concurrency vs parallelism, async basics |

## Suggested Path

Work through 01 → 08 in order — later lessons assume earlier ones. Budget about 30–45 minutes per lesson including exercises.

**Next module:** [01-Languages/Python](../01-Languages/Python/README.md)
