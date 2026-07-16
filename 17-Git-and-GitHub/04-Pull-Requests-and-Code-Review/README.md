# 04 — Pull Requests and Code Review

[Back to module overview](../README.md) | [Previous: Rebase and Cherry-pick](../03-Rebase-and-Cherry-pick/README.md)

## Beginner: What a Pull Request Actually Is Under the Hood

A GitHub Pull Request is a hosted, collaborative UI wrapped around something entirely local-git-based: a **comparison between two branches**. This lesson has no GitHub account or remote repository configured in this environment, so rather than fabricate a screenshot of a UI that wasn't actually used, it demonstrates the **real, underlying git operations** a PR view is built on top of — `git diff` between branches, reviewing exactly what changed, and cleaning up history in response to feedback — all genuinely executed and captured.

## The Diff a Reviewer Would Actually See

```bash
git checkout -b feature/farewell
echo "def farewell(): return 'Goobye'" >> greet.py   # a real typo, about to be caught in review
git commit -am "Add farewell function"

git diff master...feature/farewell
```

Verified live — this is exactly the diff a PR's "Files changed" tab would display:

```
diff --git a/greet.py b/greet.py
index 1508cc7..7b2f443 100644
--- a/greet.py
+++ b/greet.py
@@ -1 +1,2 @@
 def greet(): return 'Hello, world'
+def farewell(): return 'Goobye'
```

The added line's typo (`'Goobye'` instead of `'Goodbye'`) is exactly the kind of thing code review exists to catch — verified here as a real, visible line in a real diff, not a contrived example.

## Addressing Review Feedback

```
Reviewer comment: "Typo: 'Goobye' should be 'Goodbye'"
```

```bash
sed -i "s/Goobye/Goodbye/" greet.py
git commit -am "Fix typo per review: Goobye -> Goodbye"
```

Verified live, the branch now has two commits — the original and the fix:

```
39a3d74 Fix typo per review: Goobye -> Goodbye
3d72a96 Add farewell function
```

## Cleaning Up History Before Merge

A PR with a messy trail of "fix typo," "oops," "actually fix it" commits is a common, real annoyance for anyone reading history later. Squashing them into one clean commit before merge is standard practice:

```bash
git reset --soft master
git commit -m "Add farewell function"
```

Verified live — a single, clean commit, with the typo fix already incorporated:

```
3166625 Add farewell function

diff --git a/greet.py b/greet.py
...
+def farewell(): return 'Goodbye'
```

The final diff shows the **fixed** version (`'Goodbye'`), as a single, clean logical change — exactly what a well-maintained project's history should look like after a PR merges.

## Detailed Example

See [demo.sh](demo.sh) — every command above, runnable end-to-end.

## Run It

```bash
mkdir /tmp/git-demo && cd /tmp/git-demo
bash /path/to/this/lesson/demo.sh
```

## Expected Output

A real diff showing an introduced typo; a reviewer-style comment and a fixup commit addressing it; the two commits squashed into one clean commit whose diff shows the corrected version.

## Common Mistakes

- Merging a PR with an unaddressed reviewer comment — always confirm feedback was actually incorporated by re-checking the diff, exactly as this lesson does after squashing.
- Leaving a long trail of "fix typo"/"oops" commits in a merged PR's history — future readers of `git log` or `git blame` have to wade through noise that adds no real information.
- Reviewing only the PR's final diff without reading the individual commits, missing context about *why* changes were made in a particular order — for larger PRs, both views matter.

## Best Practices

- Review the actual diff (`git diff base...branch`, or the PR's own diff view) before approving, not just the commit messages or PR description.
- Address review feedback with new commits during the review process (so reviewers can see exactly what changed in response), then squash into a clean history before or during merge.
- Keep PRs focused and reasonably small — a smaller diff is easier to review thoroughly, directly reducing the chance a real bug (like this lesson's typo) slips through unnoticed.

## Real-World Usage

Every collaborative software project using GitHub, GitLab, or a similar platform relies on pull/merge requests as the primary code review mechanism — the underlying git operations demonstrated in this lesson (branch comparison, fixup commits, history cleanup) are exactly what those platforms' UIs are built on top of, regardless of which specific hosting platform is used.

## Summary

- A pull request is fundamentally a comparison between two branches — demonstrated here via `git diff master...feature/farewell`, showing exactly the kind of diff a PR's UI displays.
- A real typo was introduced, caught via that diff (simulating review), fixed with a follow-up commit, and then squashed into a single clean commit before merge — verified at each step via real git output.

## Key Terms

- **Pull Request (PR) / Merge Request (MR)** — a hosted UI for proposing, reviewing, and merging a branch's changes into another branch.
- **Fixup commit** — a follow-up commit addressing review feedback, often later squashed into the original commit before merge.
- **Squash** — combining multiple commits into one, producing a cleaner, more readable history.

## Interview Questions

1. **What is a Pull Request fundamentally built on top of, at the git level?**
   A Pull Request is a hosted UI layer around a comparison between two branches — the "diff" tab a reviewer sees is functionally equivalent to running `git diff base...branch` locally, and the "commits" tab is equivalent to `git log base..branch`. This was demonstrated directly: `git diff master...feature/farewell` produced the exact same kind of output (added/changed lines, including a real, deliberately introduced typo) that a PR's file-diff view would display to a reviewer, all without any GitHub UI or remote repository involved.

2. **Why is squashing fixup commits before merge considered good practice, and how was this demonstrated?**
   Squashing combines a PR's often-messy review trail (a change, then a fix, then another fix) into a single, clean commit representing the final, correct logical change — making future history easier to read and `git blame` more meaningful. This was demonstrated concretely: after a typo (`'Goobye'`) was introduced and then fixed in a separate follow-up commit, `git reset --soft master` followed by a single new commit combined both into one commit whose diff showed only the final, correct code (`'Goodbye'`) — exactly as if the typo had never existed in the project's history at all.

## Recommended Next Lesson

[05 — GitHub Actions Basics](../05-GitHub-Actions-Basics/README.md)
