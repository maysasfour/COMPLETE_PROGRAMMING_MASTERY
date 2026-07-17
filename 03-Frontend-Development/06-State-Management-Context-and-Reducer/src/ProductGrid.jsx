import { useCart } from './CartContext.jsx'

const products = [
  { id: 1, name: 'Keyboard', price: 49.5 },
  { id: 2, name: 'Mouse', price: 19.99 },
]

// This component only ADDS items -- it never reads the cart total. It shares
// state with CartSummary (a completely unrelated sibling, not a parent or
// child) purely through useCart()'s shared context, with zero props passed
// between them -- the entire point of Context over prop drilling.
export function ProductGrid() {
  const { dispatch } = useCart()

  return (
    <ul>
      {products.map((product) => (
        <li key={product.id}>
          {product.name} — ${product.price.toFixed(2)}
          <button onClick={() => dispatch({ type: 'ADD_ITEM', item: product })}>
            Add to cart
          </button>
        </li>
      ))}
    </ul>
  )
}
