// solution-04.js - Deduplicate While Preserving Order
// See: ../20-Exercises/README.md#exercise-04--deduplicate-while-preserving-order-intermediate
//
// Run with:
//   node solution-04.js

function dedupeLoop(items) {
  const seen = new Set(); // O(1) membership checks instead of Array.includes()'s O(n)
  const result = [];
  for (const item of items) {
    if (!seen.has(item)) {
      seen.add(item);
      result.push(item);
    }
  }
  return result;
}

function dedupeOneLiner(items) {
  return [...new Set(items)];
}

const input = [3, 1, 2, 3, 1, 4];
const loopResult = dedupeLoop(input);
const oneLinerResult = dedupeOneLiner(input);

console.log("Loop version:   ", loopResult);
console.log("One-liner (Set):", oneLinerResult);
console.log(
  "Both match:",
  JSON.stringify(loopResult) === JSON.stringify(oneLinerResult)
);
