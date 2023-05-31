import 'dart:convert';
import 'package:http/http.dart' as http;

class BookDetailResponse {
  String? error;
  String? title;
  String? subtitle;
  List<String>? authorNames;
  List<String>? publishers;
  String? language;
  List<String>? isbns;
  String? numberOfPages;
  String? firstPublishYear;
  String? coverImage;

  BookDetailResponse({
    this.error,
    this.title,
    this.subtitle,
    this.authorNames,
    this.publishers,
    this.language,
    this.isbns,
    this.numberOfPages,
    this.firstPublishYear,
    this.coverImage,
  });

  factory BookDetailResponse.fromJson(Map<String, dynamic> json) {
    return BookDetailResponse(
      error: json['error'],
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      authorNames: (json['author_name'] as List<dynamic>?)
          ?.map((name) => name.toString())
          .toList(),
      publishers: (json['publisher'] as List<dynamic>?)
          ?.map((publisher) => publisher.toString())
          .toList(),
      language: json['language'] as String?,
      isbns: (json['isbn'] as List<dynamic>?)
          ?.map((isbn) => isbn.toString())
          .toList(),
      numberOfPages: json['number_of_pages'] as String?,
      firstPublishYear: json['first_publish_year'] as String?,
      coverImage: json['cover_i'] != null
          ? 'http://covers.openlibrary.org/b/id/${json['cover_i']}-M.jpg'
          : null,
    );
  }
}

class Books {
  String? title;
  String? subtitle;
  List<String>? isbns;
  List<String>? publishers;
  List<String>? authorNames;
  String? coverImage;

  Books({
    this.title,
    this.subtitle,
    this.isbns,
    this.publishers,
    this.authorNames,
    this.coverImage,
  });

  factory Books.fromJson(Map<String, dynamic> json) {
    return Books(
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      isbns: (json['isbn'] as List<dynamic>?)
          ?.map((isbn) => isbn.toString())
          .toList(),
      publishers: (json['publisher'] as List<dynamic>?)
          ?.map((publisher) => publisher.toString())
          .toList(),
      authorNames: (json['author_name'] as List<dynamic>?)
          ?.map((name) => name.toString())
          .toList(),
      coverImage: json['cover_i'] != null
          ? 'http://covers.openlibrary.org/b/id/${json['cover_i']}-M.jpg'
          : null,
    );
  }
}

Future<List<Books>> fetchBooks() async {
  final response = await http.get(Uri.parse(
      'http://openlibrary.org/search.json?q=software+engineering&limit=10'));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final bookList = jsonData['docs'] as List<dynamic>;

    List<Books> filteredBooks = [];

    bookList.forEach((bookData) {
      Books book = Books.fromJson(bookData);
      if (book.coverImage != null) {
        filteredBooks.add(book);
      }
    });

    return filteredBooks;
  } else {
    throw Exception('Failed to fetch books');
  }
}
