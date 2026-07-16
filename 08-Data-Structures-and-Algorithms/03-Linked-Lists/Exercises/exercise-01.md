# Exercise 01 — Find the Middle Node

[Back to lesson](../README.md)

## Task

Using the `LinkedList` class from `implementation.py`, write a function `find_middle(linked_list)` that returns the **value** of the middle node in one pass, without first computing `len(linked_list)`.

```python
# For [10, 20, 30, 40, 50] -> middle is 30
# For [10, 20, 30, 40]     -> middle is 30 (the second of the two middle nodes, by convention)
```

Hint: use two pointers that both start at `head`, but one ("slow") advances one node per step while the other ("fast") advances two nodes per step. When "fast" reaches the end, "slow" is at the middle — think about why that's guaranteed to work before you code it.

## Reflection Questions

1. Why does the fast pointer moving twice as fast as the slow pointer guarantee that the slow pointer lands on the middle when the fast pointer reaches the end?
2. What is the time complexity of your solution, and how does it compare to the "obvious" solution of calling `len()` first and then walking to `length // 2`?
3. What happens to your loop's stopping condition when the list has an even number of nodes versus an odd number? Trace both cases by hand for a 4-node and a 5-node list.

## Deliverable

A working `find_middle` function plus answers to the three reflection questions.
