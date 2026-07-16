/**
 * render.js
 *
 * All DOM-writing code lives here. Nothing in this file mutates app state
 * directly — it only reads from State and writes to the DOM, plus wires up
 * per-task event listeners that delegate back into State/events.js.
 *
 * Re-render strategy: we do a full re-render of the task list on every
 * state change rather than fine-grained DOM patching. For a to-do list of
 * realistic size (tens to low hundreds of tasks) this is simpler to get
 * right and fast enough — premature DOM-diffing would add complexity this
 * beginner project doesn't need.
 */

const Render = (() => {
  const listEl = document.getElementById('task-list');
  const emptyStateEl = document.getElementById('empty-state');
  const countEl = document.getElementById('task-count');
  const filterButtons = document.querySelectorAll('.filter-btn');

  /** Escapes text before it's inserted via innerHTML, preventing task titles/descriptions from being interpreted as markup (basic stored-XSS hardening for user-entered text). */
  function escapeHtml(str) {
    const div = document.createElement('div');
    div.textContent = str;
    return div.innerHTML;
  }

  function formatDate(isoString) {
    const date = new Date(isoString);
    return date.toLocaleDateString(undefined, {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  }

  /** Builds the DOM node for a single task row. */
  function buildTaskElement(task) {
    const li = document.createElement('li');
    li.className = `task-item${task.status === 'completed' ? ' task-item--completed' : ''}`;
    li.dataset.taskId = task.id;

    li.innerHTML = `
      <div class="task-item__main">
        <input type="checkbox" class="task-item__checkbox" ${task.status === 'completed' ? 'checked' : ''} aria-label="Mark task complete" />
        <div class="task-item__text">
          <p class="task-item__title">${escapeHtml(task.title)}</p>
          ${task.description ? `<p class="task-item__description">${escapeHtml(task.description)}</p>` : ''}
          <p class="task-item__meta">Created ${formatDate(task.createdAt)}</p>
        </div>
      </div>
      <div class="task-item__actions">
        <button type="button" class="btn btn--small task-item__edit">Edit</button>
        <button type="button" class="btn btn--small btn--danger task-item__delete">Delete</button>
      </div>
    `;

    return li;
  }

  /** Swaps a task row into an inline edit form; used by the Edit button. */
  function buildEditFormElement(task) {
    const li = document.createElement('li');
    li.className = 'task-item task-item--editing';
    li.dataset.taskId = task.id;

    li.innerHTML = `
      <form class="task-item__edit-form">
        <input type="text" class="task-item__edit-title" value="${escapeHtml(task.title)}" required maxlength="200" />
        <textarea class="task-item__edit-description" maxlength="1000" rows="2">${escapeHtml(task.description)}</textarea>
        <div class="task-item__actions">
          <button type="submit" class="btn btn--small btn--primary">Save</button>
          <button type="button" class="btn btn--small task-item__cancel-edit">Cancel</button>
        </div>
      </form>
    `;

    return li;
  }

  // Tracks which task (if any) is currently being edited so re-renders
  // triggered by unrelated state changes don't kick the user out of an
  // in-progress edit.
  let editingTaskId = null;

  function setEditingTaskId(id) {
    editingTaskId = id;
  }

  function renderTaskList() {
    const tasks = window.State.getVisibleTasks();
    listEl.innerHTML = '';

    if (tasks.length === 0) {
      emptyStateEl.hidden = false;
    } else {
      emptyStateEl.hidden = true;
      tasks.forEach((task) => {
        const node = task.id === editingTaskId ? buildEditFormElement(task) : buildTaskElement(task);
        listEl.appendChild(node);
      });
    }

    renderCount();
    renderActiveFilterButton();
  }

  function renderCount() {
    const total = window.State.getTasks();
    const activeCount = total.filter((t) => t.status === 'active').length;
    countEl.textContent = `${activeCount} active / ${total.length} total`;
  }

  function renderActiveFilterButton() {
    const current = window.State.getFilter();
    filterButtons.forEach((btn) => {
      const isActive = btn.dataset.filter === current;
      btn.classList.toggle('filter-btn--active', isActive);
      btn.setAttribute('aria-pressed', String(isActive));
    });
  }

  return {
    renderTaskList,
    setEditingTaskId,
    getEditingTaskId: () => editingTaskId,
    elements: { listEl, filterButtons },
  };
})();

window.Render = Render;
