import { ProductCard } from './ProductCard.jsx'

// Demonstrates: rendering a list via .map(), and why each element needs a stable
// `key` prop -- React uses it to match array items across re-renders (deciding
// what to update/move/remove) rather than re-rendering the whole list from
// scratch. The key must come from the DATA (here, `id`), never the array index --
// an index-based key breaks the moment items are reordered or one is removed
// from the middle, because React would then match the wrong item to the wrong key.
export function ProductList({ products }) {
  if (products.length === 0) {
    return <p role="status">No products to show.</p>
  }

  return (
    <ul>
      {products.map((product) => (
        <li key={product.id}>
          <ProductCard name={product.name} price={product.price} inStock={product.inStock} />
        </li>
      ))}
    </ul>
  )
}
