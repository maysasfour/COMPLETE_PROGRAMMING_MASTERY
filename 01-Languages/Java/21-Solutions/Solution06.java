import java.util.ArrayList;
import java.util.List;

class EmptyStackException extends RuntimeException {
    public EmptyStackException(String message) {
        super(message);
    }
}

class Stack<T> {
    private final List<T> items = new ArrayList<>();

    public void push(T item) {
        items.add(item);
    }

    public T pop() {
        if (isEmpty()) {
            throw new EmptyStackException("Cannot pop from an empty stack");
        }
        return items.remove(items.size() - 1);
    }

    public T peek() {
        if (isEmpty()) {
            throw new EmptyStackException("Cannot peek an empty stack");
        }
        return items.get(items.size() - 1);
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }

    public int size() {
        return items.size();
    }
}

public class Solution06 {
    public static void main(String[] args) {
        Stack<Integer> intStack = new Stack<>();
        intStack.push(1);
        intStack.push(2);
        intStack.push(3);
        System.out.println("int stack after pushes: length " + intStack.size());
        System.out.println("Popped: " + intStack.pop());
        System.out.println("Peeked (unchanged): " + intStack.peek());
        System.out.println("Size after pop: " + intStack.size());

        Stack<String> stringStack = new Stack<>();
        stringStack.push("a");
        stringStack.push("b");
        System.out.println("string stack popped: " + stringStack.pop());
        System.out.println("string stack popped: " + stringStack.pop());

        try {
            stringStack.pop();
        } catch (EmptyStackException e) {
            System.out.println("Popping empty stack correctly threw: " + e.getMessage());
        }
    }
}
