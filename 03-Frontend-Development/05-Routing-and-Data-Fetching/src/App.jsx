import { Route, Routes } from 'react-router-dom'
import { UserDetail } from './UserDetail.jsx'
import { UserList } from './UserList.jsx'

export function App() {
  return (
    <Routes>
      <Route path="/" element={<UserList />} />
      <Route path="/users/:id" element={<UserDetail />} />
      <Route path="*" element={<p>Page not found.</p>} />
    </Routes>
  )
}
