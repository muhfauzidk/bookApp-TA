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
    var url = Uri.parse('https://api.itbook.store/1.0/new');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonBookList = jsonDecode(response.body);
      setState(() {
        bookList = BookListResponse.fromJson(jsonBookList);
      });
    }
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
          : ListView.builder(
              itemCount: bookList!.books!.length,
              itemBuilder: (context, index) {
                final currentBook = bookList!.books![index];
                return Container(
                  // padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: index == 0
                        ? const Border() // This will create no border for the first item
                        : Border(
                            top: BorderSide(
                                width: 1,
                                color: Theme.of(context)
                                    .primaryColor)), // This will create top borders for the rest
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetailBookScreen(
                            isbn: currentBook.isbn13!,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Image.network(
                          currentBook.image!,
                          height: 100,
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(currentBook.title!),
                                // Text(currentBook.subtitle!),
                                const SizedBox(height: 15),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      currentBook.price!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
