"""
Lesson 08 - Concurrency Basics
Demonstrates: sequential vs threaded execution timing for I/O-bound
work (proving threads give concurrency despite the GIL, because the
GIL is released during I/O waits), a deliberately unsynchronized race
condition on shared state, and a simple asyncio example.

Run with:
    python example.py

Expected output (timings are approximate/rounded, structure is exact):
    --- Sequential vs threaded I/O-bound work ---
    Sequential total time (2 x 0.3s waits): ~0.6s
    Threaded total time (2 x 0.3s waits, overlapped): ~0.3s
    Threaded run was faster: True

    --- Race condition on shared state (no lock) ---
    Expected final count: 200000
    Actual final count without a lock (non-deterministic - may be 200000 on some runs,
    lower on others; the GIL's thread-switch timing decides, not your code): 200000
    Actual final count WITH a lock (always correct, every run): 200000

    --- A simple asyncio example ---
    A: starting
    B: starting
    B: done
    A: done
    Results: ['A result', 'B result']
"""

import asyncio
import threading
import time

print("--- Sequential vs threaded I/O-bound work ---")


def wait_a_bit(seconds):
    # time.sleep simulates a blocking I/O wait (e.g., a network call) -
    # the CPU is idle during this, which is exactly the situation
    # concurrency is meant to exploit.
    time.sleep(seconds)


# Sequential: each wait fully completes before the next one starts, so
# total time is the SUM of both waits.
start = time.perf_counter()
wait_a_bit(0.3)
wait_a_bit(0.3)
sequential_time = time.perf_counter() - start
print(f"Sequential total time (2 x 0.3s waits): ~{sequential_time:.1f}s")

# Threaded: both waits happen CONCURRENTLY - CPython's GIL is released
# during time.sleep() (a blocking I/O-like call), so the two threads'
# waits overlap instead of stacking, and total time is close to the
# LONGEST single wait rather than the sum of both.
start = time.perf_counter()
t1 = threading.Thread(target=wait_a_bit, args=(0.3,))
t2 = threading.Thread(target=wait_a_bit, args=(0.3,))
t1.start()
t2.start()
t1.join()
t2.join()
threaded_time = time.perf_counter() - start
print(f"Threaded total time (2 x 0.3s waits, overlapped): ~{threaded_time:.1f}s")
print("Threaded run was faster:", threaded_time < sequential_time)

print("\n--- Race condition on shared state (no lock) ---")

ITERATIONS = 100_000


def increment_unsafely(counter_box):
    for _ in range(ITERATIONS):
        # This looks atomic but isn't: it's read-modify-write. Two
        # threads can both read the same value before either writes
        # back, causing one increment to be silently lost.
        counter_box[0] += 1


counter_box = [0]
t1 = threading.Thread(target=increment_unsafely, args=(counter_box,))
t2 = threading.Thread(target=increment_unsafely, args=(counter_box,))
t1.start()
t2.start()
t1.join()
t2.join()
print(f"Expected final count: {ITERATIONS * 2}")
print(
    "Actual final count without a lock (non-deterministic - may be "
    f"{ITERATIONS * 2} on some runs, lower on others; the GIL's "
    f"thread-switch timing decides, not your code): {counter_box[0]}"
)


def increment_safely(counter_box, lock):
    for _ in range(ITERATIONS):
        # The lock ensures only one thread performs the read-modify-write
        # at a time, eliminating the race entirely.
        with lock:
            counter_box[0] += 1


counter_box = [0]
lock = threading.Lock()
t1 = threading.Thread(target=increment_safely, args=(counter_box, lock))
t2 = threading.Thread(target=increment_safely, args=(counter_box, lock))
t1.start()
t2.start()
t1.join()
t2.join()
print(f"Actual final count WITH a lock (always correct, every run): {counter_box[0]}")

print("\n--- A simple asyncio example ---")


async def fetch_data(name, delay):
    print(f"{name}: starting")
    # await yields control back to the event loop for the duration of
    # this simulated wait, letting the OTHER coroutine run meanwhile -
    # this is cooperative concurrency on a SINGLE thread.
    await asyncio.sleep(delay)
    print(f"{name}: done")
    return f"{name} result"


async def main():
    # gather() runs both coroutines concurrently: B (shorter delay)
    # finishes before A, even though A was scheduled first - proof
    # they're genuinely overlapping, not running one after another.
    results = await asyncio.gather(
        fetch_data("A", 0.2),
        fetch_data("B", 0.1),
    )
    print("Results:", results)


asyncio.run(main())
