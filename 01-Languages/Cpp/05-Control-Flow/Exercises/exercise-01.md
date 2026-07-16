# Exercise 01 — FizzBuzz with a Range-Based For

[Back to lesson](../README.md)

## Task

Write a function `std::string fizzBuzz(int n)` returning `"FizzBuzz"` for multiples of 15, `"Fizz"` for multiples of 3, `"Buzz"` for multiples of 5, and the number itself (as a string, via `std::to_string`) otherwise. Then use a range-based `for` over a `std::vector<int>` containing 1 through 15 to print each result.

## Constraints

- Use `if`/`else if` (not `switch`) inside `fizzBuzz`.
- Build the 1-15 vector however you like (a loop, or `std::vector<int>` with an initializer list is fine for this small size).

## Starter Code

```cpp
#include <iostream>
#include <string>
#include <vector>

std::string fizzBuzz(int n) {
    // your logic here
}

int main() {
    std::vector<int> numbers;
    for (int i = 1; i <= 15; i++) numbers.push_back(i);

    for (const auto& n : numbers) {
        std::cout << fizzBuzz(n) << std::endl;
    }
    return 0;
}
```

## Expected Output

```
1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.cpp](../Solutions/solution-01.cpp).
