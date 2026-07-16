/**
 * state.js
 *
 * Single source of truth for in-memory app state (the task list + the
 * active filter). Wraps js/taskLogic.js's pure functions and, after every
 * mutation, (1) persists to localStorage and (2) notifies subscribers so
 * the DOM can re-render.
 *
 * This "store" pattern (state + subscribe + notify) is a deliberately
 * small hand-rolled version of what Redux/Zustand/etc. do — kept minimal
 * on purpose since this is a beginner project and a full state library
 * would be overkill for one entity type.
 */

const State = (() => {
  const { addTask, updateTask, deleteTask, toggleTaskStatus, filterTasks } = window.TaskLogic;
  const { loadTasks, saveTasks } = window.Storage_;

  let tasks = loadTasks();
  let activeFilter = 'all'; // 'all' | 'active' | 'completed'
  const listeners = [];

  /** Runs every subscriber. Called after any state change so views stay in sync. */
  function notify() {
    listeners.forEach((listener) => listener());
  }

  /** Persist then notify — kept as one step so callers can't forget to save. */
  function commit(nextTasks) {
    tasks = nextTasks;
    saveTasks(tasks);
    notify();
  }

  return {
    /** Registers a callback to run after every state change. Returns an unsubscribe function. */
    subscribe(listener) {
      listeners.push(listener);
      return () => {
        const idx = listeners.indexOf(listener);
        if (idx !== -1) listeners.splice(idx, 1);
      };
    },

    getTasks() {
      return tasks;
    },

    getVisibleTasks() {
      return filterTasks(tasks, activeFilter);
    },

    getFilter() {
      return activeFilter;
    },

    setFilter(filterName) {
      activeFilter = filterName;
      notify(); // filter change doesn't touch persisted data, so no save() needed
    },

    add(title, description) {
      commit(addTask(tasks, title, description));
    },

    update(id, updates) {
      commit(updateTask(tasks, id, updates));
    },

    remove(id) {
      commit(deleteTask(tasks, id));
    },

    toggleStatus(id) {
      commit(toggleTaskStatus(tasks, id));
    },
  };
})();

window.State = State;
