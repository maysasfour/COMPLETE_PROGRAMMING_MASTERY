import { Link, Route, Routes } from 'react-router-dom'
import { CartWidget } from './components/CartWidget.jsx'
import { CartProvider } from './cart/CartContext.jsx'
import { CartPage } from './pages/CartPage.jsx'
import { ProductDetail } from './pages/ProductDetail.jsx'
import { ProductList } from './pages/ProductList.jsx'

export function App() {
  return (
    <CartProvider>
      <nav>
        <Link to="/">Store</Link>
        <CartWidget />
      </nav>
      <Routes>
        <Route path="/" element={<ProductList />} />
        <Route path="/products/:id" element={<ProductDetail />} />
        <Route path="/cart" element={<CartPage />} />
        <Route path="*" element={<p>Page not found.</p>} />
      </Routes>
    </CartProvider>
  )
}
