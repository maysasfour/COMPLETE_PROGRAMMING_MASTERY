// solution-01.ts - overloaded wrapInArray, preserving precise return types per call site.

function wrapInArray<T>(value: T): T[];
function wrapInArray<T>(value: T[]): T[];
function wrapInArray<T>(value: T | T[]): T[] {
  return Array.isArray(value) ? value : [value];
}

function describeCollection(label: string, items: unknown[]): string {
  return `${label}: ${items.length} item(s)`;
}

console.log(describeCollection("single", wrapInArray(42)));
console.log(describeCollection("already-array", wrapInArray([1, 2, 3])));
console.log(describeCollection("single-string", wrapInArray("hello")));
