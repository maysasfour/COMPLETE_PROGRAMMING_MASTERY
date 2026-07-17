import { useEffect, useState } from 'react'

// The same reusable data-fetching hook from Lesson 05, brought into this
// capstone project unchanged -- proving it really was written generically
// enough to reuse, not tied to that lesson's specific User shape.
export function useFetch(url) {
  const [data, setData] = useState(null)
  const [error, setError] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const controller = new AbortController()
    setLoading(true)
    setError(null)

    fetch(url, { signal: controller.signal })
      .then((response) => {
        if (!response.ok) {
          throw new Error(`Request failed: ${response.status}`)
        }
        return response.json()
      })
      .then((json) => setData(json))
      .catch((err) => {
        if (err.name === 'AbortError') return
        setError(err.message)
      })
      .finally(() => {
        // Guard against a real bug found while writing this project: React's
        // StrictMode dev-only double-invoke of effects mounts this effect,
        // immediately cleans it up (aborting THIS fetch), then mounts it again
        // for the fetch that actually completes. Without this guard, the
        // FIRST (aborted) call's .finally still fired and set loading=false
        // while data was still null and error was still null (an AbortError
        // is caught above and intentionally not treated as a real error) --
        // the component then rendered `data.map(...)` against a null data,
        // a genuine crash reproduced live during manual browser verification.
        if (!controller.signal.aborted) {
          setLoading(false)
        }
      })

    return () => controller.abort()
  }, [url])

  return { data, error, loading }
}
