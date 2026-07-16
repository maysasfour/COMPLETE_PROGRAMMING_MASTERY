String fizzbuzz(int n) {
  return switch (n) {
    _ when n % 15 == 0 => 'FizzBuzz',
    _ when n % 3 == 0 => 'Fizz',
    _ when n % 5 == 0 => 'Buzz',
    _ => n.toString(),
  };
}

void main() {
  for (var i = 1; i <= 15; i++) {
    print(fizzbuzz(i));
  }
}
