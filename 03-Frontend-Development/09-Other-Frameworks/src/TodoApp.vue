<script setup>
// The deliberate point of this file: it's the SAME app as Lesson 04's
// TodoApp.jsx (add/toggle/delete, reject blank input, empty-state message),
// rewritten in Vue's Composition API, specifically so the two can be read
// side-by-side to see what actually differs.
import { ref } from 'vue'

let nextId = 1
const todos = ref([])
const text = ref('')

function addTodo() {
  const trimmed = text.value.trim()
  if (trimmed === '') return
  todos.value.push({ id: nextId++, text: trimmed, done: false })
  text.value = ''
}

function toggleTodo(id) {
  const todo = todos.value.find((t) => t.id === id)
  if (todo) todo.done = !todo.done
}

function deleteTodo(id) {
  todos.value = todos.value.filter((t) => t.id !== id)
}
</script>

<template>
  <div>
    <form @submit.prevent="addTodo">
      <label for="todo-input">New task</label>
      <input id="todo-input" v-model="text" />
      <button type="submit">Add</button>
    </form>

    <p v-if="todos.length === 0" role="status">No tasks yet.</p>
    <ul v-else>
      <li v-for="todo in todos" :key="todo.id">
        <label>
          <input type="checkbox" :checked="todo.done" @change="toggleTodo(todo.id)" />
          <span :style="{ textDecoration: todo.done ? 'line-through' : 'none' }">
            {{ todo.text }}
          </span>
        </label>
        <button @click="deleteTodo(todo.id)" :aria-label="`Delete ${todo.text}`">Delete</button>
      </li>
    </ul>
  </div>
</template>
