import { render, screen } from '@testing-library/react'
import { describe, expect, it } from 'vitest'
import { Greeting } from './Greeting.jsx'
import { ProductCard } from './ProductCard.jsx'
import { ProductList } from './ProductList.jsx'

describe('Greeting', () => {
  it('renders the name passed via props', () => {
    render(<Greeting name="Priya" timeOfDay="morning" />)
    expect(screen.getByText('Priya')).toBeInTheDocument()
    expect(screen.getByText(/good morning/i)).toBeInTheDocument()
  })

  it('falls back to the default timeOfDay when not provided', () => {
    render(<Greeting name="Sam" />)
    expect(screen.getByText(/good day/i)).toBeInTheDocument()
  })
})

describe('ProductCard', () => {
  it('shows the in-stock badge and "ready to ship" when inStock is true', () => {
    render(<ProductCard name="Keyboard" price={49.5} inStock={true} />)
    expect(screen.getByTestId('stock-badge')).toBeInTheDocument()
    expect(screen.getByText('Ready to ship')).toBeInTheDocument()
    expect(screen.getByText('$49.50')).toBeInTheDocument()
  })

  it('hides the badge and shows "unavailable" when inStock is false', () => {
    render(<ProductCard name="Mouse" price={0} inStock={false} />)
    expect(screen.queryByTestId('stock-badge')).not.toBeInTheDocument()
    expect(screen.getByText('Currently unavailable')).toBeInTheDocument()
  })

  it('renders children as a description block only when children are passed', () => {
    const { rerender, container } = render(
      <ProductCard name="Monitor" price={199} inStock={true}>
        A 27-inch display.
      </ProductCard>,
    )
    expect(screen.getByText('A 27-inch display.')).toBeInTheDocument()

    rerender(<ProductCard name="Monitor" price={199} inStock={true} />)
    expect(container.querySelector('.description')).toBeNull()
  })
})

describe('ProductList', () => {
  const products = [
    { id: 1, name: 'Keyboard', price: 49.5, inStock: true },
    { id: 2, name: 'Mouse', price: 19.99, inStock: false },
  ]

  it('renders one ProductCard per product', () => {
    render(<ProductList products={products} />)
    expect(screen.getByText('Keyboard')).toBeInTheDocument()
    expect(screen.getByText('Mouse')).toBeInTheDocument()
    expect(screen.getAllByRole('listitem')).toHaveLength(2)
  })

  it('shows a status message instead of a list when there are no products', () => {
    render(<ProductList products={[]} />)
    expect(screen.getByRole('status')).toHaveTextContent('No products to show.')
    expect(screen.queryAllByRole('listitem')).toHaveLength(0)
  })
})
