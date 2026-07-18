// solution-06.dart - Exercise 06: Concurrent Futures.

class FetchFailedException implements Exception {
  final String url;
  FetchFailedException(this.url);
  @override
  String toString() => 'FetchFailedException: $url failed';
}

Future<String> fetchAsync(String url, int delayMs, {bool shouldFail = false}) async {
  await Future.delayed(Duration(milliseconds: delayMs)); // suspends WITHOUT blocking the event loop
  if (shouldFail) throw FetchFailedException(url);
  return '$url -> 200 OK';
}

void main() async {
  print('--- Kicking off 4 concurrent fetches ---');
  var start = DateTime.now();

  // Futures start running the MOMENT fetchAsync() is called, not when awaited --
  // calling all four before awaiting any of them is what makes them concurrent.
  // eagerError: false means Future.wait won't short-circuit on the FIRST failure;
  // it waits for every future to settle, wrapping each in a Result via .then/.catchError
  // below so one failure can't silently swallow the others' outcomes.
  var futures = [
    fetchAsync('https://api.example.com/users', 300),
    fetchAsync('https://api.example.com/orders', 500),
    fetchAsync('https://api.example.com/broken', 200, shouldFail: true),
    fetchAsync('https://api.example.com/products', 400),
  ];

  var outcomes = await Future.wait(
    futures.map(
      (f) => f.then<MapEntry<bool, String>>(
        (value) => MapEntry(true, value),
        onError: (Object e) => MapEntry(false, e.toString()),
      ),
    ),
    eagerError: false,
  );

  var elapsedMs = DateTime.now().difference(start).inMilliseconds;
  print('Elapsed: ${elapsedMs}ms (slowest single delay was 500ms -- proves concurrency,'
      ' not a ~1400ms sum)');

  print('\n--- per-fetch results ---');
  for (var outcome in outcomes) {
    var status = outcome.key ? 'OK' : 'FAILED';
    print('  $status: ${outcome.value}');
  }

  var failures = outcomes.where((o) => !o.key).length;
  print('\n${outcomes.length - failures} succeeded, $failures failed -- no result silently dropped.');
}
