import 'package:book_app/data.dart';
import 'package:book_app/detail_book_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BookListResponse? bookList;

  @override
  void initState() {
    super.initState();
    fetchBookApi();
  }

  fetchBookApi() async {
    var currentPage = 1;
    var totalPages = 100;
    var totalBooks = [];

    do {
      var url =
          Uri.parse('https://api.itbook.store/1.0/search/the/$currentPage');
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonBookList = jsonDecode(response.body);
        totalPages = jsonBookList['totalPages'] as int? ?? 0;

        final books = jsonBookList['books'];
        totalBooks.addAll(books.map((book) => Books.fromJson(book)).toList());
      }

      currentPage++;
    } while (currentPage <= 100);

    setState(() {
      bookList = BookListResponse(total: totalPages, books: totalBooks);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Catalogue"),
        centerTitle: true,
      ),
      body: bookList == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                for (var book in bookList!.books!)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetailBookScreen(
                            isbn: book.isbn13!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Image.network(
                            book.image!,
                            height: 100,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(book.title!),
                                  const SizedBox(height: 15),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      book.price!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
