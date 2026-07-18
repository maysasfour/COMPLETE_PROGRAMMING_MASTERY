/* example.c -- using minitest.h, the hand-rolled harness from
   minitest.h, against a few small functions. C has no built-in test
   framework at all (no JUnit/pytest/xUnit/Catch2 equivalent shipped
   with the language or standard library) -- this file, plus
   minitest.h, IS what "no framework" looks like: everything is
   ordinary C, no special build step, no test-discovery magic. */
#include "minitest.h"

/* --- Functions under test --- */
int add(int a, int b) { return a + b; }
int isEven(int n) { return n % 2 == 0; }

/* A DELIBERATELY buggy function first, to prove the harness genuinely
   detects a real failure rather than only ever showing passing tests --
   this repository's stated preference for honest, reproduced results
   over suspiciously-always-green demonstrations. */
int clampBuggy(int value, int lo, int hi) {
    if (value < lo) return lo;
    /* BUG: missing the upper-bound check entirely */
    return value;
}

int clampFixed(int value, int lo, int hi) {
    if (value < lo) return lo;
    if (value > hi) return hi;
    return value;
}

TEST_CASE(test_add) {
    ASSERT_EQ_INT(5, add(2, 3));
    ASSERT_EQ_INT(0, add(-3, 3));
    ASSERT_EQ_INT(-7, add(-4, -3));
}

TEST_CASE(test_isEven) {
    ASSERT_TRUE(isEven(4));
    ASSERT_TRUE(!isEven(7));
    ASSERT_TRUE(isEven(0));
}

TEST_CASE(test_clamp_buggy_version_genuinely_fails) {
    /* value=15 should clamp DOWN to hi=10, but clampBuggy has no upper
       bound check at all -- this assertion is expected, and confirmed
       below, to actually FAIL when run, not just described as buggy. */
    ASSERT_EQ_INT(10, clampBuggy(15, 0, 10));
}

TEST_CASE(test_clamp_fixed_version_passes) {
    ASSERT_EQ_INT(10, clampFixed(15, 0, 10));   /* clamps down correctly */
    ASSERT_EQ_INT(0, clampFixed(-5, 0, 10));    /* clamps up correctly */
    ASSERT_EQ_INT(7, clampFixed(7, 0, 10));     /* within range, unchanged */
}

int main(void) {
    RUN_TEST(test_add);
    RUN_TEST(test_isEven);
    RUN_TEST(test_clamp_buggy_version_genuinely_fails);
    RUN_TEST(test_clamp_fixed_version_passes);

    MINITEST_SUMMARY();
    return MINITEST_EXIT_CODE();
}
