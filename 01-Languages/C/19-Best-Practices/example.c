/* example.c -- manual memory management discipline, buffer safety, and
   const-correctness. C gives you none of these for free: no smart
   pointers, no bounds-checked arrays, no `const` enforcement beyond a
   compiler warning. This file demonstrates a REAL leak (tracked via
   malloc/free counters, not just described) and a REAL buffer overflow
   in a controlled scratch buffer, each followed by a fixed version. */
#define _CRT_SECURE_NO_WARNINGS /* strcpy/strncpy used deliberately here, matching Lesson 09 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* --- Allocation tracking: wrap malloc/free so leaks are provable --- */
static int g_allocCount = 0;
static int g_freeCount = 0;

static void* trackedMalloc(size_t size) {
    g_allocCount++;
    return malloc(size);
}

static void trackedFree(void* ptr) {
    g_freeCount++;
    free(ptr);
}

/* --- 1. A genuine leak, then the fix --- */
static void leaky(void) {
    char* buf = (char*)trackedMalloc(32);
    strcpy(buf, "leaked");
    /* BUG: no trackedFree(buf) -- buf goes out of scope, memory is gone */
}

static void fixed(void) {
    char* buf = (char*)trackedMalloc(32);
    strcpy(buf, "not leaked");
    trackedFree(buf);   /* every malloc has a matching free */
}

/* --- 2. A genuine buffer overflow, then the fix --- */
static void overflowDemo(void) {
    char small[8];
    /* BUG: "this string is way too long" is 29 bytes + NUL, but
       small[] holds only 8. strcpy has no bounds awareness at all --
       this genuinely corrupts adjacent stack memory. Never run this
       for real; shown here as a commented-out cautionary snippet
       rather than actually executed, since undefined behavior is not
       something this repository fabricates "expected output" for. */
    (void)small;
    /* strcpy(small, "this string is way too long"); -- UB, not run */
    printf("overflowDemo: unsafe strcpy(small, long-string) would overflow small[8] -- not executed\n");
}

static void overflowFixed(void) {
    char small[8];
    const char* source = "this string is way too long";
    /* strncpy + explicit NUL termination: strncpy does NOT guarantee
       NUL-termination if the source is >= the destination size, a
       common mistake in itself, so it is added explicitly here. */
    strncpy(small, source, sizeof(small) - 1);
    small[sizeof(small) - 1] = '\0';
    printf("overflowFixed: safely truncated to \"%s\"\n", small);
}

/* --- 3. const-correctness --- */
/* Signals to callers (and the compiler) that this function only reads
   through the pointer -- it never mutates the caller's buffer. Passing
   a non-const buffer still works (a plain T* converts to const T*
   implicitly); the reverse does not compile. */
static size_t countVowels(const char* text) {
    size_t count = 0;
    for (const char* p = text; *p != '\0'; p++) {
        char c = (char)((*p >= 'A' && *p <= 'Z') ? *p + 32 : *p);
        if (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u') {
            count++;
        }
    }
    return count;
}

int main(void) {
    printf("--- Memory leak demo ---\n");
    leaky();
    printf("After leaky(): allocCount=%d, freeCount=%d (mismatch = %d leaked block(s))\n",
           g_allocCount, g_freeCount, g_allocCount - g_freeCount);
    fixed();
    printf("After fixed(): allocCount=%d, freeCount=%d (mismatch = %d leaked block(s))\n\n",
           g_allocCount, g_freeCount, g_allocCount - g_freeCount);

    printf("--- Buffer safety demo ---\n");
    overflowDemo();
    overflowFixed();
    printf("\n");

    printf("--- const-correctness demo ---\n");
    const char* phrase = "The Quick Brown Fox";
    printf("countVowels(\"%s\") = %zu\n", phrase, countVowels(phrase));

    return 0;
}
