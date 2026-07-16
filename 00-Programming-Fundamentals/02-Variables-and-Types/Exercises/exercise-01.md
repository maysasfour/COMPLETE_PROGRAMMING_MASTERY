# Exercise 01 — Predict Before You Run

[Back to lesson](../README.md)

## Task

For each snippet below, write down what you *predict* will be printed, and why, **before** running any code. Then run it (create a scratch `.py` file) and check yourself.

```python
# Part 1
x = [1, 2]
y = x
x.append(3)
print(y)
```

```python
# Part 2
def make_list():
    return [1, 2]

x = make_list()
y = make_list()
x.append(3)
print(y)
```

```python
# Part 3
count = "5"
total = count + 1
print(total)
```

```python
# Part 4
count = "5"
total = int(count) + 1
print(total)
```

## Reflection Questions

1. In Part 1 vs Part 2, both start with a two-item list — why does mutating `x` affect `y` in one case but not the other?
2. Part 3 fails. Name the specific typing property of Python responsible for that failure (not just "it's an error" — name the concept from the lesson).
3. Rewrite Part 3 so it works using **two different** valid approaches (there is more than one correct way to combine a string number and an int).

## Deliverable

Your four predictions with reasoning, plus answers to the three reflection questions. Do not peek at `Solutions/solution-01.md` until you've written down your predictions.
