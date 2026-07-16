// example.js - declarations vs expressions vs arrows, default/rest params, closures, and `this`.

console.log("--- three function forms ---");
function add(a, b) { return a + b; }
const subtract = function (a, b) { return a - b; };
const multiply = (a, b) => a * b;
console.log("add(2,3) =", add(2, 3));
console.log("subtract(5,2) =", subtract(5, 2));
console.log("multiply(4,3) =", multiply(4, 3));

console.log("\n--- default and rest parameters ---");
function greet(name = "World") { return `Hello, ${name}`; }
console.log(greet());
console.log(greet("Ada"));

function sum(...numbers) { return numbers.reduce((total, n) => total + n, 0); }
console.log("sum(1,2,3) =", sum(1, 2, 3));

console.log("\n--- closures: independent state per call ---");
function makeCounter() {
  let count = 0;
  return function () {
    count += 1;
    return count;
  };
}
const counterA = makeCounter();
const counterB = makeCounter();
console.log("counterA:", counterA(), counterA(), counterA()); // 1 2 3
console.log("counterB:", counterB());                           // 1 -- independent from counterA

console.log("\n--- this: arrow vs regular function as a callback ---");
const obj = {
  name: "Widget",
  regularMethod() {
    console.log("regular method call, this.name =", this.name);
  },
  delayedArrow(done) {
    setTimeout(() => {
      console.log("arrow callback, this.name =", this.name);
      done();
    }, 0);
  },
  delayedRegular(done) {
    setTimeout(function () {
      console.log("regular callback, this?.name =", this?.name, "(lost -- not obj)");
      done();
    }, 0);
  },
};

obj.regularMethod();
obj.delayedArrow(() => {
  obj.delayedRegular(() => {});
});
