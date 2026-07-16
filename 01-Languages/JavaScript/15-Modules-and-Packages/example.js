// example.js - CommonJS require()/module.exports, plus a built-in Node core module.

console.log("--- requiring a local CommonJS module ---");
const math = require("./mymodule/math.js");
console.log("math.add(2, 3):", math.add(2, 3));
console.log("math.multiply(4, 5):", math.multiply(4, 5));
console.log("math.PI:", math.PI);

console.log("\n--- destructuring at the require() call site ---");
const { add } = require("./mymodule/math.js");
console.log("add(10, 20):", add(10, 20));

console.log("\n--- requiring a built-in Node core module ---");
const os = require("node:os");
console.log("os.platform():", os.platform());
console.log("os.cpus().length:", os.cpus().length, "logical CPUs detected");

console.log("\n--- module caching: require() returns the SAME object on a second call ---");
const mathAgain = require("./mymodule/math.js");
console.log("math === mathAgain:", math === mathAgain, "-- Node caches modules by resolved path");
