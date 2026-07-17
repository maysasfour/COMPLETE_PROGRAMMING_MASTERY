import { Link } from 'react-router-dom'
import { cartItemCount, cartTotal } from '../cart/cartReducer.js'
import { useCart } from '../cart/CartContext.jsx'

// Lives in the nav, entirely unrelated as a component to ProductList/ProductDetail
// (neither parent nor child) -- it stays in sync with them purely through
// CartContext, the same cross-sibling pattern proven in Lesson 06, now doing
// real work across actual route changes rather than just two sibling divs.
export function CartWidget() {
  const { state } = useCart()
  const count = cartItemCount(state)

  return (
    <Link to="/cart" data-testid="cart-widget">
      Cart ({count}) — ${cartTotal(state).toFixed(2)}
    </Link>
  )
}
