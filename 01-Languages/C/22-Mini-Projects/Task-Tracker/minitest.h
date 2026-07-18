/* minitest.h -- a minimal, hand-rolled, assert-based test harness. This
   IS what "C has no built-in test framework" looks like in practice:
   no test runner binary, no test discovery, no assertion library --
   just a handful of macros wrapping printf and tracking counts in two
   global ints. Reused as-is from Lesson 18. */
#ifndef MINITEST_H
#define MINITEST_H

#include <stdio.h>
#include <string.h>

static int minitest_passed = 0;
static int minitest_failed = 0;

/* Every "test" is just an ordinary C function; TEST_CASE is nothing
   more than a comment-level naming convention documenting intent --
   there is no test discovery, no attribute/annotation the way JUnit's
   @Test or Catch2's TEST_CASE macro provides real runtime registration. */
#define TEST_CASE(name) static void name(void)

#define ASSERT_TRUE(cond) \
    do { \
        if (cond) { \
            minitest_passed++; \
        } else { \
            minitest_failed++; \
            printf("  FAIL: %s (line %d): expected true, got false\n", #cond, __LINE__); \
        } \
    } while (0)

#define ASSERT_EQ_INT(expected, actual) \
    do { \
        int _e = (expected), _a = (actual); \
        if (_e == _a) { \
            minitest_passed++; \
        } else { \
            minitest_failed++; \
            printf("  FAIL: %s == %s (line %d): expected %d, got %d\n", \
                   #expected, #actual, __LINE__, _e, _a); \
        } \
    } while (0)

#define ASSERT_EQ_STR(expected, actual) \
    do { \
        const char* _e = (expected); \
        const char* _a = (actual); \
        if (strcmp(_e, _a) == 0) { \
            minitest_passed++; \
        } else { \
            minitest_failed++; \
            printf("  FAIL: %s == %s (line %d): expected \"%s\", got \"%s\"\n", \
                   #expected, #actual, __LINE__, _e, _a); \
        } \
    } while (0)

/* Runs a test function and prints its name -- there is no automatic
   test discovery; every RUN_TEST call must be written by hand in main. */
#define RUN_TEST(fn) \
    do { \
        printf("Running %s...\n", #fn); \
        fn(); \
    } while (0)

#define MINITEST_SUMMARY() \
    do { \
        printf("\n%d passed, %d failed, %d total\n", \
               minitest_passed, minitest_failed, minitest_passed + minitest_failed); \
    } while (0)

/* Returns a process exit code suitable for main's return statement --
   0 if every assertion passed, 1 otherwise, so a CI script can detect
   failure via the exit code alone, without parsing output. */
#define MINITEST_EXIT_CODE() (minitest_failed == 0 ? 0 : 1)

#endif /* MINITEST_H */
