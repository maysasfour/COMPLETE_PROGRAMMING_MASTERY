// The same pure reducer pattern from Lesson 06, adapted to this project's
// product shape (fakestoreapi.com's `id`/`title`/`price`/`image`).
export const initialCartState = { items: [] }

export function cartReducer(state, action) {
  switch (action.type) {
    case 'ADD_ITEM': {
      const existing = state.items.find((item) => item.id === action.product.id)
      if (existing) {
        return {
          items: state.items.map((item) =>
            item.id === action.product.id ? { ...item, quantity: item.quantity + 1 } : item,
          ),
        }
      }
      return { items: [...state.items, { ...action.product, quantity: 1 }] }
    }

    case 'REMOVE_ITEM':
      return { items: state.items.filter((item) => item.id !== action.id) }

    case 'CLEAR_CART':
      return initialCartState

    default:
      throw new Error(`Unknown action type: ${action.type}`)
  }
}

export function cartTotal(state) {
  return state.items.reduce((sum, item) => sum + item.price * item.quantity, 0)
}

export function cartItemCount(state) {
  return state.items.reduce((sum, item) => sum + item.quantity, 0)
}
