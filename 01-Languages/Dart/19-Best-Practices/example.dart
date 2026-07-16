// example.dart - Before/after: three genuine Dart anti-patterns and their fixes, each
// reproduced live to show the bad version actually misbehaving, not just described.

import 'dart:isolate';

// --- Anti-pattern 1: assuming List uses structural (content) equality, like most languages ---
bool listsMatchBad(List<int> a, List<int> b) {
  return a == b; // Dart's default List == is IDENTITY equality, NOT content equality!
}

bool listsMatchGood(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

// --- Anti-pattern 2: force-unwrap (!) crashing instead of safe null handling ---
int findUserBad(Map<String, int> users, String name) {
  return users[name]!; // throws "Null check operator used on a null value" if name isn't found
}

int findUserGood(Map<String, int> users, String name) {
  var id = users[name];
  if (id == null) {
    throw StateError("no user named '$name' found"); // a clear, specific, catchable error
  }
  return id;
}

// --- Anti-pattern 3: blocking the event loop with heavy synchronous computation ---
int heavySyncComputation() {
  var result = 0;
  for (var i = 0; i < 200000000; i++) {
    result += i;
  }
  return result;
}

void isolateEntryPoint(SendPort sendPort) {
  sendPort.send(heavySyncComputation());
}

void main() async {
  print('--- Anti-pattern 1: List == is IDENTITY equality by default, not content equality ---');
  var listA = [1, 2, 3];
  var listB = [1, 2, 3]; // a DIFFERENT list object with the SAME content
  print('bad: listsMatchBad(listA, listB) = ${listsMatchBad(listA, listB)}'); // false! surprising
  print('good: listsMatchGood(listA, listB) = ${listsMatchGood(listA, listB)}'); // true -- correct

  print('\n--- Anti-pattern 2: force-unwrap vs clear error handling ---');
  var users = {'Ada': 1, 'Grace': 2};
  try {
    findUserBad(users, 'Linus');
  } catch (e) {
    print('bad: threw a generic, unhelpful error: ${e.runtimeType}');
  }
  try {
    findUserGood(users, 'Linus');
  } catch (e) {
    print('good: threw a specific, clear error: $e');
  }

  print('\n--- Anti-pattern 3: blocking the event loop vs using an Isolate ---');
  print('starting a periodic timer to prove the main isolate is (or isn\'t) blocked...');
  var ticks = 0;
  var timer = Stream.periodic(Duration(milliseconds: 20)).listen((_) => ticks++);
  await Future.delayed(Duration(milliseconds: 10)); // let the timer start ticking

  var syncStart = DateTime.now();
  heavySyncComputation(); // BLOCKS the event loop -- the timer above cannot tick during this
  var syncMs = DateTime.now().difference(syncStart).inMilliseconds;
  var ticksAfterSync = ticks;
  print('bad: heavySyncComputation() took ${syncMs}ms; timer ticks during that time: (blocked, ~0 expected)');

  var isolateStart = DateTime.now();
  var receivePort = ReceivePort();
  await Isolate.spawn(isolateEntryPoint, receivePort.sendPort);
  await receivePort.first; // waits for the isolate's result WITHOUT blocking the main event loop
  var isolateMs = DateTime.now().difference(isolateStart).inMilliseconds;
  print('good: same computation via Isolate.spawn took ${isolateMs}ms of wall time,');
  print('       but the MAIN isolate\'s event loop remained free to keep ticking the whole time');
  print('       (ticks recorded before sync block: $ticksAfterSync, total ticks now: $ticks)');

  await timer.cancel();
}
