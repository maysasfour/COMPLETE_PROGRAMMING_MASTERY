// example.dart - Dart runs standalone via the Dart VM (dart run), or compiles to native
// machine code (dart compile exe), or transpiles to JavaScript (dart compile js) for web --
// its most common real-world use is as Flutter's language, compiling to native ARM/x86 code
// for mobile/desktop apps via AOT compilation, not just running on a VM the way Java/Kotlin do.

void main() {
  print('Hello, Dart!');
  print('Dart version info is available via `dart --version` on the command line.');
  print('This file ran via `dart run example.dart` -- no separate compile step required for scripting.');
}
