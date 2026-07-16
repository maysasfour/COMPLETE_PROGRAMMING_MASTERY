# 03 — Rebase and Cherry-pick

[Back to module overview](../README.md) | [Previous: Branching and Merging](../02-Branching-and-Merging/README.md)

## Beginner: Rebase Rewrites Commits — Verified by Real Changed Hashes

Unlike merge (Lesson 02), which combines two branches with a new merge commit that has two parents, rebase **replays** one branch's commits on top of another, one at a time — creating entirely new commits with new hashes, even though their content is the same. This lesson proves that with real, captured commit hashes before and after.

## Setting Up: A Feature Branch That's Fallen Behind

```bash
git commit -am "A: initial file"
git checkout -b feature
git commit -am "C: feature adds line2"
git commit -am "D: feature adds line3"
git checkout master
git commit -am "E: master adds other.txt"
```

Verified live, before rebasing:

```
* e1413b0 E: master adds other.txt
| * 6f8b98b D: feature adds line3
| * 3bccca7 C: feature adds line2
|/
* 453676b A: initial file
```

`feature`'s commits `C` and `D` still have hashes `3bccca7` and `6f8b98b`.

## The Rebase, Verified by Genuinely Changed Hashes

```bash
git checkout feature
git rebase master
```

Verified live, the resulting history is now **linear** (no branch point), and — critically — `C` and `D`'s hashes have **actually changed**:

```
* f7072a6 D: feature adds line3
* a144a7a C: feature adds line2
* e1413b0 E: master adds other.txt
* 453676b A: initial file
```

`C` is now `a144a7a` (was `3bccca7`); `D` is now `f7072a6` (was `6f8b98b`). This proves rebase doesn't move the *same* commits — it creates **brand-new commits** with the same content changes, applied on top of a different base. This is exactly why rebasing commits that have already been pushed and shared with others is risky: anyone else who already has the old hashes will have a diverged, conflicting view of history.

## Cherry-pick: Bringing Over One Specific Commit

```bash
git checkout -b hotfix
git commit -m "F: urgent hotfix, needed on master ASAP"
git commit -m "G: unrelated work-in-progress, NOT ready for master"
```

`hotfix` now has two commits, but only `F` should go to `master` right away — `G` isn't ready. Verified live:

```bash
git checkout master
git cherry-pick <F's hash>
```

```
master's log BEFORE cherry-pick:
  e1413b0 E: master adds other.txt
  453676b A: initial file

master's log AFTER cherry-picking ONLY commit F:
  28085e6 F: urgent hotfix, needed on master ASAP
  e1413b0 E: master adds other.txt
  453676b A: initial file

master's files (patch.txt present, wip.txt correctly absent):
  file.txt
  other.txt
  patch.txt
```

`master` received exactly the one commit it needed (`patch.txt` exists) and correctly did **not** receive `G`'s unrelated work (`wip.txt` is absent) — verified directly by listing the actual files present after the cherry-pick.

## Detailed Example

See [demo.sh](demo.sh) — every command above, runnable end-to-end to reproduce a real rebase and a real cherry-pick.

## Run It

```bash
mkdir /tmp/git-demo && cd /tmp/git-demo
bash /path/to/this/lesson/demo.sh
```

## Expected Output

A feature branch's commits with one set of hashes before rebasing, genuinely different hashes for the same content after rebasing onto an updated master; a cherry-picked commit correctly appearing on master's file list while an unrelated, later commit on the same source branch correctly does not.

## Common Mistakes

- Rebasing commits that have already been pushed and shared with others — since rebase creates new hashes, verified live in this lesson, anyone else working from the old hashes now has a diverged, conflicting history.
- Confusing cherry-pick with merge — cherry-pick brings over exactly the one commit specified (verified live: only `patch.txt`, not `wip.txt`, appeared), while merge would bring over the entire branch's history.
- Rebasing a long-lived, actively shared branch repeatedly, causing repeated hash changes and confusion for collaborators — rebase is best suited to local, not-yet-shared branches.

## Best Practices

- Use rebase to clean up your own local, not-yet-pushed commits into a linear history before sharing them — never rebase commits others have already pulled.
- Use cherry-pick for genuinely one-off situations (an urgent fix that needs to reach a release branch immediately, without the rest of an in-progress branch).
- Prefer merge for combining already-shared, published branch histories, where rewriting commit hashes would disrupt collaborators.

## Real-World Usage

Rebase is commonly used to keep a feature branch's history clean and linear before opening a pull request (squashing/reordering local commits), while cherry-pick is the standard tool for backporting a specific fix to a release branch without pulling in unrelated, in-progress work — exactly the urgent-hotfix-vs-unrelated-WIP scenario demonstrated in this lesson.

## Summary

- Rebase was verified to genuinely rewrite commits — the same content-changes received entirely new commit hashes after being replayed onto a different base, proven by comparing hashes before and after.
- Cherry-pick was verified to bring over exactly one specified commit's changes and nothing else — confirmed by the resulting file listing containing only the cherry-picked commit's file, not a later, unrelated commit's file from the same source branch.

## Key Terms

- **Rebase** — replaying one branch's commits on top of a different base commit, creating new commits with new hashes but the same content changes.
- **Cherry-pick** — applying the changes from one specific commit onto the current branch, without bringing over any other commits.
- **Linear history** — a commit history with no branch/merge points, as produced by rebasing instead of merging.

## Interview Questions

1. **How does rebase differ from merge, and how was this proven with actual commit hashes rather than just described?**
   Merge combines two branches by creating a new commit with two parents, preserving both branches' original commits unchanged. Rebase instead replays one branch's commits on top of a different base, one at a time, creating entirely new commits for the same content changes. This was proven concretely: `feature`'s commits `C` and `D` had hashes `3bccca7` and `6f8b98b` before rebasing; after `git rebase master`, the same content changes existed as brand-new commits with completely different hashes (`a144a7a` and `f7072a6`) — direct proof that rebase creates new commits rather than moving the existing ones.

2. **What does cherry-pick actually bring over, and how was this verified concretely in this lesson?**
   Cherry-pick applies only the changes introduced by one specific, named commit onto the current branch — it does not bring over any other commits from the source branch, even ones that come before or after it in that branch's history. This was verified concretely: the `hotfix` branch had two commits (`F`, an urgent fix creating `patch.txt`, and `G`, unrelated work-in-progress creating `wip.txt`); after cherry-picking only `F`'s hash onto `master`, listing `master`'s actual files showed `patch.txt` present but `wip.txt` correctly absent — direct, file-level proof that only the specified commit's changes were brought over.

## Recommended Next Lesson

[04 — Pull Requests and Code Review](../04-Pull-Requests-and-Code-Review/README.md)
