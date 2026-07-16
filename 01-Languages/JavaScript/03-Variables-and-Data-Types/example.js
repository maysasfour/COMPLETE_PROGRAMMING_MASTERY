// example.js - primitive types, null vs undefined, and coercion.

console.log("--- typeof each primitive ---");
console.log("typeof 42:", typeof 42);
console.log("typeof 'hello':", typeof "hello");
console.log("typeof true:", typeof true);
console.log("typeof undefined:", typeof undefined);
console.log("typeof null:", typeof null, "<- the famous quirk, this is NOT a bug in this file");
console.log("typeof 10n:", typeof 10n);
console.log("typeof Symbol('id'):", typeof Symbol("id"));
console.log("typeof {}:", typeof {});
console.log("typeof []:", typeof [], "-- use Array.isArray() to actually detect arrays");
console.log("Array.isArray([]):", Array.isArray([]));

console.log("\n--- null vs undefined ---");
let a;
let b = null;
console.log("a (declared, unassigned):", a);
console.log("b (explicitly null):", b);
console.log("a === undefined:", a === undefined);
console.log("b === null:", b === null);
console.log("a == b:", a == b, "-- == treats null and undefined as loosely equal to each other");
console.log("a === b:", a === b, "-- === also checks type, so this is false");

console.log("\n--- coercion ---");
console.log('"5" + 3 =', "5" + 3, "(string concatenation)");
console.log('"5" - 3 =', "5" - 3, "(numeric subtraction, string coerced to number)");
console.log('"5" == 5:', "5" == 5, "(coerced before comparing)");
console.log('"5" === 5:', "5" === 5, "(no coercion -- different types, not equal)");

console.log("\n--- const prevents reassignment, not mutation ---");
const arr = [1, 2, 3];
arr.push(4); // legal: mutating the array's contents
console.log("arr after push:", arr);
try {
  arr = []; // illegal: reassigning the const binding itself
} catch (err) {
  console.log("Reassigning a const throws:", err.constructor.name);
}
