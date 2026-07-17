import { cartTotal } from '../cart/cartReducer.js'
import { useCart } from '../cart/CartContext.jsx'

export function CartPage() {
  const { state, dispatch } = useCart()

  if (state.items.length === 0) {
    return <p role="status">Your cart is empty.</p>
  }

  return (
    <div>
      <ul>
        {state.items.map((item) => (
          <li key={item.id}>
            {item.title} × {item.quantity} — ${(item.price * item.quantity).toFixed(2)}
            <button onClick={() => dispatch({ type: 'REMOVE_ITEM', id: item.id })}>
              Remove
            </button>
          </li>
        ))}
      </ul>
      <p data-testid="cart-page-total">Total: ${cartTotal(state).toFixed(2)}</p>
      <button onClick={() => dispatch({ type: 'CLEAR_CART' })}>Clear cart</button>
    </div>
  )
}
