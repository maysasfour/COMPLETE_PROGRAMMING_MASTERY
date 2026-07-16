// example.dart - HTTP requests via dart:io's built-in HttpClient (no external package
// needed for basic requests, unlike Rust/C++ covered earlier in this repository -- though
// the `http` pub.dev package is the more commonly used, more convenient wrapper in real
// Dart/Flutter code). Like every other HTTP client covered in this repository except
// Rust's ureq, Dart's HttpClient does NOT throw on 404/500 -- verified live below.
// Plus dart:convert (Lesson 10) for JSON.

import 'dart:io';
import 'dart:convert';

void main() async {
  final client = HttpClient();

  print('--- GET ---');
  var request = await client.getUrl(Uri.parse('https://jsonplaceholder.typicode.com/todos/1'));
  var response = await request.close();
  print('status: ${response.statusCode}');
  var body = await response.transform(utf8.decoder).join();
  var todo = jsonDecode(body) as Map<String, dynamic>;
  print('Decoded: id=${todo['id']}, userId=${todo['userId']}, title=${todo['title']}, completed=${todo['completed']}');

  print('\n--- GET a route that returns 404 -- NO exception thrown ---');
  var notFoundRequest = await client.getUrl(Uri.parse('https://jsonplaceholder.typicode.com/todos/99999999'));
  var notFoundResponse = await notFoundRequest.close();
  print('status: ${notFoundResponse.statusCode} (a normal response, not a thrown exception -- verified live)');
  var notFoundBody = await notFoundResponse.transform(utf8.decoder).join();
  print('body: $notFoundBody');

  print('\n--- POST with a JSON body ---');
  var postRequest = await client.postUrl(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
  postRequest.headers.contentType = ContentType.json;
  var payload = jsonEncode({'title': 'Learn Dart HttpClient', 'completed': false, 'userId': 1});
  postRequest.write(payload);
  var postResponse = await postRequest.close();
  print('status: ${postResponse.statusCode}');
  var postBody = await postResponse.transform(utf8.decoder).join();
  print('body (echoed back with a fake id): $postBody');

  client.close();
}
