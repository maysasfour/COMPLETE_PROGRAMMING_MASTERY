# 03 — Linked Lists

[Back to module overview](../README.md) | [Previous: Arrays and Strings](../02-Arrays-and-Strings/README.md)

## Beginner: What a Linked List Is

A **linked list** stores elements as a chain of separate objects (**nodes**), where each node holds a value and a reference (pointer) to the next node. Unlike an array (Lesson 02), the nodes are **not** stored in contiguous memory — they can live anywhere, and the only way to get from one to the next is by following the `.next` reference.

```
head -> [10 | *] -> [20 | *] -> [30 | None]
```

Each box is a `Node`. The `*` represents a pointer to the next box; `None` marks the end of the chain. `implementation.py` builds this with two classes: `Node` (one link) and `LinkedList` (the chain, tracked via a `head` reference to the first node).

## Beginner: Why Not Just Use an Array?

Because the two structures are good at opposite things:

| Operation | Array (Python `list`) | Singly Linked List |
|---|---|---|
| Access by index | O(1) | O(n) — must walk from the head |
| Insert/delete at front | O(n) — shift everything | O(1) — just re-point the head |
| Insert/delete at end | O(1) amortized | O(n) — must walk to find the last node (unless a tail pointer is kept) |
| Search by value | O(n) | O(n) |
| Extra memory per element | none | one pointer per node |

The headline trade-off: **arrays are fast to read by position, linked lists are fast to insert/delete at the front.** Neither structure is universally "better" — you pick based on which operations your program actually does most.

## Intermediate: Walking Through `append`, `prepend`, `delete`, `search`

- **`prepend` is O(1)**: create a new node, point its `.next` at the current head, make it the new head. No existing nodes are touched or shifted — this is the direct payoff of not needing contiguous memory.
- **`append` is O(n)** *in this implementation*, because `LinkedList` here doesn't keep a separate `tail` pointer — it must walk the entire chain to find the last node before attaching the new one. (A production implementation would often maintain a `tail` reference to make `append` O(1) too — see Common Mistakes below for why that's a deliberate simplification here, not an oversight.)
- **`delete` is O(n)**: even if you know the value to delete, you must walk the list to find it, and — because a singly linked list has no backward pointers — you must track the *previous* node as you go, so that once you find the target you can re-link `previous.next` to skip over it.
- **`search` is O(n)**: no shortcut exists without an index; must check nodes one at a time.

## Advanced: Reversing a Linked List In Place

`reverse()` is the classic linked-list interview exercise because it forces you to reason precisely about pointers. The trick: you cannot just flip `.next` on a node without first saving where it used to point, or you'll lose the rest of the chain. The loop keeps three references — `previous`, `current`, and a temporary `next_node` — and advances all three together:

```
Before: previous=None,  current=[10]->[20]->[30]->None

Step 1: next_node = current.next   # save [20]->[30]->None before we overwrite it
        current.next = previous    # [10] now points to None
        previous = current         # previous = [10]->None
        current = next_node        # current = [20]->[30]->None

Step 2: next_node = [30]->None
        current.next = previous    # [20] now points to [10]->None
        previous = [20]->[10]->None
        current = [30]->None

Step 3: next_node = None
        current.next = previous    # [30] now points to [20]->[10]->None
        previous = [30]->[20]->[10]->None
        current = None  -> loop ends

self.head = previous  # -> [30]->[20]->[10]->None
```

This is O(n) time (one pass) and **O(1) extra space** — no new list or array is allocated; only the existing nodes' `.next` pointers are rewired, and three local variables track position. This space efficiency is the entire reason this technique is worth learning over "build a new reversed list."

## How to Run

```bash
cd 08-Data-Structures-and-Algorithms/03-Linked-Lists
python implementation.py
```

## Verified Output

```
New list. Empty? True, contents: []

--- append(10), append(20), append(30) ---
Contents: [10, 20, 30], length: 3

--- prepend(5) ---
Contents: [5, 10, 20, 30]

--- search(20), search(99) ---
search(20) -> True
search(99) -> False

--- delete(20) ---
delete(20) returned True, contents now: [5, 10, 30]

--- delete(999) [not present] ---
delete(999) returned False, contents unchanged: [5, 10, 30]

--- delete(5) [the head] ---
delete(5) returned True, contents now: [10, 30]

--- reverse() ---
Before reverse: [10, 30, 40, 50]
After reverse:  [50, 40, 30, 10]
```

## Summary

- A linked list is a chain of nodes, each holding a value and a pointer to the next node — no contiguous memory required.
- Front insertion (`prepend`) is O(1); this implementation's `append` and `delete` and `search` are all O(n) because they require walking the chain.
- Reversal is done in place by rewiring `.next` pointers with three tracked references, in O(n) time and O(1) extra space.
- Linked lists trade away O(1) indexed access (which arrays have) for O(1) front insertion/deletion (which arrays don't).

## Key Terms

- **Node** — a single element of a linked list: a value plus a reference to the next node.
- **Head** — the reference to the first node in the list; the entry point for every operation.
- **Tail** — the last node in the list (`.next is None`); optionally tracked separately to speed up `append`.
- **Singly linked list** — each node points only forward (to `.next`); there is no way to go backward.
- **Doubly linked list** (not implemented here) — each node points both forward and backward, trading extra memory per node for O(1) backward traversal and O(1) deletion given a direct node reference.
- **Traversal** — visiting each node in sequence by following `.next` pointers.

## Common Mistakes

- Losing the rest of the chain by overwriting a node's `.next` before saving a reference to what it used to point to — this is exactly why `reverse()` saves `next_node` before reassigning `current.next`.
- Forgetting to handle deleting the head node as a special case — there is no "previous" node to re-link when the target is the first node, so the head pointer itself must move instead.
- Assuming `append` is O(1) by analogy with Python's `list.append()` — in a bare singly linked list without a tracked tail pointer, it's O(n), which is a real and common interview follow-up question ("how would you make this O(1)?" — answer: maintain a `self.tail` reference and update it on every append/prepend/delete-of-tail).
- Trying to index into a linked list like an array (`my_list[2]`) — there is no O(1) indexed access; reaching the 3rd node always means walking from the head.

## Interview Questions

1. **Why is inserting at the front of a linked list O(1), but inserting at the front of a Python list is O(n)?**
   A linked list's `prepend` only needs to create one new node and update one pointer (the head) — no existing data moves. A Python list is contiguous in memory, so inserting at position 0 requires physically shifting every existing element one slot over to make room, which is O(n).

2. **What is the trade-off between an array and a singly linked list?**
   Arrays give O(1) indexed access but O(n) insertion/deletion at the front. Linked lists give O(1) insertion/deletion at the front but O(n) indexed access (and O(n) search), since reaching any position requires walking from the head one node at a time.

3. **Walk through how you'd reverse a singly linked list in place, and state its time/space complexity.**
   Keep three references — `previous` (starts `None`), `current` (starts at head), and a temporary `next_node`. On each step, save `current.next` into `next_node` before overwriting it, then set `current.next = previous`, then advance `previous = current` and `current = next_node`. After the loop, `previous` is the new head. O(n) time (one pass over all nodes), O(1) extra space (only three pointers used, regardless of list length).

4. **Why must `delete` track the "previous" node while searching for the target in a singly linked list?**
   Because a singly linked list only has forward pointers — once you're standing on the node to delete, you have no way to reach back to the node before it. You must remember that previous node *as you walk forward*, so that when you find the target you can re-link `previous.next` to skip over it and complete the removal.

5. **How would you make `append` O(1) instead of O(n) in this implementation?**
   Maintain a `self.tail` reference to the last node, updated whenever a node is added at the end (and also updated/cleared appropriately on deletion of the last node or prepending to an empty list). Then `append` just attaches the new node to `self.tail.next` and moves `self.tail` forward, with no need to walk the whole list first.

## Suggested Next Lesson

[04 — Stacks and Queues](../04-Stacks-and-Queues/README.md)
