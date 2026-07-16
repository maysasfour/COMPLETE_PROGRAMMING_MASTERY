// example.ts - generic functions, constraints, generic interfaces/classes, default type parameters.

console.log("--- generic function with inference ---");
function first<T>(items: T[]): T | undefined {
  return items[0];
}

const firstNumber = first([1, 2, 3]);
const firstString = first(["a", "b", "c"]);
console.log("firstNumber:", firstNumber, "(type-checked as number | undefined)");
console.log("firstString:", firstString?.toUpperCase(), "(type-checked as string | undefined)");

console.log("\n--- constrained generic (T extends HasLength) ---");
interface HasLength {
  length: number;
}

function logLength<T extends HasLength>(value: T): T {
  console.log(`  Length: ${value.length}`);
  return value;
}

logLength("hello");
logLength([1, 2, 3, 4]);
// logLength(42); // would fail to COMPILE -- number has no .length property

console.log("\n--- generic interface Box<T> ---");
interface Box<T> {
  value: T;
}
const numberBox: Box<number> = { value: 42 };
const stringBox: Box<string> = { value: "hello" };
console.log("numberBox.value:", numberBox.value);
console.log("stringBox.value:", stringBox.value);

console.log("\n--- generic class Stack<T> ---");
class Stack<T> {
  private items: T[] = [];

  push(item: T): void {
    this.items.push(item);
  }

  pop(): T | undefined {
    return this.items.pop();
  }

  get size(): number {
    return this.items.length;
  }
}

const numberStack = new Stack<number>();
numberStack.push(1);
numberStack.push(2);
numberStack.push(3);
console.log("numberStack.size:", numberStack.size);
console.log("numberStack.pop():", numberStack.pop());

const stringStack = new Stack<string>();
stringStack.push("a");
stringStack.push("b");
console.log("stringStack.pop():", stringStack.pop());

console.log("\n--- multiple and default type parameters ---");
interface KeyValuePair<K, V = string> {
  key: K;
  value: V;
}

const pair1: KeyValuePair<number> = { key: 1, value: "one" };
const pair2: KeyValuePair<number, boolean> = { key: 1, value: true };
console.log("pair1 (V defaulted to string):", pair1);
console.log("pair2 (V explicitly boolean):", pair2);
