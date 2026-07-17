import { Link, useParams } from 'react-router-dom'
import { useFetch } from './useFetch.js'

export function UserDetail() {
  // useParams reads dynamic segments from the current URL -- the route is
  // registered as "/users/:id" (see App.jsx), so visiting /users/3 makes
  // params.id === "3" here.
  const { id } = useParams()
  const { data: user, error, loading } = useFetch(`https://jsonplaceholder.typicode.com/users/${id}`)

  return (
    <div>
      <Link to="/">Back to list</Link>
      {loading && <p role="status">Loading user...</p>}
      {error && <p role="alert">Failed to load user: {error}</p>}
      {user && (
        <div>
          <h2>{user.name}</h2>
          <p>{user.email}</p>
          <p>{user.company?.name}</p>
        </div>
      )}
    </div>
  )
}
