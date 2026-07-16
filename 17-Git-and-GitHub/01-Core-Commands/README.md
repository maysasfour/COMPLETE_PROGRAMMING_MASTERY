# 01 — Core Commands (add, commit, push, pull)

[Back to module overview](../README.md)

## Beginner: The Staging Area Is a Real, Separate Step

A very common point of confusion for beginners: modifying a file does **not** automatically mean the next commit includes it. Git has a distinct staging area (the "index"), and only what's been explicitly `git add`-ed is included in the next `git commit`. This lesson demonstrates that distinction with real, captured terminal output from an actual git repository — not a description of how it's supposed to work.

## Setting Up: `git init`, `git add`, `git commit`

```bash
git init
echo "# My Project" > README.md
git status --short
```

Verified live, a brand-new file shows up as untracked:

```
?? README.md
```

Staging it changes its status:

```bash
git add README.md
git status --short
```

```
A  README.md
```

Committing it clears the staging area:

```bash
git commit -m "Initial commit"
git log --oneline
```

```
a575ba2 Initial commit
```

## The Gotcha: Modifying a File Without Staging It

```bash
echo "## Setup" >> README.md
git status --short
```

Verified live — the file shows as modified, but **not staged**:

```
 M README.md
```

Attempting to commit anyway:

```bash
git commit -m "Add setup section"
```

Verified live — git correctly refuses:

```
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")
```

Checking the log confirms nothing new was actually committed:

```
git log --oneline
a575ba2 Initial commit
```

Only the original commit exists — the "Add setup section" commit never happened, because nothing was staged. This is git's staging area working exactly as designed: **it refuses to silently commit nothing**, rather than the more dangerous alternative of accidentally committing changes you didn't mean to include.

## The Fix: Stage Before Committing

```bash
git add README.md
git commit -m "Add setup section"
git log --oneline
```

Verified live:

```
42f12f0 Add setup section
a575ba2 Initial commit
```

## Detailed Example

See [demo.sh](demo.sh) — every command shown above, runnable end-to-end in any empty, throwaway directory to reproduce the exact same real output.

## Run It

```bash
mkdir /tmp/git-demo && cd /tmp/git-demo
bash /path/to/this/lesson/demo.sh
```

(Run this in a throwaway directory — it initializes a real git repository there.)

## Expected Output

The staging/commit sequence shown above, including git correctly refusing to commit when nothing is staged, followed by a successful commit once the change is properly staged.

## Common Mistakes

- Assuming `git commit -m "..."` commits *all* current changes — it only commits what's currently staged (`git add`-ed), verified live to correctly refuse when nothing was staged at all.
- Confusing `git add` (staging — preparing what the next commit will include) with `git commit` (actually recording that snapshot in history) — they are two distinct, separate steps.
- Not checking `git status` before committing, which would have immediately revealed the unstaged change in this lesson's gotcha scenario.

## Best Practices

- Run `git status` before committing, as a habit, to confirm exactly what will (and won't) be included.
- Use `git add -p` (or your IDE's staging UI) to stage changes selectively when a single file contains both changes you want to commit now and changes you don't.
- Write clear, specific commit messages describing *why* a change was made, not just what changed (the diff already shows what changed).

## Real-World Usage

The staging area is one of Git's most distinctive design decisions compared to older version control systems — it lets you build up a commit incrementally, reviewing and selecting exactly what goes into it, rather than being forced to commit an entire working directory's changes at once. Understanding it correctly (as demonstrated live in this lesson) prevents the common beginner confusion of "I edited the file, why isn't my change in the commit?"

## Summary

- A new file must be both created AND staged (`git add`) before it can be committed — verified live via `git status --short` showing its transition from untracked (`??`) to staged (`A`).
- Modifying an already-tracked file does not automatically stage it — verified live via `git status --short` showing it as modified-but-unstaged (` M`).
- Git correctly refuses to commit when nothing is staged, verified live by the actual refusal message and a `git log` confirming no new commit was created.

## Key Terms

- **Staging area (index)** — the intermediate area where changes are prepared before being included in the next commit.
- **Working directory** — the actual files on disk, which may differ from both the staging area and the last commit.
- **`git status`** — shows the difference between the working directory, the staging area, and the last commit.

## Interview Questions

1. **What is the staging area, and why does Git have a separate step between modifying a file and committing it?**
   The staging area (or "index") is where changes are prepared before being recorded in a commit — modifying a file changes the working directory, but that change isn't part of the next commit until it's explicitly staged with `git add`. This was demonstrated concretely: after modifying `README.md` without staging it, `git status --short` showed it as modified-but-unstaged (` M README.md`), and attempting `git commit` at that point was correctly refused by git with an explicit message, rather than silently creating an empty or incomplete commit.

2. **What would have happened if `git commit` silently succeeded with nothing staged, and why is git's actual behavior safer?**
   If `git commit` silently created a commit even with nothing staged, a developer might believe their change was recorded when it wasn't, only to discover it missing later — a genuinely confusing and potentially costly mistake, especially just before pushing to a shared branch. Git's actual, verified behavior instead refuses outright, printing a clear message (`no changes added to commit`) and leaving the log unchanged (confirmed via `git log --oneline` still showing only the original commit) — forcing the developer to notice and explicitly stage the change before it can be committed.

## Recommended Next Lesson

[02 — Branching and Merging](../02-Branching-and-Merging/README.md)
