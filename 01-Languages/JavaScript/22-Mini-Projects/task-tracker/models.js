// models.js - the Task value object.
//
// A class instead of a plain object literal so every place that handles a
// task gets a real toString() and a documented shape for free, the same
// reasoning the Python/Java courses' mini-projects use for their model classes.

class Task {
  constructor({ id, title, priority, status }) {
    this.id = id;
    this.title = title;
    this.priority = priority;
    this.status = status;
  }

  toString() {
    // A checkbox-style marker reads at a glance faster than the raw
    // "pending"/"done" string would in a terminal list.
    const marker = this.status === "done" ? "[x]" : "[ ]";
    return `${marker} #${this.id}  (${this.priority})  ${this.title}`;
  }
}

module.exports = { Task };
