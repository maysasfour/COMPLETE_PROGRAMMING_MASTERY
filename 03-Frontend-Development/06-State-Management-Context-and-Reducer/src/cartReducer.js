// A reducer is a pure function: (state, action) => newState. "Pure" means no
// side effects and no mutation -- given the same state and action, it always
// returns the same new state, which is exactly why it can be unit-tested with
// zero rendering at all (see cartReducer.test.js). useReducer is preferable to
// several useState calls once updates start depending on each other in ways
// that are easy to get inconsistent (e.g., "increase quantity" needing to also
// decide whether the item already exists) -- centralizing that logic in one
// place makes the valid state transitions explicit and exhaustive.
export const initialCartState = { items: [] }

export function cartReducer(state, action) {
  switch (action.type) {
    case 'ADD_ITEM': {
      const existing = state.items.find((item) => item.id === action.item.id)
      if (existing) {
        return {
          items: state.items.map((item) =>
            item.id === action.item.id ? { ...item, quantity: item.quantity + 1 } : item,
          ),
        }
      }
      return { items: [...state.items, { ...action.item, quantity: 1 }] }
    }

    case 'REMOVE_ITEM':
      return { items: state.items.filter((item) => item.id !== action.id) }

    case 'UPDATE_QUANTITY':
      if (action.quantity <= 0) {
        return { items: state.items.filter((item) => item.id !== action.id) }
      }
      return {
        items: state.items.map((item) =>
          item.id === action.id ? { ...item, quantity: action.quantity } : item,
        ),
      }

    case 'CLEAR_CART':
      return initialCartState

    default:
      throw new Error(`Unknown action type: ${action.type}`)
  }
}

export function cartTotal(state) {
  return state.items.reduce((sum, item) => sum + item.price * item.quantity, 0)
}
