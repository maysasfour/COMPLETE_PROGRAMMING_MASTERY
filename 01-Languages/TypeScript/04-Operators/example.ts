// example.ts - type-checked operators, `as` assertions (correct and incorrect), type guards.

console.log("--- type-checked arithmetic ---");
function add(a: number, b: number): number {
  return a + b;
}
console.log("add(2, 3):", add(2, 3));
// add("2", 3); // would fail to COMPILE -- caught before ever running

console.log("\n--- ?? still works exactly as in plain JS ---");
const config: { timeout?: number } = {};
const timeout = config.timeout ?? 5000;
console.log("timeout:", timeout);

console.log("\n--- correct vs incorrect `as` assertions ---");
const input: unknown = "42";
const asString = input as string;
console.log("Correct assertion, safe to use:", asString.length);

const wrongAssertion = input as number;
console.log("Incorrect assertion compiled without error. typeof at runtime is still:", typeof wrongAssertion);
// Deliberately NOT calling wrongAssertion.toFixed(2) here -- that would genuinely crash the process,
// which is exactly the point: the compiler didn't stop us, only the eventual runtime use would.

console.log("\n--- type guards: the safe alternative ---");
function isString(value: unknown): value is string {
  return typeof value === "string";
}

function processValue(value: unknown) {
  if (isString(value)) {
    console.log("Guarded as string, safe to call toUpperCase():", value.toUpperCase());
  } else {
    console.log("Not a string, value is:", value);
  }
}

processValue("hello");
processValue(42);
processValue(input); // "42" the string -- guard correctly identifies it as a string
