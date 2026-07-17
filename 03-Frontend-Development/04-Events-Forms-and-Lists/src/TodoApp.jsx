import { useState } from 'react'

let nextId = 1

// Demonstrates: a CONTROLLED input (its value lives in React state, not the DOM --
// `value={text}` + `onChange` is what makes it controlled, versus an uncontrolled
// input that manages its own value and is read only on demand via a ref),
// preventDefault() to stop a form's default full-page-reload submit behavior,
// and immutable list updates (.map()/.filter() returning NEW arrays, never
// mutating `todos` in place -- React compares the old and new array references
// to decide whether to re-render, so mutating in place would make it think
// nothing changed).
export function TodoApp() {
  const [todos, setTodos] = useState([])
  const [text, setText] = useState('')

  function handleSubmit(event) {
    event.preventDefault()
    const trimmed = text.trim()
    if (trimmed === '') return // reject empty/whitespace-only submissions

    setTodos((prev) => [...prev, { id: nextId++, text: trimmed, done: false }])
    setText('') // clear the controlled input after a successful add
  }

  function toggleTodo(id) {
    setTodos((prev) =>
      prev.map((todo) => (todo.id === id ? { ...todo, done: !todo.done } : todo)),
    )
  }

  function deleteTodo(id) {
    setTodos((prev) => prev.filter((todo) => todo.id !== id))
  }

  return (
    <div>
      <form onSubmit={handleSubmit}>
        <label htmlFor="todo-input">New task</label>
        <input
          id="todo-input"
          value={text}
          onChange={(event) => setText(event.target.value)}
        />
        <button type="submit">Add</button>
      </form>

      {todos.length === 0 ? (
        <p role="status">No tasks yet.</p>
      ) : (
        <ul>
          {todos.map((todo) => (
            <li key={todo.id}>
              <label>
                <input
                  type="checkbox"
                  checked={todo.done}
                  onChange={() => toggleTodo(todo.id)}
                />
                <span style={{ textDecoration: todo.done ? 'line-through' : 'none' }}>
                  {todo.text}
                </span>
              </label>
              <button onClick={() => deleteTodo(todo.id)} aria-label={`Delete ${todo.text}`}>
                Delete
              </button>
            </li>
          ))}
        </ul>
      )}
    </div>
  )
}
