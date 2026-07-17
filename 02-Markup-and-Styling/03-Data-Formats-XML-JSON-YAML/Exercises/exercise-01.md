# Exercise 01 — Fix the Norway Problem

[Back to lesson](../README.md)

## Task

`catalog.yaml` (in this lesson's folder) has a genuine bug: the first book's `shipsFrom: NO` is unquoted and gets parsed as the Python boolean `False` instead of the string `"NO"` (Norway's ISO country code) — reproduced live in `implementation.py`.

Write a function `safe_load_with_string_check(path, string_fields)` that loads a YAML file and raises a clear `ValueError` if any of the given dotted field paths (e.g., `"catalog.books.0.shipsFrom"`) did *not* come back as a `str` — catching exactly this class of bug automatically instead of relying on a human to notice a silently-wrong boolean.

## Hint

You don't need a general dotted-path resolver from scratch — a small helper that splits on `.` and walks the loaded structure (treating numeric segments as list indices) is enough for this exercise's scope.

## Reflection Questions

1. Why does this bug specifically affect *unquoted* values, and why does quoting `"NO"` fix it?
2. This lesson mentions YAML 1.1 vs. YAML 1.2 — 1.2 narrowed the set of strings treated as implicit booleans specifically to fix false positives like this. Why hasn't PyYAML (the most common Python YAML library) simply switched to 1.2 by default?
3. Besides country codes, what other kinds of real-world data are at risk of silently colliding with YAML's implicit-boolean words (`yes`/`no`/`on`/`off`/`y`/`n`, in various cases)?

## Deliverable

A working `safe_load_with_string_check` function, demonstrated catching the real bug in `catalog.yaml`'s first book, plus answers to the three reflection questions.
