/**
 * main.js
 *
 * Entry point loaded last (after taskLogic.js, storage.js, state.js,
 * render.js, events.js) via plain <script> tags in index.html.
 *
 * There is deliberately very little here: state.js builds window.State
 * eagerly (it needs to load persisted tasks before first paint), and
 * events.js performs the initial render and wires up listeners as soon as
 * it runs. This file exists mainly as a single, obvious "this is where the
 * app starts" landmark, and as a home for any future startup-only logic
 * (e.g. a one-time "welcome" banner) without disturbing events.js.
 */

console.log('Task Management CRUD app initialized. Tasks in storage:', window.State.getTasks().length);
