// Demonstrates: prop destructuring, a boolean prop driving conditional rendering
// (both the `&&` short-circuit form and the ternary form), and `children` -- the
// special prop React passes for whatever is nested between a component's JSX tags.
export function ProductCard({ name, price, inStock, children }) {
  return (
    <article className="product-card">
      <h3>{name}</h3>
      <p>${price.toFixed(2)}</p>

      {/* `&&` form: renders nothing at all when the condition is false, rather
          than rendering a visible "false" -- correct here because 0 is never a
          meaningful stock status, avoiding the classic "renders a literal 0" trap. */}
      {inStock && <span data-testid="stock-badge">In stock</span>}

      {/* ternary form: used instead of `&&` whenever BOTH branches must render
          something, since `&&` alone cannot express an else branch. */}
      <p>{inStock ? 'Ready to ship' : 'Currently unavailable'}</p>

      {children && <div className="description">{children}</div>}
    </article>
  )
}
