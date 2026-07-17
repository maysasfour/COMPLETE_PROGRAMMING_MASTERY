import { render, screen, waitFor } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest'
import { App } from './App.jsx'

// These tests mock global.fetch for determinism and speed -- a real, live network
// call to jsonplaceholder.typicode.com IS also exercised separately (see
// `verify-live-fetch.mjs` and this lesson's README), matching the standard testing
// pyramid: fast, deterministic unit tests here, one real integration check
// alongside them, rather than making every test depend on network availability.

const usersResponse = [
  { id: 1, name: 'Leanne Graham' },
  { id: 2, name: 'Ervin Howell' },
]

const userDetailResponse = {
  id: 1,
  name: 'Leanne Graham',
  email: 'Sincere@april.biz',
  company: { name: 'Romaguera-Crona' },
}

function mockFetchOnce(body, ok = true, status = 200) {
  global.fetch = vi.fn().mockResolvedValue({
    ok,
    status,
    json: () => Promise.resolve(body),
  })
}

function renderAt(path) {
  return render(
    <MemoryRouter initialEntries={[path]}>
      <App />
    </MemoryRouter>,
  )
}

describe('routing + data fetching', () => {
  afterEach(() => {
    vi.restoreAllMocks()
  })

  it('shows a loading state, then the user list once the fetch resolves', async () => {
    mockFetchOnce(usersResponse)
    renderAt('/')

    expect(screen.getByRole('status')).toHaveTextContent('Loading users...')

    await waitFor(() => expect(screen.getByText('Leanne Graham')).toBeInTheDocument())
    expect(screen.getByText('Ervin Howell')).toBeInTheDocument()
  })

  it('shows an alert when the users request fails', async () => {
    mockFetchOnce({}, false, 500)
    renderAt('/')

    await waitFor(() =>
      expect(screen.getByRole('alert')).toHaveTextContent('Failed to load users: Request failed: 500'),
    )
  })

  it('renders the detail route directly via useParams and fetches that specific user', async () => {
    mockFetchOnce(userDetailResponse)
    renderAt('/users/1')

    await waitFor(() => expect(screen.getByText('Leanne Graham')).toBeInTheDocument())
    expect(screen.getByText('Sincere@april.biz')).toBeInTheDocument()
    expect(screen.getByText('Romaguera-Crona')).toBeInTheDocument()
    expect(fetch).toHaveBeenCalledWith(
      'https://jsonplaceholder.typicode.com/users/1',
      expect.anything(),
    )
  })

  it('shows a not-found message for an unmatched route', () => {
    mockFetchOnce(usersResponse)
    renderAt('/this-route-does-not-exist')
    expect(screen.getByText('Page not found.')).toBeInTheDocument()
  })
})
