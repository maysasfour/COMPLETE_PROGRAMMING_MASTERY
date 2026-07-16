#!/bin/bash
# demo.sh - run this in an empty, throwaway directory to reproduce every command
# and real output shown in this lesson's README, step by step.
set -e

git init -q
git config user.email "demo@example.com"
git config user.name "Demo User"

echo "# My Project" > README.md
echo "--- Initial status of a brand-new repo ---"
git status --short

git add README.md
echo "--- After 'git add README.md' ---"
git status --short

git commit -m "Initial commit" -q
echo "--- After 'git commit' ---"
git log --oneline

echo "## Setup" >> README.md
echo "--- README.md modified but NOT staged ---"
git status --short

echo "--- Attempting 'git commit' WITHOUT staging first ---"
git commit -m "Add setup section" || echo "(commit correctly refused -- nothing was staged)"

echo "--- git log: the unstaged change never made it into a commit ---"
git log --oneline

git add README.md
git commit -m "Add setup section" -q
echo "--- After properly staging and committing ---"
git log --oneline
git status --short
