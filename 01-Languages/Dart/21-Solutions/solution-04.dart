// solution-04.dart - Exercise 04: Extension Methods.

// Generic extension: <T> here parameterizes the EXTENSION itself, not just one method,
// so `chunked` works on List<int>, List<String>, or any List<T> without rewriting it.
extension ListChunking<T> on List<T> {
  List<List<T>> chunked(int size) {
    var result = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      result.add(sublist(i, i + size > length ? length : i + size));
    }
    return result;
  }
}

extension DateOnly on DateTime {
  String get isoDate =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}

extension NumClamp on num {
  num clampPositive() => this < 0 ? 0 : this;
}

void main() {
  print('--- ListChunking<T>: a generic extension method ---');
  var numbers = [1, 2, 3, 4, 5, 6, 7];
  var chunks = numbers.chunked(3);
  print(chunks); // [[1, 2, 3], [4, 5, 6], [7]]
  print('chunk count: ${chunks.length}, last chunk length: ${chunks.last.length}');

  print('\n--- DateOnly: extension getter on DateTime ---');
  var date = DateTime(2026, 7, 18, 14, 30);
  print(date.isoDate); // 2026-07-18

  print('\n--- NumClamp: extension method on num ---');
  print((-5).clampPositive()); // 0
  print((5).clampPositive()); // 5
  print((-3.5).clampPositive()); // 0
  print((3.5).clampPositive()); // 3.5
}
