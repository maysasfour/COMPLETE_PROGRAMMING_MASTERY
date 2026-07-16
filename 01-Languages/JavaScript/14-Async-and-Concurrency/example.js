// example.js - Promises, async/await, Promise.all concurrency (with real timing), microtask ordering.

function delay(ms, value) {
  return new Promise((resolve) => {
    setTimeout(() => resolve(value), ms);
  });
}

async function main() {
  console.log("--- basic Promise ---");
  const resolved = await delay(10, "done");
  console.log("Resolved with:", resolved);

  console.log("\n--- async/await ---");
  async function loadGreeting() {
    const message = await delay(10, "Hello!");
    return message.toUpperCase();
  }
  console.log(await loadGreeting());

  console.log("\n--- sequential await vs Promise.all (real timing) ---");
  const sequentialStart = Date.now();
  await delay(80, "a");
  await delay(80, "b");
  await delay(80, "c");
  const sequentialElapsed = Date.now() - sequentialStart;
  console.log(`Sequential 3x80ms awaits took ~${sequentialElapsed}ms`);

  const concurrentStart = Date.now();
  await Promise.all([delay(80, "a"), delay(80, "b"), delay(80, "c")]);
  const concurrentElapsed = Date.now() - concurrentStart;
  console.log(`Promise.all of the same 3x80ms tasks took ~${concurrentElapsed}ms`);
  console.log(
    concurrentElapsed < sequentialElapsed
      ? "Confirmed: Promise.all was faster than sequential awaiting."
      : "Unexpected: concurrent run was not faster (check system load)."
  );

  console.log("\n--- Promise.allSettled with a mixed success/failure batch ---");
  const results = await Promise.allSettled([
    delay(10, "ok-1"),
    Promise.reject(new Error("task failed")),
    delay(10, "ok-2"),
  ]);
  console.log(results.map((r) => (r.status === "fulfilled" ? r.value : `FAILED: ${r.reason.message}`)));

  console.log("\n--- microtask vs macrotask ordering ---");
  console.log("1: sync");
  setTimeout(() => console.log("4: macrotask (setTimeout)"), 0);
  Promise.resolve().then(() => console.log("3: microtask (Promise)"));
  console.log("2: sync");
}

main();
