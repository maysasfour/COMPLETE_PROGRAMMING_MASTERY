# Exercise 01 — Classify the Complexity

[Back to lesson](../README.md)

## Task

For each function below, state its **time complexity** in Big O notation and give a one-sentence justification (don't just name the class — explain *why* that's the growth rate, referencing what in the code causes it).

```python
# Function A
def a(items):
    return items[0] if items else None

# Function B
def b(items):
    total = 0
    for x in items:
        total += x
    return total

# Function C
def c(items):
    total = 0
    for x in items:
        for y in items:
            total += x * y
    return total

# Function D
def d(items):
    n = len(items)
    while n > 1:
        n = n // 2
    return "done"

# Function E
def e(items):
    for x in items:
        print(x)
    for y in items:
        print(y)
    return None
```

## Reflection Questions

1. Function E has two separate loops over `items`, one after another. Is its complexity O(n), O(2n), or O(n^2)? Explain using what Big O deliberately ignores.
2. Function D never touches `items`' contents, only its length. What real algorithm from this lesson does Function D's loop structure resemble, and why?
3. Suppose Function C is run on a list of 10 items and takes 1 millisecond. Roughly how long would you predict it takes on a list of 100 items? Show the reasoning, not just the number.

## Deliverable

Complexity classification + justification for all five functions, plus answers to the three reflection questions.
