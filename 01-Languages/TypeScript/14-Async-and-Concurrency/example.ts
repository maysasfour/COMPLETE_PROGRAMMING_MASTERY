// example.ts - typed Promise<T>, Promise.all tuple inference, generic fetchWithTimeout<T>.

function delay<T>(ms: number, value: T): Promise<T> {
  return new Promise((resolve) => {
    setTimeout(() => resolve(value), ms);
  });
}

async function loadGreeting(): Promise<string> {
  const message = await delay(10, "Hello!");
  return message.toUpperCase();
}

function fetchWithTimeout<T>(task: () => Promise<T>, timeoutMs: number): Promise<T> {
  const timeout = new Promise<never>((_, reject) => {
    setTimeout(() => reject(new Error(`Timed out after ${timeoutMs}ms`)), timeoutMs);
  });
  return Promise.race([task(), timeout]);
}

async function main() {
  console.log("--- typed delay<T> with different concrete types ---");
  console.log(await loadGreeting());
  console.log(await delay(10, 42));
  console.log(await delay(10, true));

  console.log("\n--- Promise.all preserving per-element types ---");
  const [user, orderCount, isPremium] = await Promise.all([
    delay(30, { name: "Ada" }),
    delay(20, 5),
    delay(10, true),
  ]);
  // Using type-specific operations on each with NO assertions -- proves each kept its own type.
  console.log("user.name.toUpperCase():", user.name.toUpperCase());
  console.log("orderCount.toFixed(0):", orderCount.toFixed(0));
  console.log("isPremium && 'premium user':", isPremium && "premium user");

  console.log("\n--- generic fetchWithTimeout<T> ---");
  const fast = await fetchWithTimeout(() => delay(30, "data"), 200);
  console.log("Fast task result:", fast);

  try {
    await fetchWithTimeout(() => delay(200, "data"), 30);
  } catch (err) {
    if (err instanceof Error) {
      console.log("Slow task correctly timed out:", err.message);
    }
  }
}

main();
