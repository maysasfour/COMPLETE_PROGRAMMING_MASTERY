#!/bin/bash
# demo.sh - reproduces the underlying git mechanics a Pull Request relies on:
# comparing two branches, reviewing the diff, addressing feedback, and cleaning up
# history before merge. This lesson has no GitHub remote/account configured, so it
# demonstrates the real, local git operations a PR view is built on top of, rather
# than a live GitHub UI.
set -e

git init -q
git config user.email "demo@example.com"
git config user.name "Demo User"

echo "def greet(): return 'Hello, world'" > greet.py
git add greet.py
git commit -q -m "Initial commit"

git checkout -q -b feature/farewell
echo "def farewell(): return 'Goobye'" >> greet.py
git commit -q -am "Add farewell function"

echo "=== Simulating a Pull Request: feature/farewell -> master ==="
echo "--- The diff a reviewer would actually see ---"
git diff master...feature/farewell
echo "--- Commits included in the PR ---"
git log --oneline master..feature/farewell

echo ""
echo "Reviewer comment: \"Typo: 'Goobye' should be 'Goodbye'\""
echo "--- Author fixes it and pushes a fixup commit ---"
sed -i "s/Goobye/Goodbye/" greet.py
git commit -q -am "Fix typo per review: Goobye -> Goodbye"
git log --oneline master..feature/farewell

echo "--- Squashing review-fixup commits into one clean commit before merge ---"
git reset -q --soft master
git commit -q -m "Add farewell function"
echo "--- Clean, single commit ready to merge ---"
git log --oneline master..feature/farewell
git diff master...feature/farewell
