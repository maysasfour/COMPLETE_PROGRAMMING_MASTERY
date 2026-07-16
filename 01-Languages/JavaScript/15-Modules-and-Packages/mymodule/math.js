// mymodule/math.js - a small CommonJS module, imported by example.js via require().

function add(a, b) {
  return a + b;
}

function multiply(a, b) {
  return a * b;
}

const PI = 3.14159;

// module.exports is the ONE value this file exposes to whoever requires() it.
// Everything else declared above (add, multiply, PI) stays private to this file
// unless explicitly attached here.
module.exports = { add, multiply, PI };
