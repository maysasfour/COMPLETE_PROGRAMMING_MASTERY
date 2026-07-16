// Exercise: write a function with named parameters (one required, one with a default),
// and a higher-order function using function-type parameters.

double average({required List<double> numbers}) {
  // TODO: implement using numbers.reduce((a, b) => a + b) / numbers.length
  return 0.0;
}

bool isPrime(int n) {
  // TODO: implement -- return false for n < 2, check divisibility up to sqrt(n)
  return false;
}

void main() {
  var primes = List.generate(29, (i) => i + 2).where(isPrime).toList();
  print('primes up to 30: $primes'); // expected: [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
  print('average: ${average(numbers: [1.0, 2.0, 3.0, 4.0])}'); // expected: 2.5
}
