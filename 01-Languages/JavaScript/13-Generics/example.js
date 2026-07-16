// example.js - duck-typed "generic" functions, and the silent-failure cost of no real generics.

console.log("--- duck-typed generic functions, working across types 'for free' ---");
function first(items) {
  return items[0];
}
console.log("first([1,2,3]):", first([1, 2, 3]));
console.log('first(["a","b","c"]):', first(["a", "b", "c"]));
console.log("first([{id:1},{id:2}]):", first([{ id: 1 }, { id: 2 }]));

function identity(value) {
  return value;
}
console.log("identity(42):", identity(42));
console.log('identity("hello"):', identity("hello"));
console.log("identity([1,2,3]):", identity([1, 2, 3]));

console.log("\n--- the cost of no compile-time checking ---");
function merge(a, b) {
  return { ...a, ...b };
}
console.log("merge({x:1}, {y:2}):", merge({ x: 1 }, { y: 2 }));
console.log(
  'merge({x:1}, "oops") -- silently "works", nonsensical result:',
  merge({ x: 1 }, "oops")
);
console.log("A TypeScript version of merge<A, B> would reject the second call before runtime.");
