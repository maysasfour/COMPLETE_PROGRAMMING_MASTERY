// solution-04.ts - Partial/Pick/Omit for a typed patch API (Exercise 04)

interface User {
  id: number;
  name: string;
  email: string;
  age: number;
}

// The shape needed to create a user before an id is assigned by the store --
// deriving it from User with Omit means it can never drift out of sync with User's fields.
type CreateUserInput = Omit<User, "id">;

// Partial<Pick<User, ...>> is the type-level statement "any subset of these three fields,
// each optional" -- and critically, `id` is not even in the Pick, so `patch.id` is a
// compile error, not just a runtime one the caller has to remember not to do.
function updateUser(user: User, patch: Partial<Pick<User, "name" | "email" | "age">>): User {
  return { ...user, ...patch };
}

const newUserInput: CreateUserInput = {
  name: "Ada Lovelace",
  email: "ada@example.com",
  age: 28,
};

const user: User = { id: 1, ...newUserInput };
console.log("created:", user);

const afterEmailChange = updateUser(user, { email: "ada.lovelace@example.com" });
console.log("after email-only patch:", afterEmailChange);
console.log("original user untouched:", user);

const afterNameAndAgeChange = updateUser(user, { name: "Augusta Ada King", age: 29 });
console.log("after name+age patch:", afterNameAndAgeChange);
console.log("original user still untouched:", user);
