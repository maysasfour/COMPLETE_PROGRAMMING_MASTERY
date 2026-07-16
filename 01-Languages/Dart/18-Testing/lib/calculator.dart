class Calculator {
  int add(int a, int b) => a + b;

  double divide(double a, double b) {
    if (b == 0) throw ArgumentError('division by zero');
    return a / b;
  }

  bool isPalindrome(String s) {
    var cleaned = s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return cleaned == cleaned.split('').reversed.join('');
  }
}
