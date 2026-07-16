// example.js - higher-order "decorator" wrapping, currying, and pipe-based composition.

console.log("--- higher-order function as a decorator ---");
function withLogging(fn) {
  return function (...args) {
    console.log(`Calling ${fn.name} with`, args);
    const result = fn(...args);
    console.log(`${fn.name} returned`, result);
    return result;
  };
}

function add(a, b) { return a + b; }
const loggedAdd = withLogging(add);
loggedAdd(2, 3);

console.log("\n--- currying ---");
function curry(fn) {
  return function curried(...args) {
    if (args.length >= fn.length) return fn(...args);
    return (...more) => curried(...args, ...more);
  };
}

function add3(a, b, c) { return a + b + c; }
const curriedAdd3 = curry(add3);

console.log("curriedAdd3(1)(2)(3):", curriedAdd3(1)(2)(3));
console.log("curriedAdd3(1, 2)(3):", curriedAdd3(1, 2)(3));
console.log("curriedAdd3(1, 2, 3):", curriedAdd3(1, 2, 3));

console.log("\n--- pipe-based composition ---");
const pipe = (...fns) => (input) => fns.reduce((value, fn) => fn(value), input);

const double = (n) => n * 2;
const increment = (n) => n + 1;
const square = (n) => n * n;

const pipeline = pipe(double, increment, square);
// 5 -> double -> 10 -> increment -> 11 -> square -> 121
console.log("pipe(double, increment, square)(5):", pipeline(5));
