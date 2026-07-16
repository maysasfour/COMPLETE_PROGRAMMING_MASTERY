// example.ts - basic annotations, type inference, and structural typing.

console.log("--- annotations vs inference ---");
let username: string = "ada"; // explicit annotation (redundant here, shown for contrast)
let city = "Berlin"; // inferred as string, no annotation needed
console.log(username, city);

function greet(name: string): string {
  return `Hello, ${name}`;
}
console.log(greet("Ada"));

console.log("\n--- structural typing ---");
interface Point {
  x: number;
  y: number;
}

function printPoint(p: Point) {
  console.log(`(${p.x}, ${p.y})`);
}

const coordinate = { x: 1, y: 2, label: "origin" }; // more fields than Point strictly requires
printPoint(coordinate); // works: structurally satisfies Point

const anotherShape = { x: 10, y: 20 };
printPoint(anotherShape); // also works: exact shape match, never declared "Point" explicitly
