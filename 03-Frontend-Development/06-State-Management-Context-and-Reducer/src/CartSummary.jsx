import { cartTotal } from './cartReducer.js'
import { useCart } from './CartContext.jsx'

export function CartSummary() {
  const { state, dispatch } = useCart()

  if (state.items.length === 0) {
    return <p role="status">Cart is empty.</p>
  }

  return (
    <div>
      <ul>
        {state.items.map((item) => (
          <li key={item.id}>
            {item.name} × {item.quantity}
            <button
              onClick={() =>
                dispatch({ type: 'UPDATE_QUANTITY', id: item.id, quantity: item.quantity - 1 })
              }
              aria-label={`Decrease ${item.name}`}
            >
              -
            </button>
          </li>
        ))}
      </ul>
      <p data-testid="cart-total">Total: ${cartTotal(state).toFixed(2)}</p>
      <button onClick={() => dispatch({ type: 'CLEAR_CART' })}>Clear cart</button>
    </div>
  )
}
