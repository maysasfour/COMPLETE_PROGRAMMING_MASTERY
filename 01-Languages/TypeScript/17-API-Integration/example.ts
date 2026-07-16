// example.ts - typed fetch() usage with a validating helper against a real public test API.

interface Todo {
  userId: number;
  id: number;
  title: string;
  completed: boolean;
}

function isTodo(value: unknown): value is Todo {
  return (
    typeof value === "object" &&
    value !== null &&
    typeof (value as Todo).userId === "number" &&
    typeof (value as Todo).id === "number" &&
    typeof (value as Todo).title === "string" &&
    typeof (value as Todo).completed === "boolean"
  );
}

async function fetchTodo(id: number): Promise<Todo> {
  const response = await fetch(`https://jsonplaceholder.typicode.com/todos/${id}`);
  if (!response.ok) {
    throw new Error(`Request failed with status ${response.status}`);
  }
  const data: unknown = await response.json(); // response.json() returns Promise<any> -- widen to unknown
  if (!isTodo(data)) {
    throw new Error("Response did not match the expected Todo shape");
  }
  return data;
}

async function main() {
  console.log("--- typed, validated GET ---");
  const todo = await fetchTodo(1);
  console.log("Fetched and validated Todo:", todo);
  console.log("todo.title.toUpperCase():", todo.title.toUpperCase()); // safe: genuinely typed as Todo

  console.log("\n--- fetch() does not throw on 404 -- same trap as the JS course ---");
  const notFoundResponse = await fetch("https://jsonplaceholder.typicode.com/todos/99999999");
  console.log("status:", notFoundResponse.status, "ok:", notFoundResponse.ok);

  console.log("\n--- validation rejecting a genuinely wrong shape ---");
  const fakeWrongShape: unknown = { userId: "not-a-number", id: 1, title: "x", completed: false };
  console.log("isTodo(fakeWrongShape):", isTodo(fakeWrongShape));
}

main().catch((err) => {
  console.error("Unexpected error:", err);
  process.exitCode = 1;
});
