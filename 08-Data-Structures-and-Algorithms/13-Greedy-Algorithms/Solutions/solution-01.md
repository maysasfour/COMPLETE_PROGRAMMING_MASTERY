# Solution 01 — Minimum Number of Meeting Rooms

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output:

```
2 (expected 2)
1 (expected 1)
0 (expected 0)
4 (expected 4 -- all four overlap simultaneously at time 4)
1 (expected 1 -- back-to-back, never overlapping)
```

## Explanation

Meetings are processed in start-time order. A min-heap tracks the end time of every room currently occupied. For each meeting: if the room that frees up *soonest* (the heap's minimum) already ended at or before this meeting's start time, that room is reused (popped, then the current meeting's end time is pushed in its place); otherwise, a genuinely new room is needed (the current meeting's end time is just pushed, growing the heap). The final heap size is exactly the number of rooms simultaneously in use at the point of maximum overlap — which is the minimum number of rooms the whole schedule requires.

## Reflection Answers

1. **Why start time here, but end time for `activity_selection`.** `activity_selection` is asking "how many activities can I fit using a single room, picking which ones to *reject*?" — sorting by end time greedily preserves the most remaining room for whatever comes after, which is what makes taking the earliest-finishing option correct. This problem asks a completely different question: "given that *every* meeting must happen, how many rooms does that require?" There's no rejection at all — every meeting must be scheduled — so the relevant order is when meetings *begin* competing for rooms, which is start time.

2. **Why the heap's minimum (not any other room) is the correct reuse check.** If the room ending *soonest* still hasn't ended by the time the current meeting starts, then *no* room has ended yet either (every other room's end time is >= the soonest one, by definition of it being the minimum) — meaning a genuinely new room is required. Conversely, if the soonest-ending room's end time is already <= the current meeting's start, it's always safe (and never worse) to reuse specifically that one, since it's the one that's been free the longest and reusing it can never block a *future* meeting that a different, later-ending room wouldn't have blocked too.

3. **Is this "pure" greedy, or does it need more than `activity_selection` did?** It's still fundamentally greedy — at each meeting, the locally best decision (reuse the soonest-freeing room if possible) is made without reconsidering earlier decisions. But it needs genuinely more state than `activity_selection`'s single `last_end` variable: because *multiple* rooms can be in use simultaneously, the algorithm needs to track *all* currently-occupied rooms' end times at once, and always efficiently find/remove the smallest one — exactly the job a min-heap (from [Lesson 10](../../10-Heaps-and-Priority-Queues/README.md)) is built for. This is a good example of how "greedy" describes the *decision strategy* (always take the locally best option), not the *data structure* needed to make that decision efficiently — a more complex problem can still be greedy while needing a richer supporting structure than a single variable.

## Common Pitfalls

- Sorting by end time instead of start time here — that's the right choice for `activity_selection`'s single-room rejection problem, but wrong for this multi-room allocation problem, which needs to know when meetings *begin* competing for rooms.
- Checking `end_times.peek() < start` instead of `<= start` — a meeting ending at exactly the same time another begins should be allowed to reuse that room (back-to-back scheduling with no gap is not an overlap), verified directly by the `[(1,2),(2,3),(3,4)]` test case above correctly returning `1`, not `3`.
- Returning the number of meetings pushed in total, rather than the heap's *final* size — the final size specifically represents the maximum number of rooms simultaneously in use at any point, which is the actual answer; the total meeting count would just be the input length, telling you nothing about overlap.
