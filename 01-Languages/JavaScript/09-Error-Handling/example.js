// example.js - try/catch/finally, custom error classes, instanceof branching, async errors.

console.log("--- finally always runs ---");
try {
  throw new Error("boom");
} catch (err) {
  console.log("caught:", err.message);
} finally {
  console.log("finally ran");
}

console.log("\n--- custom error class ---");
class ValidationError extends Error {
  constructor(message, field) {
    super(message);
    this.name = "ValidationError";
    this.field = field;
  }
}

function validateAge(age) {
  if (age < 0) throw new ValidationError("Age cannot be negative", "age");
  return age;
}

function handle(fn) {
  try {
    fn();
  } catch (err) {
    if (err instanceof ValidationError) {
      console.log(`Validation failed on field "${err.field}": ${err.message} (name=${err.name})`);
    } else {
      console.log("Re-throwing unrecognized error type:", err.constructor.name);
      throw err;
    }
  }
}

handle(() => validateAge(-5));

console.log("\n--- re-throw caught one level up ---");
try {
  handle(() => {
    throw new TypeError("not a validation error at all");
  });
} catch (err) {
  console.log("Caught at outer level after re-throw:", err.constructor.name, "-", err.message);
}

console.log("\n--- errors inside async functions ---");
async function loadUser(id) {
  if (id <= 0) throw new Error("Invalid id");
  return { id, name: "Ada" };
}

async function main() {
  try {
    const user = await loadUser(-1);
    console.log(user);
  } catch (err) {
    console.log("Caught from an async function with plain try/catch:", err.message);
  }
}

main();
