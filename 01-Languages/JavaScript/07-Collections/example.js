// example.js - array methods, object key/value extraction, destructuring/spread, Map/Set.

console.log("--- array transformation methods ---");
const numbers = [1, 2, 3, 4, 5];
console.log("map (doubled):", numbers.map(n => n * 2));
console.log("filter (evens):", numbers.filter(n => n % 2 === 0));
console.log("reduce (sum):", numbers.reduce((acc, n) => acc + n, 0));
console.log("find (>3):", numbers.find(n => n > 3));
console.log("some (has even):", numbers.some(n => n % 2 === 0));
console.log("every (all positive):", numbers.every(n => n > 0));
console.log("original numbers unchanged:", numbers);

console.log("\n--- objects ---");
const user = { name: "Ada", age: 30 };
console.log("Object.keys:", Object.keys(user));
console.log("Object.values:", Object.values(user));
console.log("Object.entries:", Object.entries(user));

console.log("\n--- destructuring and spread ---");
const [first, second, ...rest] = [1, 2, 3, 4];
console.log("first:", first, "second:", second, "rest:", rest);

const { name, age } = user;
console.log("destructured:", name, age);

const arrCopy = [...numbers];
arrCopy.push(999);
console.log("original after copy mutated:", numbers, "| copy:", arrCopy);

const nested = { profile: { city: "Berlin" } };
const shallowCopy = { ...nested };
shallowCopy.profile.city = "Munich"; // mutates the SHARED nested object
console.log("shallow copy caveat -- original.profile.city is now:", nested.profile.city);

console.log("\n--- Map ---");
const scores = new Map();
scores.set("Ada", 95);
scores.set("Lin", 88);
console.log("scores.get('Ada'):", scores.get("Ada"));
console.log("scores.size:", scores.size);

console.log("\n--- Set and the dedupe idiom ---");
const tags = ["js", "css", "js", "html", "css"];
const uniqueTags = [...new Set(tags)];
console.log("original tags:", tags);
console.log("deduped tags:", uniqueTags);
