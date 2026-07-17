// solution-05.ts - generic constrained InMemoryRepository<T extends Entity> (Exercise 05)

interface Entity {
  id: number;
}

class NotFoundError extends Error {
  constructor(id: number) {
    super(`No entity found with id ${id}`);
    this.name = "NotFoundError";
  }
}

// `T extends Entity` is the constraint that makes a single repository implementation work
// for any entity shape: the class only ever needs to know `.id` exists, never the rest of T.
class InMemoryRepository<T extends Entity> {
  private items = new Map<number, T>();

  add(item: T): void {
    this.items.set(item.id, item);
  }

  getById(id: number): T | undefined {
    return this.items.get(id);
  }

  update(id: number, patch: Partial<Omit<T, "id">>): T {
    const existing = this.items.get(id);
    if (!existing) throw new NotFoundError(id);
    const updated = { ...existing, ...patch } as T;
    this.items.set(id, updated);
    return updated;
  }

  delete(id: number): boolean {
    return this.items.delete(id);
  }

  all(): T[] {
    return [...this.items.values()];
  }
}

interface Task extends Entity {
  title: string;
  done: boolean;
}

const tasks = new InMemoryRepository<Task>();
tasks.add({ id: 1, title: "Write lesson", done: false });
tasks.add({ id: 2, title: "Compile examples", done: false });
tasks.add({ id: 3, title: "Review PR", done: true });

console.log("all tasks:", tasks.all());

const updated = tasks.update(1, { done: true });
console.log("task 1 after update:", updated);

const deleted = tasks.delete(2);
console.log("deleted task 2:", deleted);
console.log("remaining tasks:", tasks.all());

try {
  tasks.update(999, { done: true });
} catch (e) {
  if (e instanceof NotFoundError) {
    console.log("expected error caught:", e.message);
  } else {
    throw e;
  }
}
