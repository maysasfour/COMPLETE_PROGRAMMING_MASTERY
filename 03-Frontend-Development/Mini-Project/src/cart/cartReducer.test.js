import { describe, expect, it } from 'vitest'
import { cartItemCount, cartReducer, cartTotal, initialCartState } from './cartReducer.js'

const shirt = { id: 1, title: 'T-Shirt', price: 20 }
const backpack = { id: 2, title: 'Backpack', price: 110 }

describe('cartReducer (pure function)', () => {
  it('adds a new product with quantity 1', () => {
    const state = cartReducer(initialCartState, { type: 'ADD_ITEM', product: shirt })
    expect(state.items).toEqual([{ ...shirt, quantity: 1 }])
  })

  it('increments quantity for a product already in the cart', () => {
    let state = cartReducer(initialCartState, { type: 'ADD_ITEM', product: shirt })
    state = cartReducer(state, { type: 'ADD_ITEM', product: shirt })
    expect(state.items).toEqual([{ ...shirt, quantity: 2 }])
  })

  it('removes an item entirely via REMOVE_ITEM', () => {
    let state = cartReducer(initialCartState, { type: 'ADD_ITEM', product: shirt })
    state = cartReducer(state, { type: 'REMOVE_ITEM', id: shirt.id })
    expect(state.items).toEqual([])
  })

  it('cartTotal and cartItemCount compute correctly across multiple products', () => {
    let state = cartReducer(initialCartState, { type: 'ADD_ITEM', product: shirt })
    state = cartReducer(state, { type: 'ADD_ITEM', product: shirt })
    state = cartReducer(state, { type: 'ADD_ITEM', product: backpack })

    expect(cartItemCount(state)).toBe(3) // 2 shirts + 1 backpack
    expect(cartTotal(state)).toBe(20 * 2 + 110)
  })

  it('CLEAR_CART resets to the initial empty state', () => {
    let state = cartReducer(initialCartState, { type: 'ADD_ITEM', product: shirt })
    state = cartReducer(state, { type: 'CLEAR_CART' })
    expect(state).toEqual(initialCartState)
  })
})
