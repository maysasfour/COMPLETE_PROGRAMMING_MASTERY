// solution-01.js - custom error hierarchy plus instanceof-based description, re-throwing unknowns.

class RequiredFieldError extends Error {
  constructor(message, field) {
    super(message);
    this.name = "RequiredFieldError";
    this.field = field;
  }
}

class TypeMismatchError extends Error {
  constructor(message, field) {
    super(message);
    this.name = "TypeMismatchError";
    this.field = field;
  }
}

function validateUser(data) {
  if (!data.name || data.name.trim() === "") {
    throw new RequiredFieldError("name is required", "name");
  }
  if (data.age === undefined) {
    throw new RequiredFieldError("age is required", "age");
  }
  if (typeof data.age !== "number" || Number.isNaN(data.age)) {
    throw new TypeMismatchError("age must be a number", "age");
  }
  if (data.age < 0) {
    throw new RequiredFieldError("age must be a valid non-negative number", "age");
  }
  return data;
}

function describeValidationError(err) {
  if (err instanceof RequiredFieldError) {
    return `Missing or invalid required field: "${err.field}" (${err.message})`;
  }
  if (err instanceof TypeMismatchError) {
    return `Type mismatch on field: "${err.field}" (${err.message})`;
  }
  throw err; // not a validation error we recognize -- let it propagate
}

function tryValidate(data) {
  try {
    const result = validateUser(data);
    console.log("Valid:", result);
  } catch (err) {
    console.log(describeValidationError(err));
  }
}

tryValidate({ name: "", age: 30 });
tryValidate({ name: "Ada", age: "old" });
tryValidate({ name: "Ada", age: 30 });

// Confirm an unrelated error type is genuinely re-thrown, not swallowed.
try {
  describeValidationError(new TypeError("unrelated failure"));
} catch (err) {
  console.log("Correctly re-thrown, not described:", err.constructor.name, "-", err.message);
}
