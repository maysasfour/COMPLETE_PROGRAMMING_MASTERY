# 02 — Variables and Types

[Back to module overview](../README.md) | [Previous: How Computers Run Programs](../01-How-Computers-Run-Programs/README.md)

## Beginner: What a Variable Actually Is

A variable is **a name bound to a value** — not a labeled box that physically contains the value. This distinction seems pedantic until you hit mutable objects (Lesson 05 covers the memory model in depth), so it's worth internalizing now.

```python
age = 25        # the name "age" is bound to the integer object 25
age = 26        # "age" is now bound to a different integer object; 25 still exists until nothing references it
```

A **constant** is a value that's not meant to change after it's set. Python has no enforced constant keyword — by convention, `ALL_CAPS` names signal "treat this as constant," but nothing stops reassignment. Some languages (JavaScript's `const`, Java's `final`) enforce this at the language level.

```python
MAX_RETRIES = 3   # convention: this should not be reassigned
```

## Beginner: Primitive vs. Reference Types

- **Primitive (value) types** — simple, immutable values: integers, floats, booleans, and (in Python) strings. When you assign one variable to another, you get an independent copy of the value.
- **Reference types** — objects like lists, dictionaries, and custom class instances. A variable holding one of these holds a *reference* to the object, not the object itself. Assigning one variable to another copies the reference, so both names point to the *same* object.

```python
a = [1, 2, 3]
b = a          # b now refers to the SAME list object as a
b.append(4)
print(a)       # [1, 2, 3, 4] - changing b changed what a sees too
```

Python technically treats *everything* as an object (even integers), but ints/floats/bools/strings are immutable, so they behave like value types in practice — you can never observe a mutation "through" a second reference, because they can't be mutated at all. See Lesson 05 for the full stack/heap picture.

## Intermediate: Static vs. Dynamic Typing

- **Statically typed** languages (C, Java, Rust, TypeScript) check that variable types are consistent *before* the program runs (at compile time). A variable's type is fixed once declared.
- **Dynamically typed** languages (Python, JavaScript, Ruby) check types *while the program runs*. A variable name can be rebound to a value of a completely different type.

```python
value = 42        # value is bound to an int
value = "hello"   # perfectly legal in Python - value is now bound to a str
```

Python is dynamically typed but supports optional **type hints** for readability and tooling (not enforced at runtime by the interpreter itself):

```python
def greet(name: str) -> str:
    return f"Hello, {name}"
```

## Intermediate: Strong vs. Weak Typing

This is a different axis from static/dynamic, and the two get conflated constantly:

- **Strongly typed**: the language does not silently convert between unrelated types. Python is strongly typed — `"3" + 3` raises a `TypeError`.
- **Weakly typed**: the language performs implicit conversions between unrelated types. JavaScript is weakly typed — `"3" + 3` produces `"33"` (the number is silently converted to a string).

So Python is **dynamically but strongly typed**: types aren't checked until runtime, but the language never silently coerces incompatible types for you.

## Advanced: Casting (Type Conversion)

**Casting** (or type conversion) is explicitly converting a value from one type to another.

```python
age_text = "25"
age_number = int(age_text)     # explicit cast: str -> int
pi_text = str(3.14159)          # explicit cast: float -> str
```

- **Implicit conversion** happens automatically, without you asking — Python does this rarely and predictably (e.g., `3 + 3.0` implicitly promotes the int to a float, giving `6.0`, because no information is lost).
- **Explicit conversion (casting)** is when you call a conversion function yourself (`int()`, `str()`, `float()`, `bool()`). Prefer explicit casts whenever the conversion could fail or lose information — it documents intent and lets you handle failure (see Lesson 06 on exceptions).

```python
int("25")     # 25 - works
int("25.5")   # raises ValueError - int() can't parse a decimal point directly
int(float("25.5"))  # 25 - two explicit steps, information (the .5) is deliberately discarded
```

## Real-World Usage

- API responses arrive as strings/JSON; you constantly cast incoming text to numbers, booleans, and dates, and must handle the case where casting fails (malformed input).
- Static typing (or Python type hints + a checker like `mypy`) catches an entire class of bugs before code ships — this is why large Python codebases increasingly adopt type hints despite Python being dynamically typed.
- Reference-type aliasing bugs (two names pointing at the same mutable list) are one of the most common real-world sources of "why did this data change when I didn't touch it" bugs.

## Summary

- A variable is a name bound to a value, not a container holding it directly.
- Primitive/value types copy on assignment; reference types share the same underlying object on assignment.
- Static typing checks types before running; dynamic typing checks while running. Python is dynamic.
- Strong typing forbids silent conversions between unrelated types; weak typing allows them. Python is strong.
- Casting is explicit type conversion; prefer it over relying on implicit conversion, and always consider that it can fail.

## Key Terms

- **Variable** — a name bound to a value.
- **Constant** — a value intended to never be reassigned after initialization.
- **Primitive/value type** — simple immutable data (int, float, bool, str in Python) copied on assignment.
- **Reference type** — an object (list, dict, custom class) whose variables hold a reference; assignment shares the object.
- **Static typing** — type checking performed before runtime (compile time).
- **Dynamic typing** — type checking performed during runtime.
- **Strong typing** — no silent conversion between unrelated types.
- **Weak typing** — silent/implicit conversion between unrelated types is allowed.
- **Casting** — explicitly converting a value from one type to another.

## Common Mistakes

- Assuming `b = a` copies a list — it only copies the reference; use `b = a.copy()` or `b = list(a)` for an independent copy.
- Confusing "dynamically typed" with "weakly typed" — Python is dynamic but strong; JavaScript is dynamic and weak. These are separate axes.
- Letting `int()`/`float()` raise unhandled `ValueError`s on malformed input instead of validating or catching the exception.
- Using mutable default arguments (a reference-type pitfall covered fully in Lesson 04).

## Interview Questions

1. **What is the difference between a variable and the value it refers to?**
   The variable is a name; the value is a separate object in memory. Assignment binds the name to the object — it does not copy the object (for reference types) or duplicate storage in the way a "labeled box" mental model implies.

2. **What's the difference between static and dynamic typing? Where does Python fall?**
   Static typing checks types before the program runs; dynamic typing checks as the program runs. Python is dynamically typed — a name can be rebound to a value of any type at any time, and type errors only surface when the offending line actually executes.

3. **What's the difference between strong and weak typing, and why is this a different question from static/dynamic?**
   Strong typing disallows silent conversion between unrelated types (Python: `"3" + 3` errors). Weak typing allows it (JavaScript: `"3" + 3` becomes `"33"`). It's independent of static/dynamic — Python is dynamic+strong, C is static+weak-ish (permits many implicit numeric conversions and unsafe casts), TypeScript is static+strong.

4. **Why does `b = a` for two lists mean changes through `b` are visible through `a`?**
   Because lists are reference types — `a` and `b` both hold a reference to the same underlying list object after that assignment. There is only one list; two names point at it. Mutating through either name mutates the one shared object.

5. **When would you prefer explicit casting over relying on implicit conversion?**
   Whenever the conversion could lose information or fail (string-to-number, float-to-int). Explicit casting documents the intent at the call site and lets you wrap it in error handling; relying on implicit conversion hides the risk and, in strongly-typed Python, usually just isn't available anyway.

## Suggested Next Lesson

[03 — Control Flow](../03-Control-Flow/README.md)
