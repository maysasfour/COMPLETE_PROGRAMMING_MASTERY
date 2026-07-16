/**
 * events.js
 *
 * Wires up all user-triggered DOM events and translates them into State
 * calls. Uses event delegation on the task list container (one listener
 * for clicks/submits on the whole list) rather than attaching listeners to
 * every task row — this also sidesteps having to re-attach listeners after
 * every re-render, since render.js rebuilds the list's innerHTML each time.
 */

(function initEvents() {
  const addForm = document.getElementById('add-task-form');
  const titleInput = document.getElementById('new-task-title');
  const descriptionInput = document.getElementById('new-task-description');
  const listEl = document.getElementById('task-list');
  const filterBar = document.getElementById('filter-bar');
  const errorEl = document.getElementById('form-error');

  // --- Add task ---------------------------------------------------------
  addForm.addEventListener('submit', (event) => {
    event.preventDefault();
    errorEl.textContent = '';

    try {
      window.State.add(titleInput.value, descriptionInput.value);
      addForm.reset();
      titleInput.focus();
    } catch (err) {
      // createTask() throws on an empty/whitespace-only title; surface that
      // to the user instead of letting the form silently do nothing.
      errorEl.textContent = err.message;
    }
  });

  // --- Task list: delegated clicks (checkbox, edit, delete, cancel) -----
  listEl.addEventListener('click', (event) => {
    const taskItem = event.target.closest('.task-item');
    if (!taskItem) return;
    const taskId = taskItem.dataset.taskId;

    if (event.target.matches('.task-item__delete')) {
      // Native confirm() is intentionally simple here — no custom modal
      // component is warranted for a single destructive action in a
      // beginner-tier app, and it's a real, unskippable browser prompt.
      const confirmed = window.confirm('Delete this task? This cannot be undone.');
      if (confirmed) {
        window.State.remove(taskId);
      }
      return;
    }

    if (event.target.matches('.task-item__edit')) {
      window.Render.setEditingTaskId(taskId);
      window.Render.renderTaskList();
      // Focus the title field so keyboard users land straight in the form.
      const titleField = listEl.querySelector('.task-item--editing .task-item__edit-title');
      if (titleField) titleField.focus();
      return;
    }

    if (event.target.matches('.task-item__cancel-edit')) {
      window.Render.setEditingTaskId(null);
      window.Render.renderTaskList();
      return;
    }
  });

  // Checkbox toggling uses 'change', not 'click', since that's the event
  // that correctly reflects the checkbox's new checked state.
  listEl.addEventListener('change', (event) => {
    if (!event.target.matches('.task-item__checkbox')) return;
    const taskItem = event.target.closest('.task-item');
    window.State.toggleStatus(taskItem.dataset.taskId);
  });

  // --- Task list: delegated submit (inline edit form) --------------------
  listEl.addEventListener('submit', (event) => {
    if (!event.target.matches('.task-item__edit-form')) return;
    event.preventDefault();

    const taskItem = event.target.closest('.task-item');
    const taskId = taskItem.dataset.taskId;
    const newTitle = event.target.querySelector('.task-item__edit-title').value;
    const newDescription = event.target.querySelector('.task-item__edit-description').value;

    if (!newTitle.trim()) {
      // Native `required` only blocks a truly empty value, not a
      // whitespace-only one, so we check trim() ourselves and use
      // setCustomValidity() to force the browser's validation bubble to
      // appear with a message that matches what we actually rejected.
      const titleField = event.target.querySelector('.task-item__edit-title');
      titleField.setCustomValidity('Title cannot be empty or just whitespace.');
      titleField.reportValidity();
      titleField.setCustomValidity(''); // reset so future valid input isn't blocked
      return;
    }

    // Clear editing mode BEFORE calling State.update(): update() notifies
    // subscribers synchronously, which triggers renderTaskList() — so
    // editingTaskId must already be null by then, otherwise it would
    // re-render the (now stale) edit form instead of the saved task.
    window.Render.setEditingTaskId(null);
    window.State.update(taskId, { title: newTitle, description: newDescription });
  });

  // --- Filter bar ---------------------------------------------------------
  filterBar.addEventListener('click', (event) => {
    if (!event.target.matches('.filter-btn')) return;
    window.State.setFilter(event.target.dataset.filter);
  });

  // --- Wire State changes to re-renders -----------------------------------
  window.State.subscribe(() => window.Render.renderTaskList());

  // --- Initial paint --------------------------------------------------
  window.Render.renderTaskList();
})();
