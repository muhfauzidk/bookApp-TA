// import 'package:book_app/data.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart';

// class DetailBookScreen extends StatefulWidget {
//   const DetailBookScreen({Key? key, required this.isbn});

//   final String isbn;

//   @override
//   State<DetailBookScreen> createState() => _DetailBookScreenState();
// }

// class _DetailBookScreenState extends State<DetailBookScreen> {
//   BookDetailResponse? detailBook;
//   BookListResponse? similarBooks;

//   @override
//   void initState() {
//     super.initState();
//     fetchDetailBookApi(widget.isbn);
//   }

//   fetchDetailBookApi(String isbn) async {
//     var url = Uri.parse('https://api.itbook.store/1.0/books/$isbn');
//     var response = await http.get(url);
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');

//     if (response.statusCode == 200) {
//       final jsonDetail = jsonDecode(response.body);
//       setState(() {
//         detailBook = BookDetailResponse.fromJson(jsonDetail);
//       });
//       fetchSimilarBookApi(detailBook!.title!);
//     }
//   }

//   fetchSimilarBookApi(String title) async {
//     var url = Uri.parse('https://api.itbook.store/1.0/search/$title');
//     var response = await http.get(url);
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');

//     if (response.statusCode == 200) {
//       final jsonDetail = jsonDecode(response.body);
//       setState(() {
//         similarBooks = BookListResponse.fromJson(jsonDetail);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("Detail"),
//           centerTitle: true,
//         ),
//         body: detailBook == null
//             ? const Center(child: CircularProgressIndicator())
//             : Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ImageViewScreen(
//                                     imageUrl: detailBook!.image!),
//                               ),
//                             );
//                           },
//                           child: Image.network(
//                             detailBook!.image!,
//                             height: 200,
//                           ),
//                         ),
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.only(bottom: 10.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   detailBook!.title!,
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 2),
//                                 Text(
//                                   detailBook!.authors!,
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey[700],
//                                   ),
//                                 ),
//                                 Row(
//                                   children: List.generate(
//                                       5,
//                                       (index) => Icon(
//                                             Icons.star,
//                                             color: index <
//                                                     int.parse(
//                                                         detailBook!.rating!)
//                                                 ? Colors.yellow
//                                                 : Colors.grey,
//                                           )),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 Text(
//                                   detailBook!.subtitle!,
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.grey[700],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 5),
//                                 Text(
//                                   detailBook!.price!,
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.green,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           fixedSize: const Size(double.infinity, 50),
//                           backgroundColor: Colors.green,
//                         ),
//                         onPressed: () async {
//                           Uri uri = Uri.parse(detailBook!.url!);
//                           try {
//                             (await canLaunchUrl(uri))
//                                 ? launchUrl(uri)
//                                 : debugPrint("tidak berhasil navigasi");
//                           } catch (e) {
//                             debugPrint("error");
//                           }
//                         },
//                         child: const Text("BUY"),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Text(detailBook!.desc!),
//                     const SizedBox(height: 20),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Text("Year: ${detailBook!.year!}"),
//                         Text("ISBN ${detailBook!.isbn13!}"),
//                         Text("${detailBook!.pages!} Page"),
//                         Text("Publisher: ${detailBook!.publisher!}"),
//                         Text("Language: ${detailBook!.language!}"),
//                       ],
//                     ),
//                     const Divider(thickness: 1.0),
//                     const SizedBox(height: 10),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: const [
//                         Text(
//                           "Similar Books",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         )
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     similarBooks == null
//                         ? const CircularProgressIndicator()
//                         : SizedBox(
//                             height: 170,
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               scrollDirection: Axis.horizontal,
//                               itemCount: similarBooks!.books!.length,
//                               // physics: NeverScrollableScrollPhysics(),
//                               itemBuilder: (context, index) {
//                                 final current = similarBooks!.books![index];
//                                 return SizedBox(
//                                   width: 130,
//                                   child: Column(
//                                     children: [
//                                       Image.network(current.image!,
//                                           height: 110),
//                                       Text(
//                                         current.title!,
//                                         maxLines: 3,
//                                         textAlign: TextAlign.center,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: const TextStyle(
//                                           fontSize: 12,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                   ],
//                 ),
//               ));
//   }
// }

// class ImageViewScreen extends StatelessWidget {
//   const ImageViewScreen({super.key, required this.imageUrl});
//   final String imageUrl;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Image.network(imageUrl),
//             const BackButton(),
//           ],
//         ),
//       ),
//     );
//   }
// }
