import { describe, expect, it } from 'vitest'
import { cartReducer, cartTotal, initialCartState } from './cartReducer.js'

const keyboard = { id: 1, name: 'Keyboard', price: 50 }
const mouse = { id: 2, name: 'Mouse', price: 20 }

describe('cartReducer (pure function, no rendering needed)', () => {
  it('adds a new item with quantity 1', () => {
    const state = cartReducer(initialCartState, { type: 'ADD_ITEM', item: keyboard })
    expect(state.items).toEqual([{ ...keyboard, quantity: 1 }])
  })

  it('increments quantity when adding an item already in the cart', () => {
    let state = cartReducer(initialCartState, { type: 'ADD_ITEM', item: keyboard })
    state = cartReducer(state, { type: 'ADD_ITEM', item: keyboard })
    expect(state.items).toEqual([{ ...keyboard, quantity: 2 }])
  })

  it('does not mutate the state object passed in', () => {
    const before = { items: [{ ...keyboard, quantity: 1 }] }
    const beforeItemsRef = before.items
    const after = cartReducer(before, { type: 'ADD_ITEM', item: mouse })

    expect(before.items).toBe(beforeItemsRef) // original array reference untouched
    expect(after.items).not.toBe(before.items) // a genuinely new array was returned
    expect(before.items).toHaveLength(1) // original wasn't grown in place
  })

  it('removes an item entirely via UPDATE_QUANTITY reaching zero', () => {
    let state = cartReducer(initialCartState, { type: 'ADD_ITEM', item: keyboard })
    state = cartReducer(state, { type: 'UPDATE_QUANTITY', id: keyboard.id, quantity: 0 })
    expect(state.items).toEqual([])
  })

  it('CLEAR_CART returns to the initial empty state', () => {
    let state = cartReducer(initialCartState, { type: 'ADD_ITEM', item: keyboard })
    state = cartReducer(state, { type: 'ADD_ITEM', item: mouse })
    state = cartReducer(state, { type: 'CLEAR_CART' })
    expect(state).toEqual(initialCartState)
  })

  it('throws on an unknown action type rather than silently ignoring it', () => {
    expect(() => cartReducer(initialCartState, { type: 'NOT_REAL' })).toThrow(
      'Unknown action type: NOT_REAL',
    )
  })

  it('cartTotal sums price * quantity across all items', () => {
    const state = { items: [{ ...keyboard, quantity: 2 }, { ...mouse, quantity: 3 }] }
    expect(cartTotal(state)).toBe(50 * 2 + 20 * 3)
  })
})
