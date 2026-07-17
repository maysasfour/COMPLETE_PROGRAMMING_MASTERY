# Git and GitHub Cheat Sheet

[Back to Cheat Sheets](../README.md) | [Full module](../../17-Git-and-GitHub/README.md)

## Core Commands
```bash
git status                     # what's staged, unstaged, untracked
git add file.txt                # stage a change
git commit -m "message"          # commit staged changes
git log --oneline                # compact history
git diff                         # unstaged changes
git diff --staged                # staged changes
```
Git correctly REFUSES to commit when nothing is staged — verified live in [17-Git-and-GitHub/01](../../17-Git-and-GitHub/01-Core-Commands/README.md).

## Branching and Merging
```bash
git checkout -b feature/x        # create + switch to a new branch
git merge feature/x               # merge into current branch
```
A real merge conflict shows `<<<<<<<` / `=======` / `>>>>>>>` markers — resolve by hand, then `git add` + `git commit`. See [17-Git-and-GitHub/02](../../17-Git-and-GitHub/02-Branching-and-Merging/README.md).

## Rebase and Cherry-pick
```bash
git rebase master                 # replay commits onto a new base (NEW hashes!)
git cherry-pick <commit-hash>      # apply ONE specific commit elsewhere
```
Verified live: rebasing genuinely creates new commit hashes for the same content — never rebase already-pushed/shared commits. See [17-Git-and-GitHub/03](../../17-Git-and-GitHub/03-Rebase-and-Cherry-pick/README.md).

## Pull Requests
```bash
git diff main...feature/branch     # what a PR's diff view shows
git log main..feature/branch        # commits the PR would include
git reset --soft main && git commit -m "clean single commit"  # squash before merge
```
See [17-Git-and-GitHub/04](../../17-Git-and-GitHub/04-Pull-Requests-and-Code-Review/README.md).

## GitHub Actions
```yaml
name: CI
on:
  push: { branches: [main] }
  pull_request: { branches: [main] }
jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with: { distribution: temurin, java-version: '21' }
      - run: mvn test
```
Gotcha: generic YAML parsers (PyYAML) parse the bare `on` key as the boolean `True`, not the string `"on"` — GitHub's own parser handles it correctly. See [17-Git-and-GitHub/05](../../17-Git-and-GitHub/05-GitHub-Actions-Basics/README.md).

See the [full Git and GitHub module](../../17-Git-and-GitHub/README.md) for real, captured terminal output for everything above.
