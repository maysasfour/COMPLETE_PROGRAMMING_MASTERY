import { useEffect, useState } from 'react'

// A custom hook wrapping the Fetch API in the three-state pattern every data-
// fetching component needs: loading / error / data. The AbortController cleanup
// matters for the same reason the Stopwatch's clearInterval did in Lesson 03 --
// without it, a component that unmounts (e.g., the user navigates away) before
// the fetch resolves would still try to call setData/setError on a component
// that's gone, and in a component that re-fetches when its URL prop changes, an
// in-flight OLD request resolving after a NEWER one could overwrite fresh data
// with stale data -- aborting the old request when the effect re-runs prevents both.
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
        if (err.name === 'AbortError') return // expected on unmount/URL change, not a real error
        setError(err.message)
      })
      .finally(() => {
        // Without this guard, React StrictMode's dev-only double-invoke of
        // effects causes a real, reproduced bug: the first mount's effect
        // fires this fetch, is immediately cleaned up (aborting it), then the
        // effect mounts again for the fetch that actually completes. The
        // FIRST (aborted) call's .finally still ran and set loading=false
        // while data/error were both still null, crashing any consumer that
        // renders `data.map(...)` unconditionally once loading is false. Found
        // live in the Mini-Project capstone that reuses this exact hook.
        if (!controller.signal.aborted) {
          setLoading(false)
        }
      })

    return () => controller.abort()
  }, [url])

  return { data, error, loading }
}
