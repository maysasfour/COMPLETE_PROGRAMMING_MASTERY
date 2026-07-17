import { useState, useCallback } from 'react'

// A custom hook is just a regular function that calls other hooks -- the "use"
// prefix is a convention React's linter relies on, not special syntax. Extracting
// this logic out of Counter.jsx lets it be reused by any component (or tested in
// total isolation, as components.test.jsx does) without duplicating the useState
// call and the three handlers everywhere it's needed.
export function useCounter(initialValue = 0, step = 1) {
  const [count, setCount] = useState(initialValue)

  const increment = useCallback(() => setCount((c) => c + step), [step])
  const decrement = useCallback(() => setCount((c) => c - step), [step])
  const reset = useCallback(() => setCount(initialValue), [initialValue])

  return { count, increment, decrement, reset }
}
