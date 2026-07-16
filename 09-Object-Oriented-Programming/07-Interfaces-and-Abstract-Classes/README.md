# 07 — Interfaces and Abstract Classes

[Back to module overview](../README.md) | [Previous: Composition vs. Inheritance](../06-Composition-vs-Inheritance/README.md)

## Beginner: Three Ways to Define "What an Object Must Support"

Lessons 03 and 05 introduced `abc.ABC`, `typing.Protocol`, and duck typing separately. This lesson puts them side by side, because choosing between them is a real, recurring design decision.

| Approach | Requires inheritance? | Enforced when? | Shares code? |
|---|---|---|---|
| **Duck typing** (no formal type) | No | Never — fails at the call site if the method is missing | No |
| **`typing.Protocol`** | No | By static type checkers (mypy/pyright); at runtime only with `@runtime_checkable`, and only checks names exist | No |
| **`abc.ABC`** | Yes | At instantiation — missing methods raise `TypeError` immediately | Yes — can provide shared method implementations too |

## Beginner: Duck Typing — No Formal Contract at All

```python
class FileLogger:
    def log(self, msg): print(f"[file] {msg}")

class ConsoleLogger:
    def log(self, msg): print(f"[console] {msg}")

def run_task(logger):
    logger.log("starting task")   # works for anything with a .log() method

run_task(FileLogger())
run_task(ConsoleLogger())
```

Fastest to write, zero ceremony — and zero safety net. If you pass an object without `.log()`, you find out only when that line executes, potentially deep inside a long-running task.

## Intermediate: `Protocol` — a Structural Contract, Checked Statically

```python
from typing import Protocol

class Logger(Protocol):
    def log(self, msg: str) -> None: ...

def run_task(logger: Logger) -> None:
    logger.log("starting task")
```

`FileLogger` and `ConsoleLogger` from above satisfy `Logger` **without changing a single line of them** — no inheritance needed. A type checker (mypy/pyright) will flag `run_task(object())` as an error *before* the program ever runs, which duck typing alone cannot do. This is the sweet spot for "I want an enforced contract, but my types are already defined elsewhere / I can't or don't want to change their inheritance."

## Advanced: `ABC` — a Nominal Contract, Enforced at Runtime, With Shared Code

```python
from abc import ABC, abstractmethod

class Logger(ABC):
    @abstractmethod
    def log(self, msg: str) -> None: ...

    def log_error(self, msg: str) -> None:
        # ABCs CAN provide real, shared implementations alongside
        # abstract requirements - Protocol cannot do this.
        self.log(f"ERROR: {msg}")

class ConsoleLogger(Logger):
    def log(self, msg: str) -> None:
        print(f"[console] {msg}")
```

`ConsoleLogger` now inherits `log_error` for free — every subclass gets consistent error-formatting behavior without reimplementing it. This is the key differentiator from `Protocol`: an `ABC` can be a **partial implementation**, not just a shape description. The cost is that `ConsoleLogger` must explicitly inherit from `Logger`, and forgetting `log` raises `TypeError` at instantiation, not at first use.

## When Each Fits

- **Duck typing**: small scripts, quick prototypes, or when the "contract" is a single obvious method and the codebase is small enough that a typo would be caught immediately in testing.
- **`Protocol`**: you want a statically-checked contract but the implementing classes are third-party, already have their own hierarchy, or you specifically want to avoid forcing inheritance (e.g., defining what a "cache-like object" looks like without caring if it's a dict, a Redis client, or a custom class).
- **`ABC`**: you own the whole class hierarchy, you want a hard runtime guarantee that a required method exists (not just a static-analysis warning), and/or you want to share real implementation code (like `log_error` above) across every implementer.

## Real-World Usage

- Python's `collections.abc` module defines ABCs like `Iterable`, `Sized`, and `Mapping` that the standard library itself uses to check "does this object support the container protocol" — `isinstance(x, collections.abc.Iterable)` works because those built-in types are registered with the ABC.
- Type-checked codebases commonly define `Protocol`s for things like "anything with a `.close()` method" to describe resource cleanup requirements without forcing every resource type into one inheritance tree.
- Plugin systems frequently use `ABC` for the plugin base class specifically because they want the hard guarantee: a plugin missing a required hook should fail loudly at load time, not silently at first use deep in production.

## Summary

- Duck typing: zero ceremony, zero enforcement — fails only when the missing method is actually called.
- `Protocol`: structural, checked by static type checkers (and optionally at runtime via `@runtime_checkable`), requires no inheritance.
- `ABC`: nominal (requires inheritance), enforced at instantiation time, and can bundle real shared implementation alongside abstract requirements.
- Choose based on who owns the classes, whether you need a hard runtime guarantee, and whether you need to share actual code across implementers.

## Key Terms

- **Nominal typing** — a type is only compatible if it explicitly declares that relationship (e.g., via inheritance), as `ABC` requires.
- **Structural typing** — a type is compatible if it has the right shape (methods/attributes), regardless of declared ancestry, as `Protocol` and duck typing use.
- **`@runtime_checkable`** — decorator that allows `isinstance()` checks against a `Protocol`, checking only that named methods/attributes exist.
- **Partial implementation** — an `ABC` providing some concrete methods (like `log_error`) alongside abstract ones subclasses must still supply.

## Common Mistakes

- Reaching for `ABC` by default even when the implementing classes are outside your control (third-party) — `Protocol` fits that situation and `ABC` simply cannot be retrofitted onto classes you don't own.
- Assuming `Protocol` gives the same hard runtime guarantee as `ABC` — without `@runtime_checkable` it gives none at runtime at all, and even with it, only presence of names is checked, not full type correctness.
- Using `ABC` purely as a shape description when duck typing or `Protocol` would do, adding a mandatory inheritance relationship for no real benefit.
- Forgetting that `ABC` can share real code (not just declare abstract requirements) — reimplementing common logic in every subclass instead of putting it once in the ABC.

## Interview Questions

1. **Compare duck typing, `Protocol`, and `ABC` along two axes: when the contract is enforced, and whether inheritance is required.**
   Duck typing: no formal contract, fails at the call site if a method is missing. `Protocol`: structural, checked by static tools (and optionally `isinstance` with `@runtime_checkable`), no inheritance required. `ABC`: nominal, enforced at instantiation time via `TypeError`, requires explicit inheritance.

2. **Can an `ABC` provide real, shared method implementations, and can `Protocol` do the same?**
   Yes for `ABC` — it can mix concrete methods with abstract ones, and subclasses inherit the concrete ones for free. `Protocol` cannot provide shared implementation to be inherited in the same way; it's purely a shape description (default method bodies in a `Protocol` are rarely used and don't work like ABC inheritance).

3. **When would you choose `Protocol` over `ABC`?**
   When you don't own the implementing classes (third-party types), or want to avoid forcing an inheritance relationship, but still want a name for "the shape of thing this function expects," ideally checked by a type checker.

4. **What does `@runtime_checkable` do, and what are its limits?**
   It allows `isinstance(obj, SomeProtocol)` to work at runtime. Its limitation: it only verifies the named methods/attributes exist, not that their signatures or behavior actually match the protocol.

5. **Why might a plugin system specifically prefer `ABC` over `Protocol` or duck typing?**
   Because `ABC` enforces the contract at instantiation time — a plugin that's missing a required method fails immediately and loudly when loaded, rather than failing much later (or silently) the first time that specific method happens to be called.

## Suggested Next Lesson

[08 — Generics and Static Members](../08-Generics-and-Static-Members/README.md)
