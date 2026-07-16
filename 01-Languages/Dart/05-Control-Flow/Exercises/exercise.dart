// Exercise: FizzBuzz using a Dart 3 switch EXPRESSION (not if/else if).
// Write a function fizzbuzz(int n) that returns:
//   "FizzBuzz" if divisible by both 3 and 5
//   "Fizz"     if divisible by 3 only
//   "Buzz"     if divisible by 5 only
//   otherwise, the number itself as a String
// Use `switch (n) { ... }` as an EXPRESSION with `when` guard clauses (Dart 3 pattern syntax).

String fizzbuzz(int n) {
  // TODO: implement using a switch expression, e.g.:
  // return switch (n) {
  //   _ when n % 15 == 0 => 'FizzBuzz',
  //   ...
  // };
  return '';
}

void main() {
  for (var i = 1; i <= 15; i++) {
    print(fizzbuzz(i));
  }
}
