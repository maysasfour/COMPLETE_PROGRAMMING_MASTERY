import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { afterEach, describe, expect, it, vi } from 'vitest'
import { App } from './App.jsx'

// Mocked fetch for fast, deterministic tests -- the live API is checked
// separately, for real, via verify-live-fetch.mjs (see this project's README).

const productsResponse = [
  { id: 1, title: 'T-Shirt', price: 20, image: 'x' },
  { id: 2, title: 'Backpack', price: 110, image: 'x' },
]

const productDetailResponse = {
  id: 1,
  title: 'T-Shirt',
  price: 20,
  description: 'A plain t-shirt.',
  image: 'x',
}

function mockFetch(body) {
  global.fetch = vi.fn().mockResolvedValue({
    ok: true,
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

describe('Mini-Project — the whole app working together', () => {
  afterEach(() => vi.restoreAllMocks())

  it('shows real products fetched from the (mocked) API, and the cart widget starts at 0', async () => {
    mockFetch(productsResponse)
    renderAt('/')

    expect(screen.getByTestId('cart-widget')).toHaveTextContent('Cart (0) — $0.00')
    await waitFor(() => expect(screen.getByText('T-Shirt')).toBeInTheDocument())
    expect(screen.getByText('Backpack')).toBeInTheDocument()
  })

  it('adding a product from the LIST page updates the cart widget in the NAV -- unrelated components, sharing state only via Context, across a route that could change', async () => {
    mockFetch(productsResponse)
    renderAt('/')

    await waitFor(() => expect(screen.getByText('T-Shirt')).toBeInTheDocument())
    fireEvent.click(screen.getAllByText('Add to cart')[0])

    expect(screen.getByTestId('cart-widget')).toHaveTextContent('Cart (1) — $20.00')
  })

  it('renders the product detail route via useParams, fetches that specific product, and adding it there ALSO updates the shared cart', async () => {
    mockFetch(productDetailResponse)
    renderAt('/products/1')

    await waitFor(() => expect(screen.getByText('T-Shirt')).toBeInTheDocument())
    expect(screen.getByText('A plain t-shirt.')).toBeInTheDocument()

    fireEvent.click(screen.getByText('Add to cart'))
    expect(screen.getByTestId('cart-widget')).toHaveTextContent('Cart (1) — $20.00')
  })

  it('the cart page shows an empty-state message when nothing has been added yet', () => {
    mockFetch(productsResponse)
    renderAt('/cart')
    expect(screen.getByRole('status')).toHaveTextContent('Your cart is empty.')
  })

  it('full flow: add a product on the list page, click through to /cart via a real Link, see it, remove it, see the empty state again', async () => {
    mockFetch(productsResponse)
    renderAt('/')

    await waitFor(() => expect(screen.getByText('T-Shirt')).toBeInTheDocument())
    fireEvent.click(screen.getAllByText('Add to cart')[0])

    // A real client-side navigation via the actual <Link> in the nav --
    // CartProvider wraps <Routes> in App.jsx, so its state survives the route
    // change exactly like Lesson 06's Context proved across sibling components,
    // now proven across a route change too.
    fireEvent.click(screen.getByTestId('cart-widget'))

    expect(await screen.findByText(/T-Shirt × 1/)).toBeInTheDocument()
    expect(screen.getByTestId('cart-page-total')).toHaveTextContent('Total: $20.00')

    fireEvent.click(screen.getByText('Remove'))
    expect(screen.getByRole('status')).toHaveTextContent('Your cart is empty.')
  })
})
