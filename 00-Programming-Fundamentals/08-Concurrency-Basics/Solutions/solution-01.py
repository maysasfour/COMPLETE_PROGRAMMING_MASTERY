"""
Solution 01 - Concurrency Basics
Simulated concurrent downloads using asyncio.gather, plus a
demonstration of asyncio.gather's return_exceptions behavior for the
reflection question.

Run with:
    python solution-01.py

Expected output (timing is approximate/rounded, structure is exact):
    Downloading small.txt...
    Downloading medium.txt...
    Downloading large.txt...
    Finished small.txt
    Finished medium.txt
    Finished large.txt
    Total elapsed: ~1.5s (not ~3.0s, because the waits overlapped)
    Results: ['small.txt: 200 OK', 'medium.txt: 200 OK', 'large.txt: 200 OK']

    --- Reflection: what happens if one download raises? ---
    Default gather() re-raises immediately: failed as simulated
    return_exceptions=True collects everything instead:
      small.txt -> failed as simulated
      medium.txt -> medium.txt: 200 OK
      large.txt -> large.txt: 200 OK
"""

import asyncio
import time

files = {
    "small.txt": 0.5,
    "medium.txt": 1.0,
    "large.txt": 1.5,
}


async def download(name, delay):
    print(f"Downloading {name}...")
    # Predict BEFORE running: since all three downloads overlap their
    # waits, total time should be close to the LONGEST single delay
    # (1.5s for large.txt), not the sum of all three (3.0s) - this is
    # the entire point of running them concurrently via gather().
    await asyncio.sleep(delay)
    print(f"Finished {name}")
    return f"{name}: 200 OK"


async def main():
    start = time.perf_counter()
    results = await asyncio.gather(*(download(name, delay) for name, delay in files.items()))
    elapsed = time.perf_counter() - start
    print(f"Total elapsed: ~{elapsed:.1f}s (not ~{sum(files.values()):.1f}s, because the waits overlapped)")
    print("Results:", results)


asyncio.run(main())

print("\n--- Reflection: what happens if one download raises? ---")


async def download_that_fails(name, delay):
    await asyncio.sleep(delay)
    if name == "small.txt":
        raise RuntimeError("failed as simulated")
    return f"{name}: 200 OK"


async def demonstrate_default_behavior():
    try:
        # Default asyncio.gather(): the FIRST exception raised propagates
        # out of gather() immediately, cancelling the other still-running
        # tasks' visibility to the caller (they keep running in the
        # background but their results/errors are discarded here).
        await asyncio.gather(*(download_that_fails(name, delay) for name, delay in files.items()))
    except RuntimeError as error:
        print(f"Default gather() re-raises immediately: {error}")


async def demonstrate_return_exceptions():
    # return_exceptions=True instead COLLECTS every result/exception
    # into the results list, letting the caller decide what to do with
    # each one individually rather than losing the successful results.
    results = await asyncio.gather(
        *(download_that_fails(name, delay) for name, delay in files.items()),
        return_exceptions=True,
    )
    print("return_exceptions=True collects everything instead:")
    for name, result in zip(files.keys(), results):
        if isinstance(result, Exception):
            print(f"  {name} -> {result}")
        else:
            print(f"  {name} -> {result}")


asyncio.run(demonstrate_default_behavior())
asyncio.run(demonstrate_return_exceptions())
