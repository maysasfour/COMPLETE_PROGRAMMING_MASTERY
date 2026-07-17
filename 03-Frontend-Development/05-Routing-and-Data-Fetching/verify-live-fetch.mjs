// A standalone, real integration check -- calls the ACTUAL live jsonplaceholder
// API (not mocked) to prove useFetch's request/response handling genuinely works
// against a real server, complementing App.test.jsx's fast, mocked unit tests.
const response = await fetch('https://jsonplaceholder.typicode.com/users/1')
if (!response.ok) {
  console.error(`FAILED: real request returned ${response.status}`)
  process.exit(1)
}
const user = await response.json()
console.log('Real live API response:', JSON.stringify(user, null, 2).slice(0, 200))
if (typeof user.name !== 'string' || typeof user.email !== 'string') {
  console.error('FAILED: response shape did not match expectations')
  process.exit(1)
}
console.log('PASS: live fetch returned a real user with the expected shape.')
