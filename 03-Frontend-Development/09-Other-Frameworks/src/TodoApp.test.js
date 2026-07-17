import { mount } from '@vue/test-utils'
import { describe, expect, it } from 'vitest'
import TodoApp from './TodoApp.vue'

// The direct Vue counterpart to Lesson 04's TodoApp.test.jsx -- same behaviors,
// same assertions in spirit, different tool: @vue/test-utils' `mount` instead
// of React Testing Library's `render`, `wrapper.find()` instead of `screen.getBy*`.
describe('TodoApp (Vue) — same behavior as Lesson 04\'s React version', () => {
  it('shows an empty-state message when there are no todos', () => {
    const wrapper = mount(TodoApp)
    expect(wrapper.find('[role="status"]').text()).toBe('No tasks yet.')
  })

  it('adds a todo via the form and clears the input afterward (v-model, two-way binding)', async () => {
    const wrapper = mount(TodoApp)
    const input = wrapper.find('#todo-input')

    await input.setValue('Write lesson 09')
    await wrapper.find('form').trigger('submit.prevent')

    expect(wrapper.text()).toContain('Write lesson 09')
    expect(input.element.value).toBe('') // v-model reflects the cleared ref back to the DOM
  })

  it('rejects an empty or whitespace-only submission', async () => {
    const wrapper = mount(TodoApp)
    await wrapper.find('#todo-input').setValue('   ')
    await wrapper.find('form').trigger('submit.prevent')

    expect(wrapper.find('[role="status"]').text()).toBe('No tasks yet.')
  })

  it('toggles a todo done/undone via its checkbox', async () => {
    const wrapper = mount(TodoApp)
    await wrapper.find('#todo-input').setValue('Buy milk')
    await wrapper.find('form').trigger('submit.prevent')

    const checkbox = wrapper.find('input[type="checkbox"]')
    expect(checkbox.element.checked).toBe(false)

    await checkbox.trigger('change')
    expect(checkbox.element.checked).toBe(true)
  })

  it('deletes a todo, and shows the empty state again once the last one is removed', async () => {
    const wrapper = mount(TodoApp)
    await wrapper.find('#todo-input').setValue('Temporary task')
    await wrapper.find('form').trigger('submit.prevent')
    expect(wrapper.text()).toContain('Temporary task')

    await wrapper.find('button[aria-label="Delete Temporary task"]').trigger('click')

    expect(wrapper.text()).not.toContain('Temporary task')
    expect(wrapper.find('[role="status"]').text()).toBe('No tasks yet.')
  })
})
