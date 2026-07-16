// example.js - statements vs expressions, and an ASI pitfall.

// `2 + 2` is an expression; wrapping it in console.log(...) makes the whole line a statement.
console.log("2 + 2 =", 2 + 2);

let x = 1; // statement
let y = x + 1; // `x + 1` is an expression assigned via a statement
console.log("y =", y);

// ASI pitfall: without the semicolon after `let z = 1`, this would parse as
// `let z = 1[1, 2, 3].forEach(...)` -- indexing the number 1, which throws.
try {
  // eslint-disable-next-line no-eval -- deliberately demonstrating the footgun in isolation
  eval("let z = 1\n[1, 2, 3].forEach(n => n)");
  console.log("No error -- environment's parser handled this pattern leniently.");
} catch (err) {
  console.log("ASI pitfall reproduced:", err.constructor.name, "-", err.message);
}

console.log("This file always writes semicolons explicitly to avoid relying on ASI.");
