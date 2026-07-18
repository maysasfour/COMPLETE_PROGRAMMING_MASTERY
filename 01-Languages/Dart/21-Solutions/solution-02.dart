// solution-02.dart - Exercise 02: Cascade Operator Fluent Builder.

class HttpRequestBuilder {
  String method = 'GET';
  String path = '/';
  Map<String, String> headers = {};

  void setMethod(String m) => method = m;
  void setPath(String p) => path = p;
  void addHeader(String key, String value) => headers[key] = value;

  String build() {
    var lines = [
      '$method $path',
      for (var entry in headers.entries) '  ${entry.key}: ${entry.value}',
    ];
    return lines.join('\n');
  }
}

void main() {
  print('--- Built via cascade (..) ---');
  // Every method above returns void -- a cascade doesn't care about the return value
  // of each call at all. `..` re-evaluates to the ORIGINAL receiver (the freshly-built
  // HttpRequestBuilder) after each call, not whatever setMethod/setPath/addHeader returned,
  // which is exactly why chaining works even though none of them return `this`.
  var cascaded = HttpRequestBuilder()
    ..setMethod('POST')
    ..setPath('/users')
    ..addHeader('Authorization', 'Bearer xyz')
    ..addHeader('Accept', 'application/json');
  print(cascaded.build());

  print('\n--- Built the verbose way ---');
  var verbose = HttpRequestBuilder();
  verbose.setMethod('POST');
  verbose.setPath('/users');
  verbose.addHeader('Authorization', 'Bearer xyz');
  verbose.addHeader('Accept', 'application/json');
  print(verbose.build());

  print('\n--- Both produce identical output: ${cascaded.build() == verbose.build()} ---');
}
