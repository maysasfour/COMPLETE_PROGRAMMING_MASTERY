import { render, screen } from '@testing-library/react'
import { fireEvent } from '@testing-library/react'
import { describe, expect, it } from 'vitest'
import { CartProvider, useCart } from './CartContext.jsx'
import { CartSummary } from './CartSummary.jsx'
import { ProductGrid } from './ProductGrid.jsx'

describe('CartProvider sharing state across unrelated sibling components', () => {
  it('lets ProductGrid and CartSummary -- siblings, not parent/child -- share cart state with zero props between them', () => {
    render(
      <CartProvider>
        <ProductGrid />
        <CartSummary />
      </CartProvider>,
    )

    expect(screen.getByRole('status')).toHaveTextContent('Cart is empty.')

    fireEvent.click(screen.getAllByText('Add to cart')[0]) // adds the Keyboard from ProductGrid
    expect(screen.getByTestId('cart-total')).toHaveTextContent('Total: $49.50')

    fireEvent.click(screen.getAllByText('Add to cart')[1]) // adds the Mouse
    expect(screen.getByTestId('cart-total')).toHaveTextContent('Total: $69.49')

    fireEvent.click(screen.getByText('Clear cart'))
    expect(screen.getByRole('status')).toHaveTextContent('Cart is empty.')
  })

  it('useCart throws a clear error when used outside a CartProvider', () => {
    function BrokenComponent() {
      useCart()
      return null
    }

    // React logs its own error boundary noise to the console for a thrown render;
    // suppressing it here keeps the test output focused on what's actually being verified.
    const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {})
    expect(() => render(<BrokenComponent />)).toThrow('useCart must be used within a CartProvider')
    consoleSpy.mockRestore()
  })
})
