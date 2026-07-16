// example.js - HTTP requests using the built-in global fetch() (no axios/node-fetch install needed).
// Makes a real network call to the public jsonplaceholder.typicode.com test API,
// the same service used by the equivalent Python lesson, so results are directly comparable.

async function main() {
  console.log("--- GET https://jsonplaceholder.typicode.com/todos/1 ---");
  const getResponse = await fetch("https://jsonplaceholder.typicode.com/todos/1");
  console.log("status:", getResponse.status, getResponse.ok ? "(ok)" : "(NOT ok)");
  const todo = await getResponse.json();
  console.log("body:", todo);

  console.log("\n--- GET a route that returns 404 ---");
  const notFoundResponse = await fetch("https://jsonplaceholder.typicode.com/todos/99999999");
  console.log("status:", notFoundResponse.status, notFoundResponse.ok ? "(ok)" : "(NOT ok)");
  console.log(
    "fetch() does NOT throw on a 404/500 -- you must check response.ok yourself:",
    notFoundResponse.ok
  );

  console.log("\n--- POST with a JSON body ---");
  const postResponse = await fetch("https://jsonplaceholder.typicode.com/todos", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ title: "Learn fetch()", completed: false, userId: 1 }),
  });
  console.log("status:", postResponse.status);
  const created = await postResponse.json();
  console.log(
    "body (jsonplaceholder doesn't actually persist this -- it echoes the payload back with a fake new id):",
    created
  );

  console.log("\n--- handling a network-level failure (unreachable host) ---");
  try {
    await fetch("https://this-domain-does-not-exist-9182736.invalid/");
  } catch (err) {
    console.log("fetch() rejected the Promise for a genuine network failure:", err.constructor.name);
  }
}

main().catch((err) => {
  console.error("Unexpected error:", err);
  process.exitCode = 1;
});
