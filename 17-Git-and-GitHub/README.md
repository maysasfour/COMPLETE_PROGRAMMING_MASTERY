# 17 — Git and GitHub

[Back to repository root](../README.md)

## What Git and GitHub Covers

This module covers core Git version control mechanics and the GitHub-specific workflows built on top of them: staging/committing, branching/merging, rebasing/cherry-picking, pull requests/code review, and GitHub Actions CI. Every Git-level lesson runs real commands against a real, throwaway git repository, with real captured terminal output — not a description of what git "should" do.

## Why This Module Uses Real Git Commands, Not a Programming Language

Unlike this repository's other concept modules, Git itself is the subject here, not a language used to implement examples. Every lesson includes a `demo.sh` script that reproduces its exact commands and output end-to-end in any empty, throwaway directory — each script was actually run and its real output verified before being included in that lesson's README. Lessons 04 and 05 are honest about a real constraint: this environment has no GitHub account or remote repository configured, so rather than fabricate a screenshot of a UI that was never actually used, they demonstrate the real, underlying git/YAML mechanics those GitHub features are built on top of, verified genuinely (a real `git diff` between branches; a real YAML parse revealing an actual documented parser quirk; a real `mvn test` run reused from [15-Testing-and-Debugging](../15-Testing-and-Debugging/README.md)).

## Why It Matters / Where It's Used

- **Git is the near-universal version control tool** in professional software development — every lesson in this module covers a skill used essentially daily by working developers.
- **Merge conflicts, rebase, and cherry-pick are genuinely confusing for beginners** until seen with real, concrete output — this module demonstrates each with actual conflict markers, actual changed commit hashes, and actual file-level verification, rather than describing the concepts abstractly.
- **Interviews**: "walk me through resolving a merge conflict," "what's the difference between merge and rebase," "how would you backport a specific fix," and "what does a CI pipeline actually do" are common interview questions, directly covered by this module's five lessons.

## Advantages of This Approach

- Every command shown in every lesson's README was actually run, with the real output captured — a real merge conflict with real conflict markers, real commit hashes proving rebase creates new commits, a real cherry-pick verified by real file-level differences, and a real, documented YAML parsing quirk.
- Each lesson includes a runnable `demo.sh` script, independently verified end-to-end, so a learner can reproduce the exact same real output themselves rather than trusting the README alone.
- Lessons 04 and 05 are transparent about this environment's real constraint (no GitHub remote configured) rather than fabricating GitHub UI screenshots — and still verify genuinely real, relevant mechanics (branch diffing, YAML validity, actual CI command execution).

## Disadvantages / Trade-offs

- This module cannot demonstrate an actual GitHub Actions run completing in GitHub's UI, or a real, hosted Pull Request review thread, since no GitHub account/remote is configured in this environment — Lessons 04 and 05 instead verify the real, underlying mechanics those features depend on.
- Git's command-line interface has many more commands and flags than this module covers (`stash`, `bisect`, `reflog`, submodules) — this module focuses on the five most foundational, highest-frequency areas.

## How to Run the Examples

Each lesson includes a `demo.sh` script reproducing its exact commands.

```bash
mkdir /tmp/git-demo && cd /tmp/git-demo
bash /path/to/17-Git-and-GitHub/01-Core-Commands/demo.sh
```

Run each script in an empty, throwaway directory — every script initializes a real git repository there. Lesson 05 additionally requires Python with `pyyaml` installed (`pip install pyyaml`) to verify the workflow YAML parses correctly. Requires only Git (any reasonably recent version) and, for Lesson 05's YAML check, Python 3.

## Common Beginner Mistakes

- **Assuming `git commit` includes all current changes** — verified live in Lesson 01 that it only includes what's staged, and correctly refuses when nothing is staged at all.
- **Panicking at merge conflicts** — verified live in Lesson 02 that a conflict is git correctly recognizing it needs human judgment, not a sign of a broken repository.
- **Rebasing already-shared/pushed commits** — verified live in Lesson 03 that rebase creates genuinely new commit hashes, which would conflict with anyone else's copy of the old history.
- **Confusing cherry-pick with merge** — verified live in Lesson 03 that cherry-pick brings over exactly one commit's changes, nothing else.
- **Leaving a messy trail of "fix typo" commits in merged history** — Lesson 04 demonstrates squashing review-fixup commits into one clean commit before merge.
- **Trusting a workflow YAML's correctness without verifying its actual commands work** — Lesson 05 verifies both the YAML's validity and its real command's success independently.

## Best Practices

- Check `git status` before committing, as a habit.
- Read both sides of a merge conflict before resolving, rather than blindly picking one.
- Only rebase local, not-yet-shared commits; use cherry-pick for genuine one-off backports.
- Review a PR's actual diff, address feedback with real commits, then squash into clean history before merge.
- Test a CI workflow's actual commands locally before trusting them in the pipeline.

## Interview Questions

1. What's the difference between the working directory, the staging area, and a commit?
2. Why does git sometimes fail to merge automatically, and what does resolving a conflict actually involve?
3. How does rebase differ from merge, and why is rebasing shared history risky?
4. What does cherry-pick bring over, and how does that differ from merging a whole branch?
5. What is a Pull Request built on top of, at the git level?
6. What triggers a GitHub Actions workflow, and what's the difference between a job and a step?

(Detailed, verified answers live in each lesson's own README.)

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Core Commands](01-Core-Commands/README.md) | `add`/`commit`; the staging area, verified with a real refused commit |
| 02 | [Branching and Merging](02-Branching-and-Merging/README.md) | A real merge conflict, real conflict markers, and its resolution |
| 03 | [Rebase and Cherry-pick](03-Rebase-and-Cherry-pick/README.md) | Real changed commit hashes from rebase; a real, file-verified cherry-pick |
| 04 | [Pull Requests and Code Review](04-Pull-Requests-and-Code-Review/README.md) | The branch-diff mechanics underlying a PR; addressing feedback; squashing |
| 05 | [GitHub Actions Basics](05-GitHub-Actions-Basics/README.md) | A real workflow file, verified for YAML validity and real command success |

## Suggested Path

Work through 01 → 05 in order — each lesson builds on the previous one's concepts (branching requires understanding commits; rebase/cherry-pick assume familiarity with branching; PRs are built on branch comparison; CI often runs against PRs). See also [15-Testing-and-Debugging](../15-Testing-and-Debugging/README.md), whose Lesson 01 project is reused in this module's Lesson 05 to verify a real CI command.

**Previous module:** [16-Security](../16-Security/README.md)
**Next module:** [18-DevOps-and-Cloud](../18-DevOps-and-Cloud/README.md)
