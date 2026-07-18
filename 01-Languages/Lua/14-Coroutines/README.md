# 14 - Coroutines

## What / Why

Coroutines are Lua's genuinely distinctive concurrency primitive — **cooperative**,
single-threaded, with control passed explicitly via `yield`/`resume`, never preemptively.
There is no OS-thread story here at all (contrast Ruby's `Thread` + GVL, discussed in
Ruby's Lesson 14) — only one coroutine ever executes at a time, and it runs until it
explicitly yields or finishes. Comparable to, but simpler than, Kotlin's coroutines,
PHP's Fibers, and Python's generators: no scheduler, no `async`/`await` sugar — just
three plain functions, `coroutine.create`/`resume`/`yield`.

## Run It

```bash
cd 01-Languages/Lua/14-Coroutines
lua example.lua
```

Real captured output:

```
suspended
coroutine started with	3	4
true	7
suspended
resumed with x =	100
true	200
resumed again with y =	999
true	done, y was 999
dead
false	cannot resume dead coroutine
[producer] making item-1
[consumer] received item-1
[producer] making item-2
[consumer] received item-2
[producer] making item-3
[consumer] received item-3
[producer] making item-4
[consumer] received item-4
[producer] making item-5
[consumer] received item-5
[consumer] producer finished
squares via coroutine.wrap iterator: 1 4 9 16 25
```

## Common Beginner Mistakes

- Expecting `coroutine.resume` on a coroutine that already finished ("dead") to work — it returns `false, "cannot resume dead coroutine"` instead, verified live above.
- Confusing `coroutine.create` (returns a coroutine object; errors surface as `false, err` from `resume`) with `coroutine.wrap` (returns a plain callable function; errors propagate as real Lua errors instead) — mixing up which error-handling behavior you're relying on is a real, easy mistake.
- Assuming coroutines give real parallelism — they don't; it's cooperative multitasking on a single OS thread, useful for structuring code (generators, producer/consumer pipelines) but not for CPU-bound speedup.

## Best Practices

- Use `coroutine.wrap` when you want a coroutine to behave like a plain iterator function (usable directly in a generic `for`), and `coroutine.create` when you need to inspect status (`coroutine.status`) or handle errors as explicit return values.
- Always check `coroutine.status` before resuming in long-lived producer/consumer loops, to detect a "dead" coroutine and stop cleanly (as done in the live producer/consumer demo above).

## Interview Questions

1. **How do Lua coroutines differ from OS threads?** They're cooperative, not preemptive — only one coroutine runs at any moment, and it explicitly yields control back via `coroutine.yield`; there's no parallel execution, no shared-memory race conditions to worry about, and no scheduler making preemption decisions.
2. **What's the difference between `coroutine.create` and `coroutine.wrap`?** `create` returns a coroutine object that must be driven with `coroutine.resume` (returning `ok, result` pairs, so errors are just data); `wrap` returns a plain function that, when called, resumes the coroutine directly and re-raises any internal error as a genuine Lua error instead of a boolean/message pair.
