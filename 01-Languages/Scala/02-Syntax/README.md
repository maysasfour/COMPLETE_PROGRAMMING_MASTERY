# 02 — Syntax

[Back to course overview](../README.md) | [Previous: Setup](../01-Setup/README.md)

## Learning Objectives

- Understand semicolon inference (statements separated by newlines, no semicolons needed).
- Understand Scala 3's significant-indentation syntax as an alternative to braces.
- Recognize that almost every Scala construct is an **expression** producing a value.

## Concept

Scala infers statement boundaries from newlines the way Python does, unlike Java/C which require explicit `;`. Scala 3 additionally introduced optional **significant indentation** ("the new syntax") as an alternative to the traditional brace-delimited style inherited from Scala 2/Java — both styles compile to identical bytecode and can even be mixed, though a single file should pick one style for readability.

## Semicolon Inference

```scala
val a = 1
val b = 2   // no semicolon needed; newline ends the statement
val c = a + b; val d = c * 2  // semicolon needed only to fit two statements on one line
```

## Braces vs. Significant Indentation (Scala 3)

```scala
// brace style (works in both Scala 2 and 3)
def classify(n: Int): String = {
  if (n > 0) "positive"
  else "non-positive"
}

// Scala 3 indentation style (no braces)
def classifyNew(n: Int): String =
  if n > 0 then "positive"
  else "non-positive"
```

## Everything Is an Expression

Unlike Java, where `if` and blocks are statements with no value, Scala's `if`/`match`/`{ }` blocks all evaluate to a value that can be assigned directly.

## Detailed Example

See [Syntax.scala](Syntax.scala) — semicolon inference, both brace and indentation styles compiled side by side, and proof that blocks are expressions.

## Run It

```bash
cd 01-Languages/Scala/02-Syntax
scalac Syntax.scala
scala run . --main-class syntaxDemo
```

## Expected Output

```
brace style: positive
indentation style: positive
block-as-expression result: 30
```

## Common Mistakes

- Mixing brace style and indentation style within the same block, producing confusing compiler errors — pick one style per file/project.
- Forgetting that a semicolon is required when placing two statements on a single line, since newline inference only separates statements across lines.
- Assuming `if` without `else` returns nothing useful — it actually returns `Unit` implicitly for the missing branch, which can silently produce `AnyVal`/`Any`-typed expressions if mixed with a branch of a different type.

## Best Practices

- Prefer Scala 3's indentation syntax for new code — it's the modern idiom and reduces visual noise.
- Keep a consistent style throughout a codebase/team rather than mixing styles file-to-file.

## Real-World Usage

Most new Scala 3 codebases and style guides (including the official Scala 3 documentation) now favor the indentation-based syntax; large existing Scala 2 codebases retain brace style, and Scala 3's compiler supports both indefinitely for migration compatibility.

## Summary

- Newlines end statements; semicolons are optional except when combining statements on one line.
- Scala 3 supports both brace-delimited and significant-indentation syntax, freely choosable.
- Nearly everything in Scala — `if`, `match`, blocks — is an expression with a value.

## Key Terms

- **Semicolon inference** — Scala's compiler-driven rule for treating a newline as an implicit statement terminator.
- **Significant indentation** — Scala 3's optional brace-free syntax, using indentation to delimit blocks.

## Interview Questions

1. **Does Scala require semicolons?** — No; a newline implicitly terminates a statement unless multiple statements share one line, in which case an explicit `;` is required to separate them.
2. **Is Scala 3's indentation-based syntax mandatory?** — No, it's fully optional; brace-delimited syntax (identical to Scala 2) still compiles and is common in existing codebases, and the two styles can even be mixed file-to-file (though not recommended within one file).

## Recommended Next Lesson

[03 — Variables and Data Types](../03-Variables-and-Data-Types/README.md)
