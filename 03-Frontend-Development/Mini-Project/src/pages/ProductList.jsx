import { Link } from 'react-router-dom'
import { useCart } from '../cart/CartContext.jsx'
import { useFetch } from '../useFetch.js'

export function ProductList() {
  const { data: products, error, loading } = useFetch('https://fakestoreapi.com/products?limit=8')
  const { dispatch } = useCart()

  if (loading) return <p role="status">Loading products...</p>
  if (error) return <p role="alert">Failed to load products: {error}</p>

  return (
    <ul className="product-grid">
      {products.map((product) => (
        <li key={product.id}>
          <Link to={`/products/${product.id}`}>{product.title}</Link>
          <p>${product.price.toFixed(2)}</p>
          <button onClick={() => dispatch({ type: 'ADD_ITEM', product })}>Add to cart</button>
        </li>
      ))}
    </ul>
  )
}
