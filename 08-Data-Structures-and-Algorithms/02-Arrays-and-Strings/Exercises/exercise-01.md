# Exercise 01 — Array Operation Complexity in Practice

[Back to lesson](../README.md)

## Task

For each code snippet, state the Big O time complexity of the **entire snippet** (not just one line), and explain why.

```python
# Snippet 1
data = list(range(1000))
first = data[0]
last = data[-1]
```

```python
# Snippet 2
data = []
for i in range(1000):
    data.append(i)
```

```python
# Snippet 3
data = []
for i in range(1000):
    data.insert(0, i)
```

```python
# Snippet 4
data = list(range(1000))
target = 999
found = target in data
```

## Reflection Questions

1. Snippets 2 and 3 both build a list of 1000 elements using a loop that runs 1000 times, but they have different overall complexity. What is each one's complexity, and why does inserting at index 0 change the answer?
2. If you needed to repeatedly insert new elements at the *front* of a growing collection, what alternative Python data structure (hint: covered in Lesson 04 of this module) would avoid Snippet 3's problem, and why?

## Deliverable

Complexity classification with justification for all four snippets, plus answers to the two reflection questions.
