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
  List<Books>? bookList;
  double titleFontSize = 16.0;
  Color homeScreenBackgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    fetchBookApi();
  }

  fetchBookApi() async {
    var url = Uri.parse('http://openlibrary.org/search.json?q=a&limit=100');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

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

      setState(() {
        this.bookList = filteredBooks;
      });
    }
  }

  void increaseTitleFontSize() {
    setState(() {
      titleFontSize += 10;
    });
  }

  void decreaseTitleFontSize() {
    setState(() {
      titleFontSize -= 10;
    });
  }

  void changeBackgroundColor() {
    setState(() {
      homeScreenBackgroundColor = Colors.cyan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homeScreenBackgroundColor,
      appBar: AppBar(
        title: const Text("Book Catalogue"),
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Increase title font size"),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("Decrease title font size"),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Text("Change background color"),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 0) {
                print("Increase title font size menu is selected.");
                increaseTitleFontSize();
              } else if (value == 1) {
                decreaseTitleFontSize();
              } else if (value == 2) {
                changeBackgroundColor();
              }
            },
          ),
        ],
      ),
      body: bookList == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bookList!.length,
              itemBuilder: (context, index) {
                final book = bookList![index];
                return GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => DetailBookScreen(
                    //       isbn: book.isbns!.first,
                    //     ),
                    //   ),
                    // );
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
                          book.coverImage!,
                          height: 100,
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.title!,
                                  style: TextStyle(fontSize: titleFontSize),
                                ),
                                const SizedBox(height: 15),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "book.price!",
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
                );
              },
            ),
    );
  }
}
