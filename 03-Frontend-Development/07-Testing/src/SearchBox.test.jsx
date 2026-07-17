import { act, fireEvent, render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest'
import { SearchBox } from './SearchBox.jsx'

describe('SearchBox — query priority', () => {
  it('is found via getByRole, the PREFERRED query (matches how a screen reader/real user finds it), not a test-id', () => {
    render(<SearchBox onSearch={() => {}} />)
    // Testing Library's own query priority, from most to least preferred:
    // getByRole > getByLabelText > getByPlaceholderText > getByText > getByTestId.
    // getByRole is preferred because it only passes if the element is ALSO
    // accessible the same way a screen reader/keyboard user would find it --
    // a getByTestId query would still pass even on a <div> with no real
    // semantics, hiding an accessibility bug a getByRole query would catch.
    expect(screen.getByRole('searchbox', { name: 'Search' })).toBeInTheDocument()
  })
})

describe('SearchBox — realistic typing, with REAL timers', () => {
  // A documented gotcha, found while writing this lesson: userEvent's internal
  // async delays and Vitest's fake timers genuinely deadlock together even with
  // the documented `advanceTimers` option wired up -- three tests using that
  // combination hung and hit the 5000ms test timeout every single run. Rather
  // than fight it further, this lesson uses REAL timers with userEvent (a short
  // delayMs keeps the test fast) to prove realistic per-keystroke typing works,
  // and switches to fireEvent + fake timers (below) for the tests that need
  // precise control over debounce timing. Mixing testing tools has real edges;
  // finding and working around one, rather than hiding it, IS the lesson.
  it('calls onSearch once, with the final value, after a real user types and pauses', async () => {
    const user = userEvent.setup()
    const onSearch = vi.fn()
    render(<SearchBox onSearch={onSearch} delayMs={20} />)

    await user.type(screen.getByRole('searchbox'), 'react')

    await waitFor(() => expect(onSearch).toHaveBeenCalledWith('react'))
    expect(onSearch).toHaveBeenCalledTimes(1)
  })
})

describe('SearchBox — precise debounce timing, with FAKE timers + fireEvent', () => {
  beforeEach(() => {
    vi.useFakeTimers()
  })

  afterEach(() => {
    vi.useRealTimers()
  })

  function typeChar(input, value) {
    fireEvent.change(input, { target: { value } })
  }

  it('does NOT call onSearch before delayMs has elapsed', () => {
    const onSearch = vi.fn()
    render(<SearchBox onSearch={onSearch} delayMs={300} />)

    typeChar(screen.getByRole('searchbox'), 'react')
    act(() => vi.advanceTimersByTime(299))

    expect(onSearch).not.toHaveBeenCalled()
  })

  it('calls onSearch exactly once, with the final value, once delayMs elapses', () => {
    const onSearch = vi.fn()
    render(<SearchBox onSearch={onSearch} delayMs={300} />)

    typeChar(screen.getByRole('searchbox'), 'react')
    act(() => vi.advanceTimersByTime(300))

    // This is the behavior worth asserting: exactly one call, with the
    // complete final string -- NOT that internal state changed, which is an
    // implementation detail no consumer of this component actually cares about.
    expect(onSearch).toHaveBeenCalledTimes(1)
    expect(onSearch).toHaveBeenCalledWith('react')
  })

  it('resets the debounce timer on each keystroke -- proven by simulating two keystrokes 200ms apart', () => {
    const onSearch = vi.fn()
    render(<SearchBox onSearch={onSearch} delayMs={300} />)
    const input = screen.getByRole('searchbox')

    typeChar(input, 'r')
    act(() => vi.advanceTimersByTime(200)) // less than delayMs -- should NOT have fired yet
    typeChar(input, 're')
    act(() => vi.advanceTimersByTime(200)) // still less than delayMs since the LAST keystroke

    // If the debounce incorrectly used a single timer started only on the
    // FIRST keystroke instead of resetting on every keystroke, onSearch would
    // have already fired here with the incomplete value "r". It hasn't.
    expect(onSearch).not.toHaveBeenCalled()

    act(() => vi.advanceTimersByTime(100)) // now 300ms since the LAST keystroke
    expect(onSearch).toHaveBeenCalledWith('re')
  })

  it('does not call onSearch for an empty/whitespace-only query', () => {
    const onSearch = vi.fn()
    render(<SearchBox onSearch={onSearch} delayMs={300} />)
    act(() => vi.advanceTimersByTime(300))
    expect(onSearch).not.toHaveBeenCalled()
  })
})
