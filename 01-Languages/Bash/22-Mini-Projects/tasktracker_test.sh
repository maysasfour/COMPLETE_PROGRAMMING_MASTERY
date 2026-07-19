#!/usr/bin/env bash
# Test harness for tasktracker.sh, using the assert helpers from Lesson 18
set -uo pipefail
source ./assert.sh

export TASK_DATA_FILE
TASK_DATA_FILE=$(mktemp -u)
trap 'rm -f "$TASK_DATA_FILE"' EXIT

out=$(bash tasktracker.sh add "Buy milk")
assert_eq "add returns confirmation" "Added task #1: Buy milk" "$out"

out=$(bash tasktracker.sh add "Walk the dog")
assert_eq "second add gets id 2" "Added task #2: Walk the dog" "$out"

out=$(bash tasktracker.sh list | tail -n +2 | wc -l | tr -d ' ')
assert_eq "list shows 2 tasks" "2" "$out"

bash tasktracker.sh done 1 > /dev/null
out=$(grep "^1|" "$TASK_DATA_FILE" | cut -d'|' -f2)
assert_eq "task 1 marked done" "done" "$out"

bash tasktracker.sh rm 2 > /dev/null
out=$(bash tasktracker.sh list | tail -n +2 | wc -l | tr -d ' ')
assert_eq "list shows 1 task after rm" "1" "$out"

report
