// solution-03.ts - Result<T, E> validation pipeline chained with andThen (Exercise 03)

type Result<T, E> = { ok: true; value: T } | { ok: false; error: E };

function ok<T>(value: T): Result<T, never> {
  return { ok: true, value };
}
function err<E>(error: E): Result<never, E> {
  return { ok: false, error };
}

// `andThen` is what turns three separate `if (!result.ok) return result` checks into a
// single chain -- each validator only runs if every validator before it already succeeded.
function andThen<T, U, E>(
  result: Result<T, E>,
  fn: (value: T) => Result<U, E>
): Result<U, E> {
  return result.ok ? fn(result.value) : result;
}

function validateUsername(input: string): Result<string, string> {
  if (input.length === 0) return err("Username cannot be empty");
  if (/\s/.test(input)) return err("Username cannot contain whitespace");
  return ok(input);
}

function validateEmail(input: string): Result<string, string> {
  const at = input.indexOf("@");
  if (at === -1 || input.indexOf(".", at) === -1) {
    return err(`"${input}" is not a valid email`);
  }
  return ok(input);
}

function validatePassword(input: string): Result<string, string> {
  if (input.length < 8) return err("Password must be at least 8 characters");
  return ok(input);
}

interface SignupData {
  username: string;
  email: string;
  password: string;
}

function signup(username: string, email: string, password: string): Result<SignupData, string> {
  return andThen(validateUsername(username), (validUsername) =>
    andThen(validateEmail(email), (validEmail) =>
      andThen(validatePassword(password), (validPassword) =>
        ok({ username: validUsername, email: validEmail, password: validPassword })
      )
    )
  );
}

function report(label: string, result: Result<SignupData, string>) {
  if (result.ok) {
    console.log(`${label}: OK ->`, result.value);
  } else {
    console.log(`${label}: FAILED -> ${result.error}`);
  }
}

report("valid signup", signup("ada", "ada@example.com", "correcthorse"));
report("bad username (whitespace)", signup("ada lovelace", "ada@example.com", "correcthorse"));
report("bad email (no dot after @)", signup("ada", "ada@examplecom", "correcthorse"));
report("bad password (too short)", signup("ada", "ada@example.com", "short"));
