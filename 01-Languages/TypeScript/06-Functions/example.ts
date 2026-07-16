// example.ts - typed functions, optional/default params, rest params, callbacks, overloads.

console.log("--- basic typed functions ---");
function add(a: number, b: number): number {
  return a + b;
}
console.log("add(2, 3):", add(2, 3));

function greet(name: string = "World"): string {
  return `Hello, ${name}`;
}
console.log(greet());
console.log(greet("Ada"));

function describe(name: string, nickname?: string): string {
  return nickname ? `${name} ("${nickname}")` : name;
}
console.log(describe("Ada"));
console.log(describe("Ada", "the Enchantress"));

console.log("\n--- rest parameters ---");
function sum(...numbers: number[]): number {
  return numbers.reduce((total, n) => total + n, 0);
}
console.log("sum(1,2,3,4):", sum(1, 2, 3, 4));

console.log("\n--- typed callback parameter ---");
function processItems(items: string[], callback: (item: string, index: number) => void): void {
  items.forEach(callback);
}
processItems(["a", "b", "c"], (item, index) => {
  console.log(`  item ${index}: ${item}`);
});

console.log("\n--- function overloads ---");
function parseValue(value: string): string;
function parseValue(value: number): number;
function parseValue(value: string | number): string | number {
  if (typeof value === "string") {
    return value.trim();
  }
  return Math.round(value);
}

const trimmed = parseValue("  hello  "); // typed as string
const rounded = parseValue(3.7); // typed as number
console.log(`Trimmed: "${trimmed}" (length ${trimmed.length})`); // .length works: known to be string
console.log(`Rounded: ${rounded.toFixed(0)}`); // .toFixed works: known to be number
