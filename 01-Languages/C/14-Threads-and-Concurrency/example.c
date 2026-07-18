/* example.c -- C11's <threads.h>, confirmed genuinely working on this
   MSVC toolchain (see README.md for the confirmation). Demonstrates
   thrd_create/thrd_join, a real (reproduced) race condition on an
   unprotected shared counter, and the mtx_t-protected fix. */
#include <stdio.h>
#include <threads.h>

/* --- Part 1: basic thread creation and joining --- */
int printWorker(void* arg) {
    int id = *(int*)arg;
    printf("worker thread %d running\n", id);
    return 0;
}

/* --- Part 2: an UNPROTECTED shared counter -- a real race condition --- */
long unsafeCounter = 0;

int incrementUnsafe(void* arg) {
    int iterations = *(int*)arg;
    for (int i = 0; i < iterations; i++) {
        /* This is NOT atomic: read, increment, write are three separate
           steps, and another thread can interleave between them,
           losing increments. This is a genuine, reproducible race
           condition, not a hypothetical one. */
        unsafeCounter = unsafeCounter + 1;
    }
    return 0;
}

/* --- Part 3: the FIX -- a mutex protecting the same increment --- */
long safeCounter = 0;
mtx_t counterMutex;

int incrementSafe(void* arg) {
    int iterations = *(int*)arg;
    for (int i = 0; i < iterations; i++) {
        mtx_lock(&counterMutex);
        safeCounter = safeCounter + 1;
        mtx_unlock(&counterMutex);
    }
    return 0;
}

int main(void) {
    /* Part 1: basic threads */
    thrd_t t1, t2;
    int id1 = 1, id2 = 2;
    thrd_create(&t1, printWorker, &id1);
    thrd_create(&t2, printWorker, &id2);
    thrd_join(t1, NULL);
    thrd_join(t2, NULL);

    /* Part 2: reproduce the race. Four threads each incrementing
       200,000 times should total 800,000 if no increments are lost --
       run WITHOUT a mutex, the total is frequently (not always -- races
       are nondeterministic, which is exactly the point) LESS than
       800,000, because increments get silently lost when two threads
       interleave their read-increment-write steps. */
    printf("\n-- unprotected counter (race condition) --\n");
    int iterations = 200000;
    thrd_t racers[4];
    for (int i = 0; i < 4; i++) {
        thrd_create(&racers[i], incrementUnsafe, &iterations);
    }
    for (int i = 0; i < 4; i++) {
        thrd_join(racers[i], NULL);
    }
    printf("expected 800000, got %ld (%s)\n", unsafeCounter,
           unsafeCounter == 800000 ? "no lost increments this run -- races are nondeterministic"
                                     : "LOST INCREMENTS -- the race condition, genuinely reproduced");

    /* Part 3: the same test, mutex-protected -- always exactly correct. */
    printf("\n-- mutex-protected counter (fixed) --\n");
    mtx_init(&counterMutex, mtx_plain);
    thrd_t safeRacers[4];
    for (int i = 0; i < 4; i++) {
        thrd_create(&safeRacers[i], incrementSafe, &iterations);
    }
    for (int i = 0; i < 4; i++) {
        thrd_join(safeRacers[i], NULL);
    }
    mtx_destroy(&counterMutex);
    printf("expected 800000, got %ld (always correct -- mtx_lock/mtx_unlock make the increment atomic)\n",
           safeCounter);

    return 0;
}
