// example.js - a "before" (bad-practice) and "after" (best-practice) version of the same
// small task, both run here so the comparison is verified, not just asserted in prose.

console.log("=== BEFORE: several avoidable mistakes ===");
function getDiscountedPriceBad(price, discountPercent) {
  // Mistake 1: var instead of let/const.
  var discount = discountPercent || 10; // Mistake 2: || silently overrides a deliberate 0% discount
  // Mistake 3: == instead of ===
  if (price == undefined) {
    return 0;
  }
  return price - (price * discount) / 100;
}

console.log("getDiscountedPriceBad(100, 20):", getDiscountedPriceBad(100, 20)); // 80 -- looks right
console.log(
  "getDiscountedPriceBad(100, 0):",
  getDiscountedPriceBad(100, 0),
  "<- BUG: an intentional 0% discount was silently replaced with the 10% fallback"
);

console.log("\n=== AFTER: applying this course's best practices ===");
function getDiscountedPrice(price, discountPercent) {
  const discount = discountPercent ?? 10; // ?? only falls back for null/undefined, not 0
  if (price === undefined) {
    return 0;
  }
  return price - (price * discount) / 100;
}

console.log("getDiscountedPrice(100, 20):", getDiscountedPrice(100, 20));
console.log(
  "getDiscountedPrice(100, 0):",
  getDiscountedPrice(100, 0),
  "<- correct: an intentional 0% discount is honored, full price returned"
);

console.log("\n=== Promise.all vs sequential await, timed ===");
function delay(ms, value) {
  return new Promise((resolve) => setTimeout(() => resolve(value), ms));
}

async function main() {
  const sequentialStart = Date.now();
  await delay(50, "a");
  await delay(50, "b");
  console.log(`Sequential (bad for independent work): ~${Date.now() - sequentialStart}ms`);

  const concurrentStart = Date.now();
  await Promise.all([delay(50, "a"), delay(50, "b")]);
  console.log(`Promise.all (best practice for independent work): ~${Date.now() - concurrentStart}ms`);
}

main();
