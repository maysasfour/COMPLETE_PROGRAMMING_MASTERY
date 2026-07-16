# Exercise 01 — A `swap` Function Using References

[Back to lesson](../README.md)

## Task

Write a function `void swapValues(int& a, int& b)` that swaps the values of two `int`s in place, using reference parameters (no `std::swap`). Then write `void swapValuesBroken(int a, int b)` — identical logic, but with plain value parameters — to demonstrate it does NOT actually swap the caller's variables.

## Constraints

- `swapValues` must use `int&` parameters.
- `swapValuesBroken` must use plain `int` parameters, to prove the point by contrast.

## Starter Code

```cpp
void swapValues(int& a, int& b) {
    int temp = a;
    a = b;
    b = temp;
}

void swapValuesBroken(int a, int b) {
    int temp = a;
    a = b;
    b = temp;
}

int main() {
    int x = 1, y = 2;
    swapValues(x, y);
    // print x, y here -- should be swapped

    int p = 1, q = 2;
    swapValuesBroken(p, q);
    // print p, q here -- should be UNCHANGED
}
```

## Expected Output

```
After swapValues: x=2, y=1
After swapValuesBroken: p=1, q=2
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.cpp](../Solutions/solution-01.cpp).
