#!/bin/bash
# demo.sh - reproduces a REAL rebase (with genuinely changed commit hashes) and a
# REAL cherry-pick (bringing over exactly one commit, not a whole branch).
set -e

git init -q
git config user.email "demo@example.com"
git config user.name "Demo User"

echo "line1" > file.txt
git add file.txt
git commit -q -m "A: initial file"

git checkout -q -b feature
echo "line2" >> file.txt
git commit -q -am "C: feature adds line2"
echo "line3" >> file.txt
git commit -q -am "D: feature adds line3"

git checkout -q master
echo "unrelated master change" > other.txt
git add other.txt
git commit -q -m "E: master adds other.txt"

echo "=== Before rebase: feature branched off master's OLD commit ==="
git log --oneline --all --graph
echo "--- Commit hashes on feature BEFORE rebase ---"
git log --oneline feature

echo "=== Rebasing feature onto master ==="
git checkout -q feature
git rebase master

echo "=== After rebase: linear history, feature's commits REPLAYED with NEW hashes ==="
git log --oneline --all --graph
echo "--- Commit hashes on feature AFTER rebase (compare to before!) ---"
git log --oneline feature

echo ""
echo "=== Cherry-pick: bringing over ONE specific commit, not a whole branch ==="
git checkout -q master
git checkout -q -b hotfix
echo "URGENT: security patch" > patch.txt
git add patch.txt
git commit -q -m "F: urgent hotfix, needed on master ASAP"
echo "some other unrelated hotfix-branch work" > wip.txt
git add wip.txt
git commit -q -m "G: unrelated work-in-progress, NOT ready for master"

echo "--- hotfix branch has TWO commits; master needs ONLY the urgent one (F) ---"
git log --oneline hotfix
FIX_HASH=$(git log --oneline hotfix | grep "F:" | cut -d' ' -f1)

git checkout -q master
echo "--- master's log BEFORE cherry-pick ---"
git log --oneline master
git cherry-pick "$FIX_HASH"
echo "--- master's log AFTER cherry-picking ONLY commit F ---"
git log --oneline master
echo "--- master's files (patch.txt present, wip.txt correctly absent) ---"
ls
