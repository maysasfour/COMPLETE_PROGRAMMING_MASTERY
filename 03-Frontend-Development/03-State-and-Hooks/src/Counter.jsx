import { useState } from 'react'

// The functional-update form `setCount(c => c + 1)` (rather than `setCount(count + 1)`)
// matters specifically when multiple updates can be queued before a re-render --
// it guarantees each update sees the LATEST state, not a stale value captured by
// the closure from when the event handler was created.
export function Counter({ initialValue = 0, step = 1 }) {
  const [count, setCount] = useState(initialValue)

  return (
    <div>
      <p data-testid="count">{count}</p>
      <button onClick={() => setCount((c) => c - step)}>-</button>
      <button onClick={() => setCount((c) => c + step)}>+</button>
      <button onClick={() => setCount(initialValue)}>Reset</button>
    </div>
  )
}
