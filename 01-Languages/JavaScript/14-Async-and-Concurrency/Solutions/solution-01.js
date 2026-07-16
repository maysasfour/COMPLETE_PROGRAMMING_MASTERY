// solution-01.js - fetchWithTimeout implemented with Promise.race.

function delay(ms, value) {
  return new Promise((resolve) => setTimeout(() => resolve(value), ms));
}

async function fetchWithTimeout(asyncTask, timeoutMs) {
  const timeout = new Promise((_, reject) => {
    setTimeout(() => reject(new Error(`Operation timed out after ${timeoutMs}ms`)), timeoutMs);
  });

  return Promise.race([asyncTask(), timeout]);
}

async function main() {
  const fast = await fetchWithTimeout(() => delay(50, "data"), 200);
  console.log(fast);

  try {
    await fetchWithTimeout(() => delay(200, "data"), 50);
  } catch (err) {
    console.log(err.message);
  }
}

main();
