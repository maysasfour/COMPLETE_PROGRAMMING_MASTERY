# Programming Fundamentals Interview Questions

[Back to module overview](README.md)

A curated revision pass over core programming fundamentals. Where this repository has already built and verified a deeper, hands-on treatment of a topic, the answer links directly to it — these are not abstract claims but pointers to lessons where the behavior was actually compiled and run.

## 1. What actually happens when a program "runs"?

Source code is translated (compiled ahead-of-time, interpreted line-by-line, or compiled to bytecode and run on a virtual machine) into instructions the CPU can execute. The CPU fetches, decodes, and executes instructions in a loop, reading and writing memory as needed. See [00-Programming-Fundamentals/01-How-Computers-Run-Programs](../00-Programming-Fundamentals/01-How-Computers-Run-Programs/README.md).

## 2. What's the difference between compiled and interpreted languages?

A compiled language (C++, Rust, Go) is translated entirely to machine code before running, producing a standalone executable. An interpreted language (Python, JavaScript in most engines) is read and executed statement-by-statement by a runtime. Many modern languages (Java, C#) sit in between: compiled to an intermediate bytecode, then run by a virtual machine (often with JIT compilation to native code at runtime).

## 3. What's the difference between static and dynamic typing, and strong and weak typing?

Static typing checks types at compile time (Java, TypeScript, Rust); dynamic typing checks them at runtime (Python, JavaScript, Ruby). Strong typing disallows implicit, surprising type coercion (Python raises on `"1" + 1`); weak typing allows it (JavaScript's `"1" + 1` produces `"11"`). These are two independent axes — a language can be dynamically and strongly typed (Python), or dynamically and weakly typed (JavaScript).

## 4. What's the difference between value semantics and reference semantics?

With value semantics, assigning or passing a variable copies its value — mutating the copy doesn't affect the original (primitives in most languages, structs in C#/Go). With reference semantics, the variable holds a reference to the same underlying object — mutating through one reference is visible through all references to it (objects/arrays in JavaScript, Python, Java). This distinction is the source of a huge fraction of real, confusing bugs for beginners.

## 5. What's the difference between the stack and the heap?

The stack stores function call frames (local variables, return addresses) in a strict, fast, automatically-managed LIFO order — it's deallocated automatically when a function returns. The heap stores dynamically-allocated data whose lifetime isn't tied to a single function call, managed either manually (C's `malloc`/`free`), via garbage collection (Java, Python, JavaScript), or via ownership rules enforced at compile time (Rust).

## 6. What is a closure, and what problem does it solve?

A closure is a function that retains access to variables from the scope it was defined in, even after that outer scope has finished executing. This lets you create functions with "private," persistent state without needing a full class — commonly used for callbacks, event handlers, and factory functions that produce customized functions.

## 7. How does recursion work, and what's the risk of unbounded recursion?

A recursive function calls itself with a smaller/simpler version of the problem, with a base case that stops the recursion. Each call adds a new frame to the call stack; without a correct base case (or with excessively deep recursion), the stack grows unbounded and the program crashes with a stack overflow. See [08-Data-Structures-and-Algorithms/08-Recursion](../08-Data-Structures-and-Algorithms/08-Recursion/README.md) for a full, verified treatment.

## 8. What's the difference between a checked and an unchecked exception (Java specifically), or exceptions vs. error codes generally?

Checked exceptions (Java's `IOException`, etc.) must be declared or caught at compile time, forcing callers to handle a known failure mode explicitly. Unchecked exceptions (`RuntimeException` and subclasses) don't require this, typically representing programmer errors rather than expected, recoverable conditions. More broadly, exceptions separate error-handling code from the normal control-flow path, unlike error-code-based APIs (C, Go) where every call site must explicitly check a return value. See [04-Backend-Development](../04-Backend-Development/README.md) and [15-Testing-and-Debugging/05-Debugging-Techniques](../15-Testing-and-Debugging/05-Debugging-Techniques/README.md) for real, verified exception-handling and stack-trace-reading examples.

## 9. What's the difference between concurrency and parallelism?

Concurrency is structuring a program to handle multiple tasks that can be in progress at the same time (potentially interleaved on a single core); parallelism is actually executing multiple tasks simultaneously (requiring multiple cores). A program can be concurrent without being parallel (cooperative multitasking on one core) and can be made parallel across multiple cores. See [20-Computer-Science-Fundamentals/03-OS-Fundamentals](../20-Computer-Science-Fundamentals/03-OS-Fundamentals/README.md) for a real, measured demonstration of a race condition caused by genuine parallel execution across real CPU cores.

## 10. Why isn't `counter++` thread-safe, even though it looks like one operation?

It's actually three steps — read, increment, write back — and a scheduler can interleave another thread's read/write between any of them, causing lost updates. This was verified live, across multiple runs, in [20-Computer-Science-Fundamentals/03-OS-Fundamentals](../20-Computer-Science-Fundamentals/03-OS-Fundamentals/README.md): four threads each incrementing a shared counter 100,000 times reliably lost over half their intended updates without proper synchronization.

## 11. What's the difference between a module and a package (or library)?

A module is typically a single file or logical unit of code; a package (or library) is a distributable collection of one or more modules, often with its own versioning and dependency metadata (npm packages, Maven artifacts, Python packages). Dependency management tools (npm, pip, Maven, Cargo) resolve a project's required packages and their own transitive dependencies.

## 12. What's the difference between a race condition and a deadlock?

A race condition is a bug where the outcome depends on unpredictable timing/interleaving of concurrent operations (demonstrated live in [20-Computer-Science-Fundamentals/03-OS-Fundamentals](../20-Computer-Science-Fundamentals/03-OS-Fundamentals/README.md)). A deadlock is when two or more threads/processes are each waiting for a resource the other holds, and neither can proceed — a complete standstill, not just an incorrect result.

## 13. What does "pass by value" vs. "pass by reference" mean, and which does your language use?

Pass by value copies the argument's value into the function; the function operates on its own copy. Pass by reference passes a reference to the original, so mutations are visible to the caller. Most modern languages (Java, Python, JavaScript) technically pass references *by value* for objects — the reference itself is copied, but it still points to the same underlying object, which is why mutating an object's fields is visible to the caller, but reassigning the parameter to a new object is not.

## 14. Why does a `for` loop sometimes need special handling for closures capturing the loop variable?

In languages where the loop variable is a single, shared binding across iterations (older JavaScript's `var`), a closure created inside the loop captures that shared variable, not its value at the time of creation — by the time the closure runs, the loop has finished and the variable holds its final value. Block-scoped bindings (`let` in JavaScript) create a fresh binding per iteration, avoiding this trap.

## Recommended Next File

[02 — OOP Questions](02-OOP-Questions.md)
