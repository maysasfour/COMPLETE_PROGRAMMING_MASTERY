import { createContext, useContext, useReducer } from 'react'
import { cartReducer, initialCartState } from './cartReducer.js'

const CartContext = createContext(null)

export function CartProvider({ children }) {
  const [state, dispatch] = useReducer(cartReducer, initialCartState)
  return <CartContext.Provider value={{ state, dispatch }}>{children}</CartContext.Provider>
}

// Wrapping useContext in a custom hook that throws a clear error when used
// outside its provider turns a confusing "cannot read property of null" runtime
// error (that would otherwise surface deep inside whatever component misused it)
// into an immediate, actionable message pointing at the actual mistake.
export function useCart() {
  const context = useContext(CartContext)
  if (context === null) {
    throw new Error('useCart must be used within a CartProvider')
  }
  return context
}
