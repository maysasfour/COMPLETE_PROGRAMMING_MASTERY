# Exercise 01 — Predict Before You Run

[Back to lesson](../README.md)

## Task

For each snippet below, write down what you *predict* will be printed, and why, **before** running any code. Then run it (create a scratch `.py` file) and check yourself.

```python
# Part 1
def register(name, roles=[]):
    roles.append(name)
    return roles

print(register("alice"))
print(register("bob"))
```

```python
# Part 2
def register_fixed(name, roles=None):
    if roles is None:
        roles = []
    roles.append(name)
    return roles

print(register_fixed("alice"))
print(register_fixed("bob"))
```

```python
# Part 3
def build_report(title, *sections, **metadata):
    return {"title": title, "sections": sections, "metadata": metadata}

print(build_report("Q1 Report", "intro", "summary", author="Ada", pages=5))
```

```python
# Part 4
def noisy_save(data):
    print(f"saving {data}")

outcome = noisy_save("config.json")
print(f"outcome is {outcome!r}")
```

## Reflection Questions

1. In Part 1 vs Part 2, both calls start out looking like they should each get an independent one-item list — why doesn't Part 1 behave that way, and what specifically about `def`'s execution model causes it?
2. In Part 3, explain exactly why `"intro"` and `"summary"` end up in `sections` as a tuple while `author` and `pages` end up in `metadata` as a dict — what determines which bucket an argument falls into?
3. In Part 4, `noisy_save` clearly "does something" (it prints). Why is `outcome` still `None`? What would you have to add to `noisy_save` to make `outcome` hold something meaningful?

## Deliverable

Your four predictions with reasoning, plus answers to the three reflection questions. Do not peek at `Solutions/solution-01.md` until you've written down your predictions.
