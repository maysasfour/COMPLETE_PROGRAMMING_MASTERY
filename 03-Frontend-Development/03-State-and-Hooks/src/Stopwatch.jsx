import { useEffect, useState } from 'react'

// Demonstrates useEffect with a cleanup function -- the returned function from
// the effect callback. React calls it right before the effect re-runs, AND when
// the component unmounts. Without it, the setInterval would keep firing forever
// after the component is gone (a real, common memory/CPU leak), still trying to
// call setElapsed on a component that no longer exists.
export function Stopwatch({ running }) {
  const [elapsed, setElapsed] = useState(0)

  useEffect(() => {
    if (!running) return

    const intervalId = setInterval(() => {
      setElapsed((s) => s + 1)
    }, 1000)

    return () => clearInterval(intervalId)
  }, [running])

  return <p data-testid="elapsed">{elapsed}s elapsed</p>
}
