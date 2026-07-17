import { fireEvent, render, screen } from '@testing-library/react'
import { describe, expect, it } from 'vitest'
import { TodoApp } from './TodoApp.jsx'

function addTodo(text) {
  fireEvent.change(screen.getByLabelText('New task'), { target: { value: text } })
  fireEvent.click(screen.getByText('Add'))
}

describe('TodoApp', () => {
  it('shows an empty-state message when there are no todos', () => {
    render(<TodoApp />)
    expect(screen.getByRole('status')).toHaveTextContent('No tasks yet.')
  })

  it('adds a todo via the form and clears the controlled input afterward', () => {
    render(<TodoApp />)
    addTodo('Write lesson 04')

    expect(screen.getByText('Write lesson 04')).toBeInTheDocument()
    expect(screen.getByLabelText('New task')).toHaveValue('') // input was cleared
  })

  it('rejects an empty or whitespace-only submission', () => {
    render(<TodoApp />)
    addTodo('   ')

    expect(screen.getByRole('status')).toHaveTextContent('No tasks yet.')
  })

  it('toggles a todo done/undone via its checkbox', () => {
    render(<TodoApp />)
    addTodo('Buy milk')

    const checkbox = screen.getByRole('checkbox')
    expect(checkbox).not.toBeChecked()

    fireEvent.click(checkbox)
    expect(checkbox).toBeChecked()

    fireEvent.click(checkbox)
    expect(checkbox).not.toBeChecked()
  })

  it('deletes a todo, and shows the empty state again once the last one is removed', () => {
    render(<TodoApp />)
    addTodo('Temporary task')
    expect(screen.getByText('Temporary task')).toBeInTheDocument()

    fireEvent.click(screen.getByLabelText('Delete Temporary task'))

    expect(screen.queryByText('Temporary task')).not.toBeInTheDocument()
    expect(screen.getByRole('status')).toHaveTextContent('No tasks yet.')
  })

  it('keeps todos independent -- toggling one does not affect another', () => {
    render(<TodoApp />)
    addTodo('Task A')
    addTodo('Task B')

    const checkboxes = screen.getAllByRole('checkbox')
    fireEvent.click(checkboxes[0])

    expect(checkboxes[0]).toBeChecked()
    expect(checkboxes[1]).not.toBeChecked()
  })
})
