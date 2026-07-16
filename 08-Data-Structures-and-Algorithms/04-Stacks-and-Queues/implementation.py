"""
Lesson 04 - Stacks and Queues
Implements a Stack (using a Python list) and a Queue (using
collections.deque), plus two classic use cases: a balanced-parentheses
checker (stack) and a task queue simulation (queue).

Run with:
    python implementation.py
"""

from collections import deque


class Stack:
    """LIFO (Last In, First Out) structure, backed by a Python list.

    We push/pop from the END of the list specifically because that's the
    O(1) amortized end (see Lesson 02) - if we pushed/popped from index 0
    instead, every operation would be O(n) due to shifting. Using the
    correct end of the underlying array is the entire performance story.
    """

    def __init__(self):
        self._items = []

    def push(self, item):
        self._items.append(item)  # O(1) amortized: append to the end

    def pop(self):
        if self.is_empty():
            raise IndexError("pop from an empty stack")
        return self._items.pop()  # O(1): remove from the end, no shifting

    def peek(self):
        if self.is_empty():
            raise IndexError("peek at an empty stack")
        return self._items[-1]  # O(1): direct index

    def is_empty(self):
        return len(self._items) == 0

    def __len__(self):
        return len(self._items)


class Queue:
    """FIFO (First In, First Out) structure, backed by collections.deque.

    A plain Python list would make dequeue() (removal from the front)
    O(n), because every remaining element has to shift left (Lesson 02).
    deque is implemented as a doubly linked list of blocks internally,
    specifically so that BOTH ends support O(1) addition/removal - that's
    the whole reason to reach for deque instead of list here.
    """

    def __init__(self):
        self._items = deque()

    def enqueue(self, item):
        self._items.append(item)  # O(1): add to the back

    def dequeue(self):
        if self.is_empty():
            raise IndexError("dequeue from an empty queue")
        return self._items.popleft()  # O(1): remove from the front - the key deque advantage

    def peek(self):
        if self.is_empty():
            raise IndexError("peek at an empty queue")
        return self._items[0]

    def is_empty(self):
        return len(self._items) == 0

    def __len__(self):
        return len(self._items)


def is_balanced(expression):
    """Checks whether all brackets in `expression` are balanced and
    correctly nested, using a Stack.

    Why a stack fits this problem: the LAST opening bracket seen must be
    the FIRST one closed (nesting is inherently LIFO). Every time we see a
    closer, it must match whatever opener is currently on TOP of the
    stack - if it doesn't, the nesting is broken, which is exactly what
    "unbalanced" means.
    """
    pairs = {")": "(", "]": "[", "}": "{"}
    openers = set(pairs.values())
    stack = Stack()

    for char in expression:
        if char in openers:
            stack.push(char)
        elif char in pairs:
            if stack.is_empty() or stack.pop() != pairs[char]:
                # Either there's no opener at all to match, or the most
                # recent unmatched opener is the wrong type/shape.
                return False

    # If anything is left on the stack, some opener was never closed.
    return stack.is_empty()


def simulate_task_queue(tasks):
    """Simulates processing tasks in the order they arrive, using a Queue.

    Models a realistic scenario: a print spooler, a request queue, or a
    background job processor all share this shape - work arrives over
    time and must be handled in arrival order (FIFO), which a Queue
    enforces by construction (you literally cannot dequeue out of order).
    """
    queue = Queue()
    for task in tasks:
        queue.enqueue(task)

    processed_order = []
    while not queue.is_empty():
        current_task = queue.dequeue()
        processed_order.append(current_task)
    return processed_order


def main():
    print("=== Stack: push/pop/peek ===")
    stack = Stack()
    stack.push(1)
    stack.push(2)
    stack.push(3)
    print(f"After pushing 1, 2, 3: peek() -> {stack.peek()}, size -> {len(stack)}")
    print(f"pop() -> {stack.pop()}")
    print(f"pop() -> {stack.pop()}")
    print(f"size after two pops -> {len(stack)}")

    print("\n=== Queue: enqueue/dequeue/peek ===")
    queue = Queue()
    queue.enqueue("a")
    queue.enqueue("b")
    queue.enqueue("c")
    print(f"After enqueuing a, b, c: peek() -> {queue.peek()}, size -> {len(queue)}")
    print(f"dequeue() -> {queue.dequeue()}")
    print(f"dequeue() -> {queue.dequeue()}")
    print(f"size after two dequeues -> {len(queue)}")

    print("\n=== Balanced parentheses checker (stack use case) ===")
    test_expressions = [
        "(a + b) * (c - d)",
        "([{}])",
        "([)]",
        "(((",
        "",
        "no brackets here",
    ]
    for expr in test_expressions:
        print(f"is_balanced({expr!r}) -> {is_balanced(expr)}")

    print("\n=== Task queue simulation (queue use case) ===")
    incoming_tasks = ["send-email", "resize-image", "generate-report", "backup-database"]
    print(f"Tasks arrive in order: {incoming_tasks}")
    order = simulate_task_queue(incoming_tasks)
    print(f"Tasks processed in order: {order}")
    print(f"FIFO confirmed: processed order == arrival order -> {order == incoming_tasks}")


if __name__ == "__main__":
    main()
