// example.dart - try/catch/finally, custom exceptions (implements Exception), on-catch
// (catching a specific type without binding the exception itself), and Dart's split
// between Exception (expected, recoverable) and Error (programming mistakes) --
// similar in spirit to PHP's Error/Exception split covered earlier in this repository.

class InsufficientFundsException implements Exception {
  final double shortfall;
  InsufficientFundsException(this.shortfall);
  @override
  String toString() => 'InsufficientFundsException: short by $shortfall';
}

double withdraw(double balance, double amount) {
  if (amount > balance) {
    throw InsufficientFundsException(amount - balance);
  }
  return balance - amount;
}

double divide(double a, double b) {
  if (b == 0) {
    throw ArgumentError('cannot divide $a by zero');
  }
  return a / b;
}

void main() {
  print('--- try/catch/finally ---');
  try {
    print(divide(10, 2));
    print(divide(5, 0));
  } on ArgumentError catch (e) {
    print('caught: ${e.message}');
  } finally {
    print('finally always runs');
  }

  print('\n--- Custom exception (implements Exception) ---');
  try {
    withdraw(100, 150);
  } on InsufficientFundsException catch (e) {
    print('caught: $e (shortfall property: ${e.shortfall})');
  }

  print('\n--- on SpecificType (catches without binding the exception itself) ---');
  try {
    throw FormatException('bad format');
  } on FormatException {
    print('caught a FormatException (no variable needed since we don\'t use the details)');
  }

  print('\n--- Error vs Exception: Dart also distinguishes them, like PHP ---');
  // Error subtypes (like RangeError, ArgumentError) generally represent PROGRAMMING
  // mistakes; Exception subtypes represent EXPECTED, recoverable runtime failures.
  // Both implement the common "Object" root (Dart has no single shared Throwable
  // interface the way Kotlin/Java do -- literally ANY object can be thrown).
  try {
    var list = [1, 2, 3];
    print(list[10]); // throws RangeError -- a subtype of Error, not Exception
  } on RangeError catch (e) {
    print('caught RangeError: ${e.message}');
  }

  print('\n--- rethrow: propagate a caught exception further up ---');
  void riskyOperation() {
    try {
      throw StateError('something went wrong internally');
    } catch (e) {
      print('logging the error before rethrowing: $e');
      rethrow; // propagates the SAME exception (preserving its stack trace) to the caller
    }
  }
  try {
    riskyOperation();
  } catch (e) {
    print('caught after rethrow: $e');
  }
}
