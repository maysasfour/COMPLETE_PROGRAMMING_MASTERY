// example.js - template literals, common string methods, immutability, split/join.

console.log("--- template literals ---");
const name = "Ada";
const age = 30;
console.log(`${name} is ${age} years old`);
console.log(`Next year: ${age + 1}`);

console.log("\n--- common string methods ---");
console.log('"  hello  ".trim():', JSON.stringify("  hello  ".trim()));
console.log('"hello".toUpperCase():', "hello".toUpperCase());
console.log('"hello world".includes("wor"):', "hello world".includes("wor"));
console.log('"hello world".startsWith("hello"):', "hello world".startsWith("hello"));
console.log('"hello world".indexOf("world"):', "hello world".indexOf("world"));
console.log('"hello".slice(1, 3):', "hello".slice(1, 3));
console.log('"hello".replace("l", "L") (first only):', "hello".replace("l", "L"));
console.log('"hello".replaceAll("l", "L") (every match):', "hello".replaceAll("l", "L"));
console.log('"a,b,c".split(","):', "a,b,c".split(","));
console.log('["a","b","c"].join("-"):', ["a", "b", "c"].join("-"));
console.log('"abc".padStart(5, "0"):', "abc".padStart(5, "0"));

console.log("\n--- immutability ---");
let greeting = "hello";
greeting.toUpperCase(); // return value discarded -- no effect
console.log("after calling toUpperCase() without reassigning:", greeting);
greeting = greeting.toUpperCase(); // must reassign to see the change
console.log("after reassigning:", greeting);
