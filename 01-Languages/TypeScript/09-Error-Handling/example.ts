// example.ts - unknown-typed catch, custom Error subclasses with parameter properties, Result<T,E>.

console.log("--- catch is typed unknown, must narrow ---");
try {
  throw new Error("boom");
} catch (err) {
  if (err instanceof Error) {
    console.log("Narrowed to Error, message:", err.message);
  }
}

console.log("\n--- custom error class with a parameter property ---");
class ValidationError extends Error {
  constructor(message: string, public readonly field: string) {
    super(message);
    this.name = "ValidationError";
  }
}

function validateAge(age: number): number {
  if (age < 0) throw new ValidationError("Age cannot be negative", "age");
  return age;
}

function handle(fn: () => void) {
  try {
    fn();
  } catch (err) {
    if (err instanceof ValidationError) {
      console.log(`Validation failed on "${err.field}": ${err.message}`);
    } else if (err instanceof Error) {
      console.log("Unexpected error:", err.message);
    } else {
      throw err;
    }
  }
}
handle(() => validateAge(-5));

console.log("\n--- Result<T, E>: modeling failure without throwing ---");
type Result<T, E> = { ok: true; value: T } | { ok: false; error: E };

function parseAge(input: string): Result<number, string> {
  const parsed = Number(input);
  if (Number.isNaN(parsed) || parsed < 0) {
    return { ok: false, error: `"${input}" is not a valid age` };
  }
  return { ok: true, value: parsed };
}

function reportAge(input: string) {
  const result = parseAge(input);
  if (result.ok) {
    console.log(`Parsed age from "${input}":`, result.value);
  } else {
    console.log("Error:", result.error);
  }
}

reportAge("30");
reportAge("abc");
reportAge("-5");
