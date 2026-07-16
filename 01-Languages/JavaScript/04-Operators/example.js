// example.js - arithmetic, ===/== contrast, || vs ??, and optional chaining.

console.log("--- arithmetic ---");
console.log("5 % 3 =", 5 % 3);
console.log("5 ** 2 =", 5 ** 2);

console.log("\n--- === vs == ---");
console.log('5 === "5":', 5 === "5");
console.log('5 == "5":', 5 == "5");
console.log("[] == false:", [] == false, "-- a classic coercion surprise");

console.log("\n--- || vs ?? on falsy-but-valid values ---");
const volumeSetting = 0; // user deliberately muted
console.log("volumeSetting || 50 =", volumeSetting || 50, "-- BUG: silently replaces 0 with 50");
console.log("volumeSetting ?? 50 =", volumeSetting ?? 50, "-- correct: 0 is not null/undefined, kept as-is");

console.log("\n--- optional chaining ---");
const user = { profile: null };
console.log("user.profile?.bio:", user.profile?.bio, "-- short-circuits safely to undefined");
try {
  console.log(user.profile.bio); // no ?. -- this throws
} catch (err) {
  console.log("Without ?., accessing .bio on null throws:", err.constructor.name);
}
