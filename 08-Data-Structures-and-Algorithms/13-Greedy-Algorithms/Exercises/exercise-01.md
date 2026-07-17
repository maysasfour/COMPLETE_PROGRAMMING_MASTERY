# Exercise 01 — Minimum Number of Meeting Rooms

[Back to lesson](../README.md)

## Task

Given a list of meeting `(start, end)` time intervals, write a function `min_meeting_rooms(meetings)` that returns the minimum number of rooms needed so that every meeting can happen, with no two overlapping meetings ever sharing a room.

```python
min_meeting_rooms([(0, 30), (5, 10), (15, 20)])  # -> 2
# (0,30) overlaps both (5,10) and (15,20) -- needs its own room.
# (5,10) and (15,20) don't overlap each other, so they CAN share a second room.

min_meeting_rooms([(7, 10), (2, 4)])              # -> 1  (they don't overlap at all)
```

## Hint

This is a genuine extension of this lesson's `activity_selection` idea, but instead of *rejecting* overlapping activities, you need to track how many rooms are *simultaneously* in use. Sort meetings by start time. Keep a min-heap of the end times of meetings currently occupying a room. For each new meeting (in start-time order): if the room that frees up *soonest* (the heap's minimum) already ended at or before this meeting's start, that room can be reused — pop it. Either way, push the current meeting's end time onto the heap. The final heap size is your answer (reusing [Lesson 10](../../10-Heaps-and-Priority-Queues/README.md)'s `MinHeap` is a good way to tie the two lessons together, though a plain sorted structure would also work).

## Reflection Questions

1. Why is sorting by *start* time the right choice here, when `activity_selection` earlier in this lesson specifically sorted by *end* time instead? What's different about what each problem is actually asking?
2. Walk through why popping the heap's minimum end time (rather than any other room's end time) is the correct check for whether a room can be reused.
3. Is this problem greedy, or does it actually require looking at more global information than a "pure" greedy algorithm like `activity_selection` does? (Hint: think about what data structure this needs beyond a single running variable.)

## Deliverable

A working `min_meeting_rooms` function plus answers to the three reflection questions.
