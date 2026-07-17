import { useEffect, useState } from 'react'
import { useDebouncedValue } from './useDebouncedValue.js'

// `onSearch` is called only once the debounced value settles -- this is the
// BEHAVIOR worth testing (how many times was the outside world notified, and
// with what final value), not the internal `query` state variable's name or
// how many times the component itself re-rendered while typing.
export function SearchBox({ onSearch, delayMs = 300 }) {
  const [query, setQuery] = useState('')
  const debouncedQuery = useDebouncedValue(query, delayMs)

  useEffect(() => {
    if (debouncedQuery.trim() !== '') {
      onSearch(debouncedQuery)
    }
  }, [debouncedQuery, onSearch])

  return (
    <input
      role="searchbox"
      aria-label="Search"
      value={query}
      onChange={(event) => setQuery(event.target.value)}
    />
  )
}
