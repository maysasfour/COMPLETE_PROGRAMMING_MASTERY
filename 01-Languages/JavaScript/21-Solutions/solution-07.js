// solution-07.js - Async Task Runner with Retry and Backoff
// See: ../20-Exercises/README.md#exercise-07--async-task-runner-with-retry-and-backoff-advanced
//
// Run with:
//   node solution-07.js

class RetryExhaustedError extends Error {
  constructor(message, options) {
    super(message, options);
    this.name = "RetryExhaustedError";
  }
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function retry(fn, { retries = 3, delayMs = 50 } = {}) {
  let lastError;
  for (let attempt = 0; attempt < retries; attempt++) {
    try {
      return await fn();
    } catch (err) {
      lastError = err;
      // Only sleep between attempts, not after the last one - otherwise
      // the function waits out a final backoff delay for nothing before
      // throwing anyway.
      if (attempt < retries - 1) {
        await sleep(delayMs * 2 ** attempt);
      }
    }
  }
  throw new RetryExhaustedError(
    `All ${retries} attempts failed: ${lastError.message}`,
    { cause: lastError }
  );
}

function makeFlakyFn(failuresBeforeSuccess) {
  let calls = 0;
  return async () => {
    calls++;
    if (calls <= failuresBeforeSuccess) {
      throw new Error(`simulated failure on call ${calls}`);
    }
    return `success on call ${calls}`;
  };
}

async function main() {
  const flaky = makeFlakyFn(2); // fails on calls 1 and 2, succeeds on call 3
  const start = Date.now();
  const result = await retry(flaky, { retries: 3, delayMs: 50 });
  const elapsed = Date.now() - start;
  console.log(`Flaky call result: ${result}`);
  // Backoff schedule for 2 failures before the delayMs=50 base is
  // 50*2^0 + 50*2^1 = 50 + 100 = 150ms minimum - confirming this with a
  // real clock (not just trusting the math) is the point of this check.
  console.log(`Elapsed: ${elapsed}ms (expected >= 150ms of backoff delay)`);
  console.log(`Backoff actually happened: ${elapsed >= 150}`);

  const alwaysFails = async () => {
    throw new Error("permanent failure");
  };
  try {
    await retry(alwaysFails, { retries: 3, delayMs: 10 });
  } catch (err) {
    console.log(`Caught ${err.name}: ${err.message}`);
    console.log(`  caused by: ${err.cause.message}`);
  }
}

main();
