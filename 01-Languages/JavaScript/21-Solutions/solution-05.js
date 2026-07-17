// solution-05.js - Safe Division with Custom Error Chaining
// See: ../20-Exercises/README.md#exercise-05--safe-division-with-custom-error-chaining-intermediate
//
// Run with:
//   node solution-05.js

class DivisionByZeroError extends Error {
  constructor(message) {
    super(message);
    this.name = "DivisionByZeroError";
  }
}

class InvalidDivisionInputError extends Error {
  constructor(message, options) {
    super(message, options); // options = { cause } - the ES2022 Error cause chain
    this.name = "InvalidDivisionInputError";
  }
}

function safeDivide(a, b) {
  if (b === 0) throw new DivisionByZeroError(`Cannot divide ${a} by zero`);
  return a / b;
}

function parseNumberStrict(str) {
  const n = Number(str);
  // Number() never throws - it returns NaN for anything unparseable, so an
  // explicit isNaN check is the only way to turn a bad string into an error
  // at all, unlike int()/float() in Python which throw ValueError directly.
  if (Number.isNaN(n)) throw new TypeError(`"${str}" is not a valid number`);
  return n;
}

function safeDivideStrings(aStr, bStr) {
  try {
    const a = parseNumberStrict(aStr);
    const b = parseNumberStrict(bStr);
    return safeDivide(a, b);
  } catch (err) {
    // Re-wrapping with { cause: err } keeps the ORIGINAL error (TypeError
    // from parsing, or DivisionByZeroError from safeDivide) reachable via
    // .cause, so nothing diagnostic is thrown away by giving a clearer message.
    throw new InvalidDivisionInputError(
      `Cannot divide '${aStr}' and '${bStr}'`,
      { cause: err }
    );
  }
}

// First, confirm what native JS actually does on float division by zero,
// which is exactly why safeDivide needs its own explicit check.
console.log("Native 5 / 0 evaluates to:", 5 / 0);

const pairs = [
  ["10", "2"],
  ["5", "0"],
  ["ten", "2"],
  ["8", "4"],
];

for (const [aStr, bStr] of pairs) {
  try {
    const result = safeDivideStrings(aStr, bStr);
    console.log(`${aStr} / ${bStr} = ${result}`);
  } catch (err) {
    console.log(`Caught ${err.name}: ${err.message}`);
    if (err.cause) console.log(`  caused by: ${err.cause.name}: ${err.cause.message}`);
  }
}
