import { Link, useParams } from 'react-router-dom'
import { useCart } from '../cart/CartContext.jsx'
import { useFetch } from '../useFetch.js'

export function ProductDetail() {
  const { id } = useParams()
  const { data: product, error, loading } = useFetch(`https://fakestoreapi.com/products/${id}`)
  const { dispatch } = useCart()

  return (
    <div>
      <Link to="/">Back to products</Link>
      {loading && <p role="status">Loading product...</p>}
      {error && <p role="alert">Failed to load product: {error}</p>}
      {product && (
        <div>
          <h2>{product.title}</h2>
          <p>{product.description}</p>
          <p>${product.price.toFixed(2)}</p>
          <button onClick={() => dispatch({ type: 'ADD_ITEM', product })}>Add to cart</button>
        </div>
      )}
    </div>
  )
}
