import { Link } from 'react-router-dom'
import { useFetch } from './useFetch.js'

export function UserList() {
  const { data: users, error, loading } = useFetch('https://jsonplaceholder.typicode.com/users')

  if (loading) return <p role="status">Loading users...</p>
  if (error) return <p role="alert">Failed to load users: {error}</p>

  return (
    <ul>
      {users.map((user) => (
        <li key={user.id}>
          <Link to={`/users/${user.id}`}>{user.name}</Link>
        </li>
      ))}
    </ul>
  )
}
