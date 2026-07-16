// example.ts - any vs unknown, never, void, union/literal types, strictNullChecks narrowing.

console.log("--- arrays and tuples ---");
const tags: string[] = ["a", "b"];
const coordinates: [number, number] = [1, 2];
console.log(tags, coordinates);

console.log("\n--- any vs unknown ---");
function fetchSomeJson(): any {
  return { name: "Ada", role: "admin" };
}

const dataAny: any = fetchSomeJson();
console.log("any (unchecked):", dataAny.name.toUpperCase()); // compiles with zero checking

const dataUnknown: unknown = fetchSomeJson();
if (typeof dataUnknown === "object" && dataUnknown !== null && "name" in dataUnknown) {
  const narrowed = dataUnknown as { name: string };
  console.log("unknown (after narrowing):", narrowed.name.toUpperCase());
}

console.log("\n--- never: an always-throwing function ---");
function fail(message: string): never {
  throw new Error(message);
}

try {
  fail("deliberate failure");
} catch (err) {
  console.log("Caught from a never-returning function:", (err as Error).message);
}

console.log("\n--- void: return value exists at runtime but shouldn't be used ---");
function logMessage(msg: string): void {
  console.log("logged:", msg);
}
const result = logMessage("hello"); // TypeScript allows this but the value is meaningless
console.log("logMessage's return value at runtime is actually:", result);

console.log("\n--- union and literal types ---");
type Status = "pending" | "active" | "done";

function setStatus(status: Status) {
  console.log("Status set to:", status);
}
setStatus("active");
// setStatus("cancelled"); // would fail to COMPILE: not assignable to type 'Status'

let id: number | string = 42;
console.log("id as number:", id);
id = "abc-123";
console.log("id as string:", id);

console.log("\n--- strictNullChecks narrowing ---");
function getLength(text: string): number {
  return text.length;
}

let maybeText: string | undefined = "hello";
if (maybeText !== undefined) {
  console.log("Narrowed, safe to call getLength:", getLength(maybeText));
}
maybeText = undefined;
if (maybeText === undefined) {
  console.log("maybeText is undefined -- getLength would be a compile error here, correctly skipped");
}
