// example.ts - demonstrates type-checking at compile time, and type erasure at runtime.

const message: string = "Hello, TypeScript";
console.log(message);

// The line below, if uncommented, fails to COMPILE (not run) with:
//   Type 'number' is not assignable to type 'string'.
// const broken: string = 42;

const age: number = 30;
const isActive: boolean = true;

console.log(`age: ${age}, isActive: ${isActive}`);

// Type erasure in action: at runtime, `typeof message` is just "string" (a JS runtime concept),
// not "TypeScript string" -- there is no trace of the annotation left after compilation.
console.log("typeof message at runtime:", typeof message);
