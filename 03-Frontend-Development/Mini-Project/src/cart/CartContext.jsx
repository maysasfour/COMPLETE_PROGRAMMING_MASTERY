import { createContext, useContext, useReducer } from 'react'
import { cartReducer, initialCartState } from './cartReducer.js'

const CartContext = createContext(null)

export function CartProvider({ children }) {
  const [state, dispatch] = useReducer(cartReducer, initialCartState)
  return <CartContext.Provider value={{ state, dispatch }}>{children}</CartContext.Provider>
}

export function useCart() {
  const context = useContext(CartContext)
  if (context === null) {
    throw new Error('useCart must be used within a CartProvider')
  }
  return context
}
