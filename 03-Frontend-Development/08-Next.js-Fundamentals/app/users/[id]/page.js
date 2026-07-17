import Link from 'next/link'
import { notFound } from 'next/navigation'

// `params` is a PROMISE in this Next.js version (16.2.10) -- a genuine breaking
// change from older Next.js docs/training data, where params used to be a plain
// synchronous object. Confirmed against this project's own bundled docs
// (node_modules/next/dist/docs/01-app/03-api-reference/03-file-conventions/dynamic-routes.md)
// before writing this: `const { id } = await params` is required now.
export default async function UserDetailPage({ params }) {
  const { id } = await params

  const res = await fetch(`https://jsonplaceholder.typicode.com/users/${id}`, {
    cache: 'no-store',
  })

  if (!res.ok) {
    notFound() // renders this route segment's not-found.js (or the default 404)
  }

  const user = await res.json()

  return (
    <main>
      <Link href="/">Back to list</Link>
      <h1>{user.name}</h1>
      <p>{user.email}</p>
      <p>{user.company?.name}</p>
    </main>
  )
}
