// math.test.js - uses Node's built-in test runner (node:test) and assert module.
// Run with: node --test

const test = require("node:test");
const assert = require("node:assert/strict");
const { add, divide } = require("./math.js");

test("add() sums two positive numbers", () => {
  assert.strictEqual(add(2, 3), 5);
});

test("add() handles negative numbers", () => {
  assert.strictEqual(add(-2, -3), -5);
});

test("divide() divides correctly", () => {
  assert.strictEqual(divide(10, 2), 5);
});

test("divide() throws on division by zero", () => {
  assert.throws(() => divide(10, 0), /Cannot divide by zero/);
});

// Grouped tests with test.describe-style nesting via subtests.
test("edge cases", async (t) => {
  await t.test("add(0, 0) is 0", () => {
    assert.strictEqual(add(0, 0), 0);
  });

  await t.test("divide(0, 5) is 0", () => {
    assert.strictEqual(divide(0, 5), 0);
  });
});
