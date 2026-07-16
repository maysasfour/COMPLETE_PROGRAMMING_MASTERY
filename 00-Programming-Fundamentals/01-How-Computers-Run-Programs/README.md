# 01 — How Computers Run Programs

[Back to module overview](../README.md)

You write text in a file. Somehow that text moves a cursor, transfers money, or renders a game at 60 frames per second. This lesson closes that gap: what actually happens between "source code" and "running behavior."

## Beginner: Source Code Is Just Text

Source code is a plain text file. The computer's processor cannot execute English-like words such as `if` or `print` — it only executes **machine code**: binary instructions specific to its CPU architecture (x86-64, ARM, etc.). Something has to translate.

There are three broad translation strategies:

| Strategy | What happens | Example languages |
|---|---|---|
| **Compiler** | Translates the *entire* source file into machine code (or another lower-level form) *before* you run it. Produces a standalone executable. | C, C++, Rust, Go |
| **Interpreter** | Reads and executes source code line by line (or instruction by instruction), *while* the program runs. No separate executable is produced. | Classic shell scripts, early BASIC |
| **Assembler** | Translates **assembly language** (a human-readable, near-1:1 mnemonic form of machine code, e.g. `MOV`, `ADD`, `JMP`) directly into machine code. Assembly is already very close to what the CPU understands — it's not a high-level language being compiled down, it's a thin text layer over raw instructions. | NASM, MASM, GNU `as` |

Python is usually described as "interpreted," but the real story is more layered — see Intermediate.

## Intermediate: Compiled, Interpreted, and Everything Between

Few modern languages are purely one or the other:

- **Python** compiles your `.py` file to an intermediate form called **bytecode** (you'll see `.pyc` files in a `__pycache__` folder) the first time it runs. The **CPython virtual machine** then interprets that bytecode. So Python is compiled *and* interpreted — just not compiled all the way down to machine code ahead of time.
- **Java** compiles to bytecode (`.class` files) that runs on the **Java Virtual Machine (JVM)**. The JVM interprets that bytecode and, for hot code paths, compiles pieces of it to machine code on the fly — this is called **Just-In-Time (JIT) compilation**.
- **C** compiles directly to native machine code for a specific OS/CPU combination. There is no runtime translation step — this is why C programs typically start faster and run with less overhead.
- **JavaScript** (in browsers) is JIT-compiled by engines like V8: interpreted first for speed-to-start, then hot functions get compiled to machine code as the engine notices they run often.

**Runtime** is the umbrella term for everything that supports your program *while it executes* but isn't your code: the interpreter/VM itself, memory management (garbage collection), the standard library's C-level implementations, exception handling machinery. When people say "the Python runtime," they mean the CPython process that is currently interpreting your bytecode and managing memory on your behalf.

### Why this distinction matters practically

- Compiled languages catch a category of errors (type mismatches, missing symbols) at **compile time**, before the program ever runs.
- Interpreted languages defer many of those checks to **runtime** — a typo in a rarely-executed branch might not surface for months, until that branch finally runs.
- This is *not* about which approach is "better." It's a trade-off between iteration speed (interpreted languages: edit and immediately re-run) and earlier error detection plus raw execution speed (compiled languages).

## Advanced: Programming Paradigms

A **paradigm** is a style of structuring a program — a set of concepts for organizing computation. Most real programs mix paradigms; understanding each helps you recognize which tool fits which problem.

### Imperative

You describe *how* to do something as an explicit sequence of steps that mutate state.

```python
total = 0
for price in [10, 20, 30]:
    total = total + price
```

This is the default mental model for beginners: "do this, then do that."

### Object-Oriented (OOP)

You model the program as objects that bundle data (**state**) with the behavior that operates on it (**methods**), and organize related objects into **classes**.

```python
class ShoppingCart:
    def __init__(self):
        self.items = []

    def add(self, price):
        self.items.append(price)

    def total(self):
        return sum(self.items)
```

OOP is imperative under the hood (methods still run step-by-step) but adds structure: encapsulation (hide internal details), inheritance (share behavior between related classes), and polymorphism (different classes respond to the same method call in their own way).

### Functional

You describe *what* the result should be by composing pure functions — functions whose output depends only on their input, with no side effects (no mutating external state).

```python
from functools import reduce
total = reduce(lambda acc, price: acc + price, [10, 20, 30], 0)
```

Functional style favors immutability and composition over step-by-step mutation. Python supports functional techniques (`map`, `filter`, `reduce`, lambdas) but isn't a purely functional language the way Haskell is.

### Declarative

You describe the *desired outcome*, not the steps to get there — a specialized engine figures out the "how."

```sql
SELECT SUM(price) FROM cart_items;
```

SQL, regular expressions, and HTML are declarative: you never write a loop, yet a loop happens somewhere underneath.

### Why paradigms matter

You don't "pick one forever." A single Python file commonly mixes imperative loops, an OOP class or two, and a functional `map()` call. Recognizing which paradigm a piece of code is using tells you what questions to ask about it (does this mutate state? does this have side effects? is order of execution guaranteed?).

## Real-World Usage

- Reading a stack trace requires knowing whether the failure happened at compile time (syntax/type error) or runtime (a bug that only triggers under certain data).
- Choosing a language for a project often comes down to this lesson's trade-offs: Rust/C++ for performance-critical systems (compiled, no runtime GC pauses), Python/JavaScript for fast iteration and glue code (interpreted/JIT, huge ecosystem).
- Understanding paradigms helps you read unfamiliar codebases fast — spotting "this is functional-style" tells you to expect no hidden mutation.

## Summary

- Source code is translated to machine code by a **compiler** (ahead of time), interpreted by an **interpreter** (as it runs), or converted 1:1 by an **assembler** (from assembly language).
- Most real languages blend strategies: Python and Java compile to bytecode, then interpret/JIT that bytecode.
- The **runtime** is the supporting machinery (VM, garbage collector, standard library internals) present while your program executes.
- **Paradigms** — imperative, OOP, functional, declarative — are different mental models for structuring computation; most programs mix them.

## Key Terms

- **Source code** — human-written program text before translation.
- **Machine code** — binary instructions a specific CPU can execute directly.
- **Compiler** — translates source code to a lower-level form entirely before execution.
- **Interpreter** — executes source code (or bytecode) step by step during execution.
- **Assembler** — translates assembly language (near-1:1 with machine code) into machine code.
- **Bytecode** — an intermediate, platform-independent instruction format (e.g., Python's `.pyc`, Java's `.class`).
- **JIT (Just-In-Time) compilation** — compiling hot code paths to machine code *while* the program runs.
- **Runtime** — the environment/machinery supporting a program during execution.
- **Paradigm** — a style/model for structuring a program's logic (imperative, OOP, functional, declarative).

## Common Mistakes

- Thinking "interpreted" means "never compiled" — Python and Java both compile to bytecode first.
- Assuming compiled languages have no runtime — they still need memory allocators, and garbage-collected compiled languages (Go) still run a GC.
- Treating paradigms as mutually exclusive religions instead of tools — real code mixes them constantly.
- Confusing assembly language with machine code — assembly is human-readable text; machine code is the binary it assembles into.

## Interview Questions

1. **What's the difference between a compiler and an interpreter?**
   A compiler translates the entire program to a lower-level form before any of it runs, producing an artifact (executable or bytecode) that's reused on each run. An interpreter reads and executes source (or bytecode) as the program runs, with no separate build step.

2. **Is Python compiled or interpreted?**
   Both, in layers: CPython compiles `.py` source to bytecode (cached in `__pycache__`), then the CPython virtual machine interprets that bytecode. There's no ahead-of-time compilation to native machine code by default.

3. **What is a runtime, and how is it different from a compiler?**
   A compiler is a tool you run once to translate code. A runtime is the environment that's active *while your program executes* — it includes things like the interpreter/VM loop, garbage collector, and exception-handling machinery. Compiled languages still have runtimes (e.g., Go's goroutine scheduler and GC run while your compiled binary executes).

4. **Give an example of imperative vs. declarative code for the same task.**
   Imperative: loop over a list summing values by hand with a running total variable. Declarative: `SELECT SUM(x) FROM table` — you state the desired result and let the database engine decide how to compute it.

5. **Why might a language choose JIT compilation instead of pure interpretation or pure ahead-of-time compilation?**
   JIT gets the fast startup and flexibility of interpretation for code that runs once, while compiling "hot" (frequently executed) code paths to native machine code for near-compiled speed — a middle ground that adapts to actual usage patterns rather than guessing ahead of time.

## Suggested Next Lesson

[02 — Variables and Types](../02-Variables-and-Types/README.md)
