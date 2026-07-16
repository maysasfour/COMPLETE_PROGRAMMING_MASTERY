// example.ts - typed arrays/tuples, Map/Set, interfaces, Record, and readonly.

console.log("--- typed array and tuple ---");
const scores: number[] = [95, 88, 76];
const pair: [string, number] = ["Ada", 30];
console.log(scores, pair);

console.log("\n--- typed Map and Set ---");
const ages = new Map<string, number>();
ages.set("Ada", 30);
ages.set("Lin", 28);
console.log("ages.get('Ada'):", ages.get("Ada"));

const uniqueTags = new Set<string>(["js", "ts", "js"]);
console.log("uniqueTags:", [...uniqueTags]);

console.log("\n--- interface with optional and readonly properties ---");
interface User {
  id: number;
  name: string;
  email?: string;
  readonly createdAt: string;
}

const user: User = { id: 1, name: "Ada", createdAt: "2026-01-01" };
console.log(user);
// user.createdAt = "changed"; // would fail to COMPILE -- readonly property

console.log("\n--- Record forcing every literal-union key to be present ---");
type Role = "admin" | "editor" | "viewer";
const permissions: Record<Role, string[]> = {
  admin: ["read", "write", "delete"],
  editor: ["read", "write"],
  viewer: ["read"],
};
console.log(permissions);
// Omitting "viewer" above would fail to COMPILE: Property 'viewer' is missing.

console.log("\n--- const vs readonly: different guarantees ---");
const numbers: readonly number[] = [1, 2, 3];
console.log("readonly array contents:", numbers);
// numbers.push(4); // would fail to COMPILE -- push doesn't exist on readonly number[]

const mutableRef = { count: 0 };
mutableRef.count = 5; // legal: const prevents REASSIGNING mutableRef, not mutating its properties
console.log("const object's property was still mutated:", mutableRef);
