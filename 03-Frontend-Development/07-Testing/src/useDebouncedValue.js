import { useEffect, useState } from 'react'

// Debouncing delays reacting to a fast-changing value until it's been STABLE
// for `delayMs` -- e.g., waiting until the user stops typing before firing a
// search request, instead of firing one request per keystroke. Each keystroke
// re-runs the effect, whose cleanup cancels the PREVIOUS pending timeout before
// starting a new one -- so only the timeout from the final keystroke ever
// actually fires and updates `debounced`.
export function useDebouncedValue(value, delayMs) {
  const [debounced, setDebounced] = useState(value)

  useEffect(() => {
    const timeoutId = setTimeout(() => setDebounced(value), delayMs)
    return () => clearTimeout(timeoutId)
  }, [value, delayMs])

  return debounced
}
