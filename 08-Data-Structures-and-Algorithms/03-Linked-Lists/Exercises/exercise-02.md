# Exercise 02 — Detect a Cycle

[Back to lesson](../README.md)

## Task

A **cycle** in a linked list means some node's `.next` eventually points back to an earlier node instead of ending in `None` — traversing it would loop forever. Write a function `has_cycle(linked_list)` that returns `True` if the list contains a cycle, `False` otherwise, **without using extra data structures** (no sets, no lists of visited nodes) — this must run in O(1) space.

```python
has_cycle(normal_list)   # -> False (ends in None normally)
has_cycle(cyclic_list)   # -> True  (some node's .next loops back)
```

Hint: this is the same slow/fast two-pointer idea from Exercise 01 ("Floyd's cycle detection" / "tortoise and hare"). Think about what it means, geometrically, for a fast pointer to ever catch up to and equal a slow pointer if they're both moving forward through a chain that never loops.

## Reflection Questions

1. Why is it impossible for the fast and slow pointers to ever become equal (`fast is slow`) if the list has no cycle?
2. If there IS a cycle, why is it *guaranteed* that the fast pointer will eventually catch up to the slow pointer, rather than perpetually staying one step ahead forever?
3. Why can't you solve this by simply comparing node *values* instead of comparing node *objects*/*identity*? (Think about what a linked list containing duplicate values would do to a value-based check.)

## Deliverable

A working `has_cycle` function (you'll need to manually construct a small cyclic list for testing, since `LinkedList.append`/`prepend` never create one) plus answers to the three reflection questions.
