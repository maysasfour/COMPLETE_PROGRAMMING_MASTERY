#!/usr/bin/env bash
pass=0; fail=0
assert_eq() {
  local desc="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    echo "PASS: $desc"; pass=$((pass+1))
  else
    echo "FAIL: $desc (expected '$expected', got '$actual')"; fail=$((fail+1))
  fi
}
report() { echo "Results: $pass passed, $fail failed"; [ "$fail" -eq 0 ]; }
