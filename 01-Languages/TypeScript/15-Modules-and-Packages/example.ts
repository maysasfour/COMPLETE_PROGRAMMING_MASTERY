// example.ts - importing types AND values from a local module, and a type-only import.

import { add, constants, type Operation } from "./mymodule";
import type { MathConstants } from "./mymodule"; // type-only import -- erased at compile time

console.log("--- importing a value and a typed constant ---");
console.log("add(2, 3):", add(2, 3));
console.log("constants:", constants);

console.log("\n--- using an imported type with no runtime cost ---");
function describeOperation(op: Operation): string {
  return `Operation requested: ${op}`;
}
console.log(describeOperation("add"));
console.log(describeOperation("multiply"));

function describeConstants(c: MathConstants): string {
  return `pi=${c.pi}, e=${c.e}`;
}
console.log(describeConstants(constants));
