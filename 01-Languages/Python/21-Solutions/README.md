# 21 — Solutions

[Back to course overview](../README.md) | [Exercises](../20-Exercises/README.md)

Runnable solutions for every problem in [20-Exercises](../20-Exercises/README.md). Each `solution-0N.py` matches Exercise N. All seven have been executed and verified — the "Verified output" blocks below are real, not predicted.

## Solution 01 — FizzBuzz Variant

```
['1', '2', 'Fizz', '4', 'Buzz', 'Fizz', '7', '8', 'Fizz', 'Buzz', '11', 'Fizz', '13', '14', 'FizzBuzz']
```

Check `i % 15 == 0` (both 3 and 5) **before** checking `% 3` or `% 5` individually — if you checked `% 3` first, multiples of 15 would hit the `"Fizz"` branch and never reach the combined case, since `elif` short-circuits.

## Solution 02 — Word Frequency Counter

```
{'the': 2, 'cat': 2, 'sat': 1, 'ran': 1}
```

`str.maketrans("", "", string.punctuation)` builds a translation table that deletes every punctuation character; `.translate()` applies it in one pass, which is faster and clearer than chained `.replace()` calls for each punctuation mark. Lowercasing before splitting makes the count case-insensitive.

## Solution 03 — Validated Bank Account Class

```
BankAccount(owner=Ada, balance=150.00)
Deposit of -5 rejected: Deposit amount must be positive
Withdrawal blocked: Cannot withdraw 500 - balance is only 150.0
BankAccount(owner=Ada, balance=100.00)
```

The real balance lives in `self._balance`; the public `balance` is a `@property` with no setter, so `account.balance = 999` raises `AttributeError` from the outside — the only sanctioned way to change it is through `deposit`/`withdraw`, which enforce the validation rules.

## Solution 04 — Deduplicate While Preserving Order

```
Loop version:    [3, 1, 2, 4]
One-liner (dict): [3, 1, 2, 4]
Both match: True
```

`dict.fromkeys(items)` keeps only the first occurrence of each key (a dict can't have duplicate keys, and re-assigning an existing key doesn't move its position), and since Python 3.7 dict iteration order matches insertion order — so converting back to a list gives first-seen order "for free," without writing an explicit loop.

## Solution 05 — Safe Division CLI with Custom Exceptions

```
10 / 2 = 5.0
Custom error caught: Cannot divide 5 by zero
Custom error caught: Cannot divide '10' and 2 - unsupported operand type(s) for /: 'str' and 'int'
8 / 4 = 2.0
```

`raise TypeError(...) from err` chains the original `TypeError` as the new exception's `__cause__`, so a full traceback (if uncaught) still shows exactly what native error triggered the custom message — you get a clearer message without throwing away the original diagnostic detail.

## Solution 06 — Generic Stack with Type Hints

```
int stack after pushes: length 3
Popped: 3
Peeked (unchanged): 2
int stack after pop: length 2
str stack: ['a', 'b']
Popped from empty stack raised: Stack is empty
```

`Stack(Generic[T])` is a single class definition that works for any type — `Stack[int]` and `Stack[str]` are the *same* runtime class, just annotated differently for readers and type checkers (`mypy`/`pyright`). Nothing at runtime actually restricts what you push; the safety is static-analysis-only, which is the point of Lesson 13.

## Solution 07 — Mini Inventory System with SQLite

```
Items after adding three:
  {'id': 1, 'name': 'Widget', 'quantity': 10}
  {'id': 2, 'name': 'Gadget', 'quantity': 5}
  {'id': 3, 'name': 'Gizmo', 'quantity': 0}
Updated Gadget quantity to 20
Items after update:
  {'id': 1, 'name': 'Widget', 'quantity': 10}
  {'id': 2, 'name': 'Gadget', 'quantity': 20}
  {'id': 3, 'name': 'Gizmo', 'quantity': 0}
Expected error caught: No item named 'Sprocket' exists
```

`cursor.rowcount` after an `UPDATE` tells you how many rows actually matched the `WHERE` clause — zero means nothing matched, which is how `update_quantity` detects a nonexistent item without a separate `SELECT` first. All queries use `?` placeholders (parameterized queries), never string-concatenated SQL, which is what actually prevents SQL injection — the driver treats bound parameters strictly as data, never as executable SQL syntax.

## Suggested Next Lesson

[22 — Mini Projects](../22-Mini-Projects/README.md)
