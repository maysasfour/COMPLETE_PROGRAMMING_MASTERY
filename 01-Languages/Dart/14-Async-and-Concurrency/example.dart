// example.dart - Future/async/await (built into the language, like Swift's, unlike
// Kotlin's library-based coroutines), Stream for asynchronous SEQUENCES of values (a
// genuinely distinctive Dart concept beyond plain Future), and Isolates -- Dart's answer
// to parallelism: NO shared-memory threading at all, only message-passing between
// independent, isolated event loops (a genuinely unique concurrency model among the
// languages covered in this repository).

import 'dart:async';
import 'dart:isolate';

Future<int> fetchValue(int id, int delayMs) async {
  await Future.delayed(Duration(milliseconds: delayMs)); // suspends without blocking the event loop
  return id * 10;
}

Stream<int> countStream(int max) async* {
  // async* generator function: yields values over time as a Stream
  for (var i = 1; i <= max; i++) {
    await Future.delayed(Duration(milliseconds: 10));
    yield i; // produces the next value in the stream
  }
}

void isolateEntryPoint(SendPort sendPort) {
  // Runs in a SEPARATE isolate -- its own memory, its own event loop, NO shared state
  // with the main isolate at all. Communication happens ONLY via message passing.
  var result = 0;
  for (var i = 1; i <= 1000000; i++) {
    result += i;
  }
  sendPort.send(result); // the ONLY way to communicate back -- message passing, not shared memory
}

Future<void> main() async {
  print('--- Sequential await calls ---');
  var sequentialStart = DateTime.now();
  var a = await fetchValue(1, 200);
  var b = await fetchValue(2, 200);
  print('a=$a, b=$b');
  print('sequential took ${DateTime.now().difference(sequentialStart).inMilliseconds}ms');

  print('\n--- Concurrent with Future.wait ---');
  var concurrentStart = DateTime.now();
  var results = await Future.wait([
    fetchValue(1, 200), // starts immediately
    fetchValue(2, 200), // runs alongside the first
  ]);
  print('a=${results[0]}, b=${results[1]}');
  var concurrentMs = DateTime.now().difference(concurrentStart).inMilliseconds;
  print('concurrent took ${concurrentMs}ms');
  print('(concurrent run should take roughly HALF the sequential run\'s time)');

  print('\n--- Stream: an asynchronous SEQUENCE of values, not just one Future ---');
  await for (var value in countStream(5)) {
    print('  stream value: $value');
  }

  print('\n--- Isolate: Dart\'s parallelism model -- NO shared memory, message passing only ---');
  var receivePort = ReceivePort();
  await Isolate.spawn(isolateEntryPoint, receivePort.sendPort);
  var isolateResult = await receivePort.first; // waits for the isolate's message
  print('sum computed in a separate isolate: $isolateResult');
}
