// example.js - truthy/falsy quirks, switch fall-through, all for-loop forms, labeled continue.

console.log("--- truthy [] and {} (unlike Python) ---");
if ([]) console.log("[] is truthy");
if ({}) console.log("{} is truthy");
if (!0 && !"" && !null && !undefined && !NaN) console.log("all standard falsy values confirmed falsy");

console.log("\n--- switch with intentional fall-through ---");
function describeDay(day) {
  switch (day) {
    case "Sat":
    case "Sun":
      return "weekend";
    default:
      return "weekday";
  }
}
console.log("Sat ->", describeDay("Sat"));
console.log("Wed ->", describeDay("Wed"));

console.log("\n--- for forms ---");
for (let i = 0; i < 3; i++) process.stdout.write(`for: ${i} `);
console.log();

for (const fruit of ["apple", "banana"]) process.stdout.write(`for-of: ${fruit} `);
console.log();

for (const key in { a: 1, b: 2 }) process.stdout.write(`for-in key: ${key} `);
console.log();

console.log("\n--- labeled continue ---");
const pairs = [];
outer: for (let i = 0; i < 3; i++) {
  for (let j = 0; j < 3; j++) {
    if (j === 1) continue outer; // skip straight to the next i, not just the next j
    pairs.push([i, j]);
  }
}
console.log("pairs collected (only j=0 for each i, due to labeled continue):", pairs);
