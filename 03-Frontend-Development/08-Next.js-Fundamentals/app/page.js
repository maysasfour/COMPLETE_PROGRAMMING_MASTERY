import Link from 'next/link'

// A Server Component: this function runs on the SERVER, not in the browser --
// note there's no useState/useEffect/loading-state dance like Lesson 05's
// UserList needed. `await fetch(...)` happens before any HTML is ever sent to
// the client, so the response already contains the real, populated list --
// verified below by curling the SSR'd HTML directly, no headless browser needed
// (unlike Lesson 01's Vite SPA, whose initial HTML is just an empty <div id="root">).
export default async function HomePage() {
  const res = await fetch('https://jsonplaceholder.typicode.com/users', {
    cache: 'no-store', // always fetch fresh for this lesson's demo, rather than caching the response
  })
  const users = await res.json()

  return (
    <main>
      <h1>Users (fetched server-side)</h1>
      <ul>
        {users.map((user) => (
          <li key={user.id}>
            <Link href={`/users/${user.id}`}>{user.name}</Link>
          </li>
        ))}
      </ul>
    </main>
  )
}
