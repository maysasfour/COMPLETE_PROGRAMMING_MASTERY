# 06 — Functions

[Back to course overview](../README.md) | [Previous: Control Flow](../05-Control-Flow/README.md)

## Learning Objectives

- Write `static` methods and understand there are no free-standing functions in Java.
- Use method overloading and varargs.
- Understand Java has no default parameters and how overloading substitutes for them.

## Prerequisites

[05-Control-Flow](../05-Control-Flow/README.md)

## Concept

Every "function" in Java is a **method** — declared inside a class, with `static` methods callable without an instance (`ClassName.methodName(...)`) and instance methods requiring an object (Lesson 11). Java has **no default parameter values** at all (unlike Python/JavaScript/TypeScript/C#) — the idiomatic substitute is **method overloading**: multiple methods with the same name but different parameter lists.

## Static Methods and Overloading

```java
static int add(int a, int b) {
    return a + b;
}

static String greet() {
    return greet("World"); // overload calling another overload
}
static String greet(String name) {
    return "Hello, " + name;
}
```

Overload resolution is based on the number and types of arguments at the call site, resolved entirely at **compile time** — unlike dynamic dispatch for instance methods (Lesson 11), which is resolved at runtime based on the object's actual type.

## Varargs

```java
static int sum(int... numbers) { // varargs -- called with any number of int arguments
    int total = 0;
    for (int n : numbers) total += n;
    return total;
}

sum(1, 2, 3, 4); // called with any number of arguments
sum();            // also valid -- an empty array
```

`int... numbers` is Java's varargs syntax (directly analogous to C#'s `params` and JavaScript's rest parameters) — inside the method, `numbers` is an ordinary array.

## Detailed Example

See [Example.java](Example.java).

## Expected Output

Running `java Example.java` prints overloaded `greet()` calls (simulating a default parameter via overloading) and a varargs sum.

## Common Mistakes

- Expecting Java to support default parameter values directly — it doesn't; overloading (or a builder pattern for many optional parameters) is the idiomatic substitute.
- Writing ambiguous overloads that the compiler can't disambiguate at a given call site (e.g., overloads differing only in a way that's ambiguous given autoboxing) — a compile error, not a runtime ambiguity.

## Best Practices

- Use overloading to simulate optional/default parameters, keeping the "simpler" overloads delegate to the "fuller" one (as `greet()` calling `greet("World")` above) to avoid duplicating logic.
- Use varargs for genuinely variable-arity methods (like a `sum`); avoid it for methods where a `List<T>` parameter would be clearer.

## Real-World Usage

Overloading-as-default-parameters is pervasive throughout the JDK itself (`String.split(regex)` and `String.split(regex, limit)` are overloads of each other); varargs underlies methods like `String.format(fmt, args...)` and `List.of(items...)`.

## Summary

- Every Java "function" is a method inside a class; `static` methods don't need an instance.
- Java has no default parameter values; overloading is the idiomatic substitute.
- Varargs (`Type... name`) allow a variable number of arguments, exposed as an array inside the method.

## Key Terms

- **Method overloading** — multiple methods sharing a name but differing in parameter list, resolved at compile time.
- **Varargs (`...`)** — a parameter accepting a variable number of arguments, exposed as an array.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **How does Java simulate default parameter values, given it has no native support for them?**
   Through method overloading: a simpler overload with fewer parameters calls the fuller overload, supplying the "default" value itself — e.g., `greet()` internally calling `greet("World")`. This keeps the actual logic in one place while giving callers the convenience of omitting arguments for common cases.

2. **Is Java method overload resolution static or dynamic?**
   Static (compile-time) — the compiler determines which overload to call based on the declared/compile-time types of the arguments at each call site. This is different from overriding (Lesson 11), which is resolved dynamically at runtime based on the object's actual runtime type.

## Recommended Next Lesson

[07 — Collections](../07-Collections/README.md)
