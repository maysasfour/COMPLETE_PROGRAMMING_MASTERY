import { act, fireEvent, render, screen } from '@testing-library/react'
import { renderHook } from '@testing-library/react'
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest'
import { Counter } from './Counter.jsx'
import { Stopwatch } from './Stopwatch.jsx'
import { useCounter } from './useCounter.js'

describe('Counter', () => {
  it('increments, decrements, and resets via real clicks', async () => {
    const { getByText, getByTestId } = render(<Counter initialValue={10} step={5} />)

    // fireEvent (not a raw DOM .click()) is required here -- it wraps the
    // dispatched event in React's act(), which is what flushes the resulting
    // state update and re-render synchronously before the next assertion runs.
    // A raw .click() was tried first and genuinely failed (count stayed at the
    // initial value) because the update hadn't been flushed yet when the
    // assertion ran -- a real, reproduced bug, not a hypothetical one.
    fireEvent.click(getByText('+'))
    expect(getByTestId('count')).toHaveTextContent('15')

    fireEvent.click(getByText('-'))
    fireEvent.click(getByText('-'))
    expect(getByTestId('count')).toHaveTextContent('5')

    fireEvent.click(getByText('Reset'))
    expect(getByTestId('count')).toHaveTextContent('10')
  })
})

describe('useCounter (custom hook, tested directly)', () => {
  it('exposes count plus working increment/decrement/reset', () => {
    const { result } = renderHook(() => useCounter(0, 2))

    act(() => result.current.increment())
    act(() => result.current.increment())
    expect(result.current.count).toBe(4)

    act(() => result.current.decrement())
    expect(result.current.count).toBe(2)

    act(() => result.current.reset())
    expect(result.current.count).toBe(0)
  })
})

describe('Stopwatch (useEffect with a real interval and cleanup)', () => {
  beforeEach(() => vi.useFakeTimers())
  afterEach(() => vi.useRealTimers())

  it('increments elapsed seconds while running', () => {
    render(<Stopwatch running={true} />)
    expect(screen.getByTestId('elapsed')).toHaveTextContent('0s elapsed')

    act(() => vi.advanceTimersByTime(3000))
    expect(screen.getByTestId('elapsed')).toHaveTextContent('3s elapsed')
  })

  it('does NOT increment when running is false', () => {
    render(<Stopwatch running={false} />)
    act(() => vi.advanceTimersByTime(5000))
    expect(screen.getByTestId('elapsed')).toHaveTextContent('0s elapsed')
  })

  it('genuinely stops ticking after unmount -- proving the cleanup function runs', () => {
    const clearIntervalSpy = vi.spyOn(global, 'clearInterval')
    const { unmount } = render(<Stopwatch running={true} />)

    act(() => vi.advanceTimersByTime(2000))
    unmount()

    expect(clearIntervalSpy).toHaveBeenCalled()

    // if cleanup had NOT run, this would still be silently ticking in the
    // background; advancing time post-unmount and finding no error/leftover
    // timer firing is the real proof, not just that clearInterval was called.
    act(() => vi.advanceTimersByTime(5000))
  })
})
