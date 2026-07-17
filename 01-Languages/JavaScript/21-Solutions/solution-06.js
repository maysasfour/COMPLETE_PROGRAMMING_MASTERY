// solution-06.js - Stack Class
// See: ../20-Exercises/README.md#exercise-06--stack-class-advanced
//
// Run with:
//   node solution-06.js

class EmptyStackError extends Error {
  constructor(message) {
    super(message);
    this.name = "EmptyStackError";
  }
}

/**
 * A LIFO stack "generic" over a single type T (see Lesson 13: JS has no
 * compile-time generics, so T here is documentation for readers/editors,
 * not something the language enforces - nothing stops mixing types at
 * runtime the way TypeScript's Stack<T> would).
 * @template T
 */
class Stack {
  #items = [];

  /** @param {T} item */
  push(item) {
    this.#items.push(item);
  }

  /** @returns {T} */
  pop() {
    if (this.isEmpty()) throw new EmptyStackError("Stack is empty");
    return this.#items.pop();
  }

  /** @returns {T} */
  peek() {
    if (this.isEmpty()) throw new EmptyStackError("Stack is empty");
    return this.#items[this.#items.length - 1];
  }

  isEmpty() {
    return this.#items.length === 0;
  }

  get size() {
    return this.#items.length;
  }
}

/** @type {Stack<number>} */
const numberStack = new Stack();
numberStack.push(1);
numberStack.push(2);
numberStack.push(3);
console.log(`number stack after pushes: size ${numberStack.size}`);
console.log(`Popped: ${numberStack.pop()}`);
console.log(`Peeked (unchanged): ${numberStack.peek()}`);
console.log(`number stack after pop: size ${numberStack.size}`);

/** @type {Stack<string>} */
const stringStack = new Stack();
stringStack.push("a");
stringStack.push("b");
console.log(`string stack: [${stringStack.peek()}, ...] size ${stringStack.size}`);

const emptyStack = new Stack();
try {
  emptyStack.pop();
} catch (err) {
  console.log(`Popped from empty stack threw: ${err.name}: ${err.message}`);
}
