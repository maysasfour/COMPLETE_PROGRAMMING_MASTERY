double average({required List<double> numbers}) {
  return numbers.reduce((a, b) => a + b) / numbers.length;
}

bool isPrime(int n) {
  if (n < 2) return false;
  for (var i = 2; i * i <= n; i++) {
    if (n % i == 0) return false;
  }
  return true;
}

void main() {
  var primes = List.generate(29, (i) => i + 2).where(isPrime).toList();
  print('primes up to 30: $primes');
  print('average: ${average(numbers: [1.0, 2.0, 3.0, 4.0])}');
}
