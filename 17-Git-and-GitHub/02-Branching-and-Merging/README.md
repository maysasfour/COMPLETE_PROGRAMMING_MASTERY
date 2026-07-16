# 02 — Branching and Merging

[Back to module overview](../README.md) | [Previous: Core Commands](../01-Core-Commands/README.md)

## Beginner: A Real Merge Conflict, Not a Description of One

A merge conflict happens when two branches change the **same lines** of the **same file** in different ways, and git genuinely cannot decide which version to keep automatically. This lesson creates a real conflict, shows git's actual conflict markers, and walks through resolving it — all captured from an actual git repository.

## Setting Up: Two Branches, Diverging Changes

```bash
echo "Welcome to our site!" > home.txt
git commit -am "Initial homepage text"

git checkout -b feature-greeting
echo "Welcome, valued customer!" > home.txt
git commit -am "Update greeting on feature branch"

git checkout master
echo "Welcome to our AMAZING site!" > home.txt
git commit -am "Update greeting on master"
```

Verified live, both branches now have a different version of the exact same line:

```
* 21d7f75 Update greeting on feature branch
| * 7b913d5 Update greeting on master
|/
* 16b3411 Initial homepage text
```

## The Conflict, Verified Live

```bash
git merge feature-greeting
```

```
Auto-merging home.txt
CONFLICT (content): Merge conflict in home.txt
Automatic merge failed; fix conflicts and then commit the result.
```

`git status` confirms the file is in a genuine conflicted state (`UU` = both sides modified it):

```
UU home.txt
```

And the file itself now contains git's real conflict markers:

```
<<<<<<< HEAD
Welcome to our AMAZING site!
=======
Welcome, valued customer!
>>>>>>> feature-greeting
```

Everything between `<<<<<<< HEAD` and `=======` is master's version; everything between `=======` and `>>>>>>> feature-greeting` is the incoming branch's version. Git leaves both in the file, side by side, because it genuinely cannot know which one (or what combination) is correct — that decision requires human judgment.

## Resolving the Conflict

```bash
echo "Welcome, valued customer, to our AMAZING site!" > home.txt  # manually combining both intents
git add home.txt
git commit -m "Merge feature-greeting into master, resolving conflict"
```

Verified live — the resulting history shows a real merge commit with two parents, and the file now contains the resolved content:

```
*   715df3a Merge feature-greeting into master, resolving conflict
|\
| * 21d7f75 Update greeting on feature branch
* | 7b913d5 Update greeting on master
|/
* 16b3411 Initial homepage text

Welcome, valued customer, to our AMAZING site!
```

## Detailed Example

See [demo.sh](demo.sh) — every command above, runnable end-to-end in any empty, throwaway directory to reproduce the exact same real conflict and resolution.

## Run It

```bash
mkdir /tmp/git-demo && cd /tmp/git-demo
bash /path/to/this/lesson/demo.sh
```

## Expected Output

Two diverging branches, a real merge conflict with git's actual conflict markers shown in the file, and a resolved merge commit with two parents in the resulting history.

## Common Mistakes

- Panicking when a merge conflict appears — it's git correctly recognizing it cannot safely guess which change is intended, not a sign that something is broken.
- Blindly keeping "your" side or "their" side without actually reading both — the whole point of the conflict markers is to let a human make an informed decision, which sometimes means combining both changes (as this lesson does), not just picking one.
- Forgetting to `git add` the resolved file before committing the merge — an unresolved conflict marker left in a file (forgotten `<<<<<<<`/`=======`/`>>>>>>>` lines) is a genuinely common, embarrassing real mistake if the resolved file isn't reviewed before committing.

## Best Practices

- Read both sides of a conflict carefully before resolving — understand what each branch was actually trying to accomplish.
- After resolving, review the final file content (not just the git status) to confirm no leftover conflict markers remain.
- Keep branches short-lived and merge frequently to minimize how much two branches can diverge on the same lines, reducing the size and frequency of conflicts.

## Real-World Usage

Merge conflicts are a routine, expected part of collaborative development — they're not a sign of a broken workflow, just git surfacing a decision only a human can make. Understanding conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) and how to resolve them correctly is a fundamental, daily skill for anyone working in a shared git repository.

## Summary

- Two branches modifying the same line of the same file produced a real, verified merge conflict, with git's actual conflict markers shown in the file (`UU home.txt` in `git status`).
- The conflict was resolved by manually combining both branches' intent, then staging and committing the merge — verified by a real merge commit with two parents in the resulting `git log --graph` output.

## Key Terms

- **Merge conflict** — when git cannot automatically combine changes from two branches because they modified the same lines differently.
- **Conflict markers** — the `<<<<<<<`, `=======`, `>>>>>>>` lines git inserts into a conflicted file, showing both versions side by side.
- **Merge commit** — a commit with two (or more) parent commits, created when merging branches with diverging history.

## Interview Questions

1. **Why does git sometimes fail to merge automatically, and what does it do instead?**
   Git can only merge automatically when it can unambiguously combine changes — if two branches modified the exact same lines of the same file in different ways, git has no way to know which change (or what combination) was intended, so it stops and asks a human to decide. This was demonstrated concretely: merging `feature-greeting` into `master`, where both branches had changed the same line of `home.txt` differently, produced a real `CONFLICT (content): Merge conflict in home.txt` message, and git left both versions in the file between `<<<<<<<`/`=======`/`>>>>>>>` markers rather than guessing.

2. **What does a merge commit with two parents represent, and how was this verified in this lesson?**
   A merge commit records the point where two divergent lines of history are brought back together — it has two parent commits (one from each branch) rather than the usual single parent, preserving the fact that both lines of development happened independently before being combined. This was verified concretely via `git log --oneline --graph` after resolving the conflict: the graph showed the merge commit branching to both `Update greeting on feature branch` and `Update greeting on master`, visually confirming it has two distinct parent commits, both descending from the same original `Initial homepage text` commit.

## Recommended Next Lesson

[03 — Rebase and Cherry-pick](../03-Rebase-and-Cherry-pick/README.md)
