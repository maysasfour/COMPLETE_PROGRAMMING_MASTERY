# 04 — Stacks and Queues

[Back to module overview](../README.md) | [Previous: Linked Lists](../03-Linked-Lists/README.md)

## Beginner: Two Disciplines for "What Comes Out Next"

A **stack** and a **queue** both hold a collection of items and both restrict *how* you can add and remove them — but they enforce opposite orderings:

- **Stack — LIFO (Last In, First Out).** The most recently added item is the first one removed. Think of a stack of plates: you take from the top, the same place you added to.
- **Queue — FIFO (First In, First Out).** The item that's been waiting longest is the first one removed. Think of a checkout line: whoever joined first gets served first.

```
Stack (LIFO):           Queue (FIFO):
   push 3 -> [3]            enqueue "a" -> [a]
   push 2 -> [3,2]          enqueue "b" -> [a,b]
   pop()   -> 2 (top)       dequeue()   -> a (front)
   [3] remains              [b] remains
```

## Beginner: Implementation Choices in Python

| Structure | Backed by | Why |
|---|---|---|
| `Stack` | `list` | Push/pop both happen at the **end** of the list, which is Python list's O(1) amortized side (Lesson 02) — the wrong end would make every operation O(n). |
| `Queue` | `collections.deque` | Enqueue adds to the back, dequeue removes from the **front**. A plain `list` would make front-removal O(n) (Lesson 02's `pop(0)` problem) — `deque` is specifically implemented so both ends are O(1), which is the entire reason to use it here instead of `list`. |

This is a direct, concrete callback to Lesson 02's array complexity table and Lesson 03's "wrong end of a linked list is expensive" lesson — picking the right underlying structure for the access pattern you actually need is the through-line of this whole module.

## Intermediate: Balanced Parentheses (Stack Use Case)

Checking whether brackets like `(`, `[`, `{` are correctly matched and nested is the textbook stack problem, because nesting is inherently LIFO: the most recently opened bracket must be the next one closed. `is_balanced()` in `implementation.py` pushes every opening bracket it sees, and for every closing bracket, pops the stack and checks that what comes off matches. Two distinct failure modes both correctly return `False`:

- A closing bracket with **nothing on the stack** to match (more closers than openers so far) — e.g. `")"` alone.
- A closing bracket that **doesn't match the top of the stack** — e.g. `"([)]"`, where `)` appears while `[` is on top.

And a third check happens **after** the loop: if the stack still has unpopped openers at the end, something was never closed (`"((("`).

## Intermediate: Task Queue Simulation (Queue Use Case)

`simulate_task_queue()` models the shape of a print spooler, a web server's request queue, or a background job processor: work arrives over time, and must be handled in the order it arrived. A `Queue` enforces this *by construction* — there is no operation that lets you skip ahead, unlike a list where you could (incorrectly) grab an arbitrary index. The verified output shows `processed_order == incoming_tasks`, confirming FIFO ordering was preserved end to end.

## Advanced: Why Not Just Use a List for the Queue?

You technically *can* build a queue on a plain `list` (`.append()` to enqueue, `.pop(0)` to dequeue), and many beginner tutorials do. But `.pop(0)` is O(n) (Lesson 02), so every single dequeue operation on a list-backed queue costs O(n), making a full run of `n` enqueue/dequeue pairs cost O(n^2) overall. `collections.deque` avoids this because it's implemented internally as a doubly linked list of fixed-size blocks, giving true O(1) operations at both ends — this is precisely why the Python standard library documentation itself recommends `deque` over `list` for queue-like use.

## How to Run

```bash
cd 08-Data-Structures-and-Algorithms/04-Stacks-and-Queues
python implementation.py
```

## Verified Output

```
=== Stack: push/pop/peek ===
After pushing 1, 2, 3: peek() -> 3, size -> 3
pop() -> 3
pop() -> 2
size after two pops -> 1

=== Queue: enqueue/dequeue/peek ===
After enqueuing a, b, c: peek() -> a, size -> 3
dequeue() -> a
dequeue() -> b
size after two dequeues -> 1

=== Balanced parentheses checker (stack use case) ===
is_balanced('(a + b) * (c - d)') -> True
is_balanced('([{}])') -> True
is_balanced('([)]') -> False
is_balanced('(((') -> False
is_balanced('') -> True
is_balanced('no brackets here') -> True

=== Task queue simulation (queue use case) ===
Tasks arrive in order: ['send-email', 'resize-image', 'generate-report', 'backup-database']
Tasks processed in order: ['send-email', 'resize-image', 'generate-report', 'backup-database']
FIFO confirmed: processed order == arrival order -> True
```

## Complexity Table

| Operation | Stack (list-backed) | Queue (deque-backed) |
|---|---|---|
| Add (`push` / `enqueue`) | O(1) amortized | O(1) |
| Remove (`pop` / `dequeue`) | O(1) | O(1) |
| Peek | O(1) | O(1) |
| Search by value | O(n) | O(n) |

## Summary

- A stack is LIFO — last in, first out; a queue is FIFO — first in, first out.
- Python's `list` is a good Stack backing because push/pop both use its efficient end; it's a *bad* Queue backing because front-removal is O(n).
- `collections.deque` gives O(1) operations at both ends, making it the correct choice for a Queue.
- Balanced-bracket checking is the canonical stack problem: nesting is inherently LIFO.
- FIFO task processing is the canonical queue problem: work must be handled in arrival order.

## Key Terms

- **Stack** — LIFO structure; `push` adds, `pop` removes the most recently added item.
- **Queue** — FIFO structure; `enqueue` adds, `dequeue` removes the least recently added item.
- **LIFO** — Last In, First Out.
- **FIFO** — First In, First Out.
- **`collections.deque`** — Python's double-ended queue, offering O(1) addition/removal at both ends.
- **Peek** — viewing the next item to be removed without actually removing it.

## Common Mistakes

- Using a plain `list` with `.pop(0)` to implement a queue — it works correctly but is O(n) per dequeue, making it a real performance bug at scale, not just a style nitpick.
- Confusing which end of the stack `peek()` should look at — it's always the top (most recently pushed), matching what `pop()` would remove.
- In the balanced-parentheses checker, forgetting the final "is the stack empty?" check — without it, unclosed openers like `"((("` would incorrectly report as balanced, since the loop never sees a mismatched closer.
- Assuming `is_balanced` needs to special-case an empty string — it doesn't; an empty loop body naturally leaves the stack empty, correctly returning `True`.

## Interview Questions

1. **What's the difference between a stack and a queue, and give a real-world example of each.**
   A stack is LIFO (last in, first out) — like a stack of plates, or the undo history in a text editor (the most recent action is undone first). A queue is FIFO (first in, first out) — like a checkout line, or a print job spooler (jobs print in the order they were submitted).

2. **Why is `collections.deque` preferred over a plain `list` for implementing a queue?**
   Removing from the front of a Python `list` (`pop(0)`) is O(n) because every remaining element must shift left. `deque` is internally structured (a doubly linked list of blocks) to support O(1) addition and removal at both ends, so `popleft()` stays O(1) regardless of queue size — critical for any queue that's dequeued from repeatedly.

3. **Why is a stack the natural data structure for checking balanced parentheses?**
   Bracket nesting is inherently a "most recent first" relationship — whatever bracket was opened last must be the next one closed for the nesting to be valid. A stack directly models that relationship: pushing an opener and popping to check the most recent unmatched opener against each closer is a one-to-one match for how nesting actually works.

4. **How would you implement a stack using two queues, or a queue using two stacks?** *(A common follow-up interview question.)*
   A queue from two stacks: push new items onto an "in" stack; to dequeue, if the "out" stack is empty, pop everything off "in" and push it onto "out" (this reverses the order), then pop from "out". This gives amortized O(1) dequeue because each item is moved between stacks at most once over its lifetime. A stack from two queues is the mirror-image idea, generally less efficient (typically O(n) push or pop depending on which operation you optimize for), since queues don't have a "top" to exploit the way stacks do.

5. **What happens if you call `pop()` on an empty stack or `dequeue()` on an empty queue, and why does `implementation.py` raise an exception instead of returning `None`?**
   Both raise `IndexError` with a descriptive message. Returning `None` would be ambiguous — it would be indistinguishable from a stack/queue that legitimately contains `None` as a stored value — whereas raising an explicit exception makes the "there's nothing here" case impossible to silently misinterpret as valid data, matching the "fail fast" principle from `00-Programming-Fundamentals/06-Error-Handling`.

## Suggested Next Lesson

[05 — Hash Tables](../05-Hash-Tables/README.md)
