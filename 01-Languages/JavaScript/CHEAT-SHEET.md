# JavaScript Cheat Sheet

[Back to course overview](README.md)

## Variables

```js
const name = "Ada";   // cannot be reassigned (but object/array contents are still mutable)
let age = 30;          // reassignable
// var x = 1;          // avoid: function-scoped, hoisted, error-prone
```

## Types

```js
typeof 42;          // "number"
typeof "hi";         // "string"
typeof true;         // "boolean"
typeof undefined;    // "undefined"
typeof null;         // "object" (a long-standing bug in the language, kept for compatibility)
typeof {};           // "object"
typeof [];           // "object" -- use Array.isArray([]) to detect arrays specifically
typeof function(){}; // "function"
```

## Operators

```js
5 === "5";   // false (strict equality: no coercion)
5 == "5";    // true  (loose equality: coerces -- avoid)
a ?? b;      // nullish coalescing: b only if a is null/undefined (not just falsy)
a?.b?.c;     // optional chaining: undefined instead of throwing if a or a.b is null/undefined
```

## Control Flow

```js
if (x > 0) { }
else if (x === 0) { }
else { }

switch (day) {
  case "Sat":
  case "Sun":
    console.log("weekend");
    break;
  default:
    console.log("weekday");
}

for (let i = 0; i < 3; i++) { }
for (const item of array) { }       // values
for (const key in object) { }       // keys (avoid for arrays)
while (condition) { }
```

## Functions

```js
function add(a, b) { return a + b; }         // declaration: hoisted
const add2 = (a, b) => a + b;                // arrow: no own `this`, no hoisting
function greet(name = "World") { }            // default parameter
function sum(...nums) { return nums.reduce((a, b) => a + b, 0); } // rest parameter
```

## Arrays

```js
const arr = [1, 2, 3];
arr.push(4); arr.pop();
arr.map(x => x * 2);
arr.filter(x => x > 1);
arr.reduce((acc, x) => acc + x, 0);
const [first, ...rest] = arr;   // destructuring
const combined = [...arr, 4, 5]; // spread
```

## Objects

```js
const user = { name: "Ada", age: 30 };
const { name, age } = user;          // destructuring
const copy = { ...user, age: 31 };   // spread (shallow copy + override)
Object.keys(user); Object.values(user); Object.entries(user);
```

## Map / Set

```js
const m = new Map([["a", 1]]);
m.set("b", 2); m.get("a"); m.has("b");

const s = new Set([1, 2, 2, 3]); // {1, 2, 3} -- duplicates removed
```

## Strings

```js
`${name} is ${age}`;          // template literal
"hello".toUpperCase();
"  hi  ".trim();
"a,b,c".split(",");
["a","b"].join("-");
"hello".includes("ell");
```

## Common Gotchas

```js
NaN === NaN;              // false -- use Number.isNaN(x)
0.1 + 0.2 === 0.3;         // false -- floating point; compare with a tolerance
[1,2] === [1,2];           // false -- reference equality, not structural
```
