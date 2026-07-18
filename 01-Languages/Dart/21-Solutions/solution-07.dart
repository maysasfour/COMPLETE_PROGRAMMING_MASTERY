// solution-07.dart - Exercise 07: Streams: Transform and Filter.

import 'dart:async';

Stream<int> numberStream(int max) async* {
  for (var i = 1; i <= max; i++) {
    await Future.delayed(Duration(milliseconds: 10));
    yield i;
  }
}

Future<void> main() async {
  print('--- Stream pipeline: where -> map -> toList ---');
  var result = await numberStream(10)
      .where((n) => n.isEven) // 2, 4, 6, 8, 10
      .map((n) => n * n) // 4, 16, 36, 64, 100
      .toList();
  print(result);

  print('\n--- Hand-built StreamController: onError does NOT terminate the stream ---');
  var controller = StreamController<int>();
  var received = <String>[];

  // broadcast not needed here (single listener), but the point under test is that
  // addError() delivers to onError WITHOUT closing the stream -- the controller
  // stays open and subsequent add() calls still reach onData afterward.
  var done = Completer<void>();
  controller.stream.listen(
    (value) => received.add('data:$value'),
    onError: (Object e) => received.add('error:$e'),
    onDone: () {
      received.add('done');
      done.complete();
    },
  );

  controller.add(1);
  controller.add(2);
  controller.addError('simulated failure');
  controller.add(3); // proves the stream is still alive after the error above
  await controller.close();
  await done.future;

  print(received);
  print('Value added AFTER the error still arrived: ${received.contains('data:3')}');
}
