#!/bin/bash
# demo.sh - reproduces a REAL merge conflict end-to-end in a throwaway directory.
set -e

git init -q
git config user.email "demo@example.com"
git config user.name "Demo User"

echo "Welcome to our site!" > home.txt
git add home.txt
git commit -q -m "Initial homepage text"

git checkout -q -b feature-greeting
echo "Welcome, valued customer!" > home.txt
git commit -q -am "Update greeting on feature branch"

git checkout -q master
echo "Welcome to our AMAZING site!" > home.txt
git commit -q -am "Update greeting on master"

echo "--- Branches now have DIVERGING changes to the same line ---"
git log --oneline --all --graph

echo "--- Attempting to merge feature-greeting into master ---"
git merge feature-greeting || true

echo "--- git status during the conflict ---"
git status --short

echo "--- Real conflict markers in home.txt ---"
cat home.txt

echo "--- Resolving by hand, then staging and committing the merge ---"
echo "Welcome, valued customer, to our AMAZING site!" > home.txt
git add home.txt
git commit -q -m "Merge feature-greeting into master, resolving conflict"

echo "--- git log after the resolved merge ---"
git log --oneline --graph
echo "--- Final content ---"
cat home.txt
