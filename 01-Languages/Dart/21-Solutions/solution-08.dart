// solution-08.dart - Exercise 08 Capstone: JSON, Generics, and Null Safety Together.

import 'dart:convert';
import 'dart:io';

class Book {
  final String title;
  final String author;
  final int year;
  final double? rating; // nullable -- not every book has been rated

  Book(this.title, this.author, this.year, this.rating);

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        json['title'] as String,
        json['author'] as String,
        json['year'] as int,
        json['rating'] as double?, // `as double?` -- a null value deserializes cleanly, no cast error
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'author': author,
        'year': year,
        'rating': rating,
      };
}

// Generic over T: reusable for Book or any other type with a matching fromJson factory,
// proving generics compose cleanly with the dart:convert pattern from Lesson 10.
List<T> parseJsonList<T>(String jsonText, T Function(Map<String, dynamic>) fromJson) {
  var decoded = jsonDecode(jsonText) as List<dynamic>;
  return decoded.map((item) => fromJson(item as Map<String, dynamic>)).toList();
}

void main() {
  var books = [
    Book('Atomic Habits', 'James Clear', 2018, 4.8),
    Book('Clean Code', 'Robert Martin', 2008, 4.2),
    Book('Deep Work', 'Cal Newport', 2016, 4.3),
    Book('Dart in Action', 'Chris Buckett', 2013, null), // unrated
    Book('Effective Dart', 'Google', 2020, 4.6),
    Book('The Pragmatic Programmer', 'Hunt & Thomas', 1999, null), // unrated
  ];

  var tempFile = File('${Directory.systemTemp.path}/dart_books_exercise08.json');

  print('--- serializing ${books.length} books to ${tempFile.path} ---');
  var jsonText = jsonEncode(books.map((b) => b.toJson()).toList());
  tempFile.writeAsStringSync(jsonText);

  print('\n--- reading back and deserializing ---');
  var readBackText = tempFile.readAsStringSync();
  var deserialized = parseJsonList(readBackText, Book.fromJson);
  print('Deserialized ${deserialized.length} books.');

  print('\n--- books after 2015 with rating >= 4.0, sorted by rating desc ---');
  var filtered = deserialized.where((b) => b.year > 2015 && b.rating != null && b.rating! >= 4.0).toList()
    ..sort((a, b) => b.rating!.compareTo(a.rating!));
  for (var b in filtered) {
    print('  ${b.title} (${b.year}) by ${b.author} -- ${b.rating}');
  }

  tempFile.deleteSync();
  print('\nCleanup check -- file still exists: ${tempFile.existsSync()}');
}
