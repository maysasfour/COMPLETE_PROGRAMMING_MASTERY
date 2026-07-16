# 02 — Syntax

[Back to course overview](../README.md) | [Previous: Setup](../01-Setup/README.md)

## Learning Objectives

- Understand that every top-level construct in Java is a class (or interface/enum/record).
- Write single-line, multi-line, and Javadoc comments.
- Understand mandatory semicolons and curly-brace blocks.

## Prerequisites

[01-Setup](../01-Setup/README.md)

## Concept

Unlike every other language in this repository so far, Java has **no top-level statements and no free-standing functions at all** — literally everything (including a program's entry point) must be a member of a class, interface, enum, or record. This is a much stricter form of "everything is class-based" than C#'s optional top-level statements.

## Syntax

```java
public class Example {
    // single-line comment
    /* multi-line
       comment */

    /**
     * Javadoc comment -- picked up by IDEs and the `javadoc` documentation generator.
     * @param name the name to greet
     * @return a greeting string
     */
    static String greet(String name) {
        return "Hello, " + name;
    }

    public static void main(String[] args) {
        int x = 5;              // statement
        int y = x + 1;            // `x + 1` is an expression
        System.out.println(y);    // statement containing a method-call expression
        System.out.println(greet("Ada"));
    }
}
```

## Detailed Example

See [Example.java](Example.java).

## Expected Output

Running `java Example.java` prints a computed value and a Javadoc-documented method's result.

## Common Mistakes

- Trying to write a statement outside any class (as JavaScript/Python/C#/Go all allow) — Java has no such concept; everything must be inside a class member.
- Forgetting semicolons — required for every statement, no exceptions.

## Best Practices

- Use Javadoc (`/** ... */`) comments on public methods/classes — IDEs surface them as tooltips, and the `javadoc` tool generates browsable API documentation from them.
- Follow `PascalCase` for classes, `camelCase` for methods/variables — a strong, nearly universal Java convention.

## Real-World Usage

Javadoc comments are the source for nearly all published Java library documentation (the official JDK API docs themselves are generated this way).

## Summary

- Java has no top-level statements or free functions — everything is a class/interface/enum/record member.
- Semicolons are mandatory; blocks use `{ }`.
- Javadoc (`/** ... */`) comments feed IDE tooltips and the `javadoc` documentation generator.

## Key Terms

- **Javadoc** — Java's structured documentation-comment format and the tool that generates HTML documentation from it.

## Interview Questions

1. **Can Java have a function that isn't part of any class?**
   No — every piece of executable code, including `main`, must be a member (usually `static`, for utility-style methods) of some class, interface, enum, or record. This is stricter than most other languages, which typically allow at least some form of top-level/free function.

2. **What is Javadoc?**
   A structured comment format (`/** ... */` with tags like `@param`/`@return`) that IDEs parse for tooltips and that the `javadoc` command-line tool uses to generate browsable HTML API documentation directly from source comments.

## Recommended Next Lesson

[03 — Variables and Data Types](../03-Variables-and-Data-Types/README.md)
