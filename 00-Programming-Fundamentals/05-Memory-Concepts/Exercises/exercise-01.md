# Exercise 01 — Predict the Caller's View

[Back to lesson](../README.md)

## Task

For each function below, predict whether calling it changes what the *caller's* variable shows afterward, and explain why using the stack/heap and mutable/immutable vocabulary from the lesson.

```python
def a(data):
    data["status"] = "updated"

record = {"status": "new"}
a(record)
print(record)   # predict this
```

```python
def b(data):
    data = {"status": "updated"}

record = {"status": "new"}
b(record)
print(record)   # predict this
```

```python
def c(data):
    data += [4]

values = [1, 2, 3]
c(values)
print(values)   # predict this
```

```python
def d(data):
    data.extend([4])

values = [1, 2, 3]
d(values)
print(values)   # predict this
```

## Trap Warning

Part C is intentionally tricky: `+=` on a list looks like it should mutate in place (and often does!), but pay close attention to what `data += [4]` actually does to the *name* `data` versus what `.extend()` in Part D does to the *object*. Research (or test) the difference between `list.__iadd__` (in-place) and rebinding before answering — this is a genuinely subtle real-world gotcha.

## Deliverable

Written predictions with reasoning for all four, submitted before checking `Solutions/solution-01.py`.
