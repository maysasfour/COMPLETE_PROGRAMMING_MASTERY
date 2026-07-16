# 05 — Memory Concepts

[Back to module overview](../README.md) | [Previous: Functions and Scope](../04-Functions-and-Scope/README.md)

## Beginner: Stack vs. Heap

A running program uses two very differently-managed regions of memory:

- **The stack** — stores function call frames: local variables, parameters, and the return address, in a strict last-in-first-out order. Every time a function is called, a new frame is pushed; when it returns, that frame is popped and everything in it is gone. Fast, automatic, but limited in size (recall Lesson 04: deep recursion without a base case eventually raises `RecursionError` because the stack runs out of frames).
- **The heap** — a larger, more flexible pool of memory for data whose size or lifetime isn't tied to a single function call. Objects you create (lists, dictionaries, class instances) live here. Slower to allocate than the stack, but not bound by function-call order.

```python
def make_point():
    x = 3          # x itself (the name binding) lives in this frame, on the stack
    y = 4           
    point = {"x": x, "y": y}   # the dict OBJECT is allocated on the heap
    return point     # the frame is popped, but the heap object survives via the returned reference

p = make_point()
```

In Python, you never manage this directly — CPython's memory manager handles heap allocation, and the stack is managed by the interpreter as it calls functions. But the mental model still explains real behavior: why deep recursion fails (stack exhaustion) and why an object can outlive the function that created it (heap objects persist as long as something references them).

## Intermediate: Value vs. Reference Semantics

This connects directly to Lesson 02's primitive-vs-reference-type material, from the memory angle:

- **Value semantics**: when you pass or assign a value-type variable, the *value itself* is what's used — for immutable types in Python, this is indistinguishable from copying, because the object can never change underneath you.
- **Reference semantics**: when you pass or assign a reference-type variable, you're handing around a *reference* (effectively, an address) to the same heap-allocated object. Multiple names can point at one object.

```python
def modify_list(lst):
    lst.append(99)     # mutates the SAME object the caller's variable references

numbers = [1, 2, 3]
modify_list(numbers)
print(numbers)          # [1, 2, 3, 99] - the caller sees the mutation
```

```python
def modify_number(n):
    n = n + 1           # rebinds the LOCAL parameter name; does not affect the caller's variable

value = 5
modify_number(value)
print(value)             # 5 - unaffected; ints are immutable, and rebinding a parameter doesn't reach back to the caller
```

Python's actual argument-passing model is often called **"pass by object reference"** (or "pass by assignment"): the reference to the object is copied into the parameter, but that's a copy of the *reference*, not the object. Whether the caller "sees" a change depends entirely on whether the function mutates the object in place (visible) or rebinds the local parameter name to a new object (not visible).

## Advanced: Mutability vs. Immutability

- **Mutable** objects can be changed in place after creation without changing their identity: `list`, `dict`, `set`, and custom class instances (by default).
- **Immutable** objects cannot be changed after creation: `int`, `float`, `bool`, `str`, `tuple` (with caveats — see below), `frozenset`.

```python
name = "Ana"
name[0] = "B"     # TypeError - strings are immutable, no in-place modification allowed
name = "Bna"       # this is fine - it REBINDS the name to a new string object, not a mutation
```

Immutability is a deliberate design tool, not just a limitation: an immutable object is inherently safe to share across functions, threads, and closures, because nothing can change it out from under any of its holders. This is a large part of *why* functional programming (Lesson 01) favors immutable data — it eliminates an entire category of aliasing bugs (like the mutable default argument pitfall from Lesson 04).

**Caveat on tuples**: a tuple itself is immutable (you can't reassign its elements or resize it), but if it contains a mutable object, that inner object can still be mutated:

```python
t = ([1, 2], "fixed")
t[0].append(3)     # legal - the list INSIDE the tuple is still mutable
print(t)             # ([1, 2, 3], 'fixed')
t[0] = [9]          # TypeError - the tuple's own slots cannot be reassigned
```

## Real-World Usage

- Understanding stack vs. heap explains stack overflow errors in deep recursion (Lesson 04) and why large objects (big lists, loaded files) are heap-allocated rather than blowing up the call stack.
- Reference semantics explain a huge class of real bugs: passing a list into a function expecting it to be read-only, only to have it silently mutated.
- Choosing immutable data structures (tuples, frozensets, immutable dataclasses) is a common defensive-programming technique in concurrent code (Lesson 08) — immutable data shared between threads can't cause race conditions from concurrent writes.

## Summary

- The stack holds function call frames (fast, automatic, size-limited); the heap holds longer-lived, size-flexible objects.
- Python passes arguments by copying the object *reference* — mutating an object through that reference is visible to the caller; rebinding the local parameter name is not.
- Mutable objects (list, dict, set) can change in place; immutable objects (int, float, str, tuple's own slots) cannot — immutability makes an object inherently safe to share.

## Key Terms

- **Stack** — memory region for function call frames, LIFO order, automatically managed.
- **Heap** — memory region for longer-lived, dynamically sized objects.
- **Stack frame** — the block of memory holding one function call's locals, parameters, and return address.
- **Value semantics** — behavior where a variable acts as an independent copy of its value.
- **Reference semantics** — behavior where a variable holds a reference to a shared object.
- **Pass by object reference** — Python's argument-passing model: the reference is copied, not the object.
- **Mutable** — can be changed in place after creation.
- **Immutable** — cannot be changed after creation; any "change" creates a new object.

## Common Mistakes

- Believing Python is strictly "pass by value" or "pass by reference" — it's neither in the traditional sense; "pass by object reference" is the accurate model, and the two traditional terms both cause wrong predictions in different cases.
- Assuming a tuple is fully immutable, then being surprised a list stored inside it can still be mutated.
- Passing a mutable object into a function without realizing the function might mutate it in place, corrupting data the caller still relies on.
- Confusing "the stack overflowed" (too much recursion, exhausted call-frame memory) with a heap/memory-leak issue — they're different memory regions with different failure modes.

## Interview Questions

1. **What's the difference between the stack and the heap?**
   The stack stores function call frames (locals, parameters, return address) in strict last-in-first-out order, is fast, and automatically cleaned up when a function returns. The heap stores objects whose size or lifetime isn't tied to one function call; it's more flexible but requires explicit or garbage-collected management.

2. **Is Python pass-by-value or pass-by-reference?**
   Neither, precisely — it's "pass by object reference" (also called pass-by-assignment). The reference to the argument object is copied into the parameter. Mutating the object through that reference is visible to the caller; reassigning the parameter to point at a new object is not, because that only rebinds the local name.

3. **Why does mutating a list inside a function affect the caller, but reassigning an int parameter doesn't?**
   Because lists are mutable — `lst.append(x)` inside the function changes the one shared heap object both the caller's and the function's names point to. Reassigning an int parameter (`n = n + 1`) doesn't mutate anything; it just points the *local* name at a brand-new int object, leaving the caller's original binding untouched.

4. **What makes immutability valuable, beyond "you can't change it"?**
   An immutable object can be freely shared across functions, closures, and threads without any risk of one holder's changes affecting another — this eliminates aliasing bugs and, in concurrent code, removes an entire class of race conditions caused by concurrent mutation.

5. **Can a tuple contain mutable data, and if so, is the tuple still "immutable"?**
   Yes — a tuple's immutability only guarantees its own slots can't be reassigned or resized. If a tuple holds a reference to a mutable object (like a list), that inner object can still be mutated in place; only the tuple's structure (which objects it references, and how many) is frozen.

## Suggested Next Lesson

[06 — Error Handling](../06-Error-Handling/README.md)
