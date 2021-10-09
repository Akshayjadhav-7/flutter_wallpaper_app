import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import './serach_screen.dart';
import '../widget/appBar.dart';
import './fullscreen.dart';

var key = GlobalKey<FormState>();
List searchImage = [];
TextEditingController searchController = TextEditingController();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List images = [];

  int page = 1;

  @override
  void initState() {
    super.initState();
    fetchApi();
    // searchApi();
  }

  searchApi() async {
    await http.get(
        Uri.parse(
            'https://api.pexels.com/v1/search?query=${searchController.text}?per_page=15'),
        headers: {
          'Authorization':
              '563492ad6f917000010000010e72094cf8cf498ab463d7c70cb1a403'
        }).then((value) {
      Map result = jsonDecode(value.body);
      print(value.body);
      setState(() {
        searchImage = result['photos'];
      });
    });
  }

  fetchApi() async {
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization':
              '563492ad6f917000010000010e72094cf8cf498ab463d7c70cb1a403'
        }).then((value) {
      Map result = jsonDecode(value.body);
      print(value.body);
      setState(() {
        images = result['photos'];
      });
      print(images.length);
    });
  }

  loadMore() async {
    setState(() {
      page = page + 1;
    });

    String url =
        'https://api.pexels.com/v1/curated?per_page=80&page' + page.toString();
    await http.get(Uri.parse(url), headers: {
      'Authorization':
          '563492ad6f917000010000010e72094cf8cf498ab463d7c70cb1a403'
    }).then((value) {
      Map result = jsonDecode(value.body);
      print(result);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: AppBarWidget(),
        ),
        // backgroundColor: Colors.white,
        body: Form(
          key: key,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 16,
                    // width: MediaQuery.of(context).size.width,

                    decoration: BoxDecoration(
                      color: Color(0xffE7F2F8),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    margin: EdgeInsets.all(15),
                    // padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'search can not  be empty';
                              }
                              return null;
                            },
                            controller: searchController,
                            // ignore: prefer_const_constructors
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'search',
                              hintStyle: TextStyle(
                                  fontSize: 20, color: Colors.black12),
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              if (key.currentState!.validate()) {
                                searchApi();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SearchedResultScreen()));
                              } else {
                                print('false');
                              }
                              // searchApi();

                              print(searchController);
                              setState(() {
                                searchController.text = "";
                              });
                            },
                            // ignore: prefer_const_constructors
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                              // ignore: prefer_const_constructors
                              child: Icon(
                                Icons.search,
                                size: 30,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    // ignore: avoid_unnecessary_containers
                    child: Container(
                      child: GridView.builder(
                        itemCount: images.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 2,
                                crossAxisSpacing: 2,
                                childAspectRatio: 2 / 3,
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FullScreen(
                                            imageurl: images[index]['src']
                                                ['large2x'],
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    images[index]['src']['tiny'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () {
                      loadMore();
                    },
                    // ignore: prefer_const_constructors
                    child: SizedBox(
                      height: 30,
                      width: double.infinity,
                      child: const Icon(
                        Icons.arrow_drop_down_circle,
                        size: 50,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            // child: Column(
            //   children: [
            //     Container(
            //       height: MediaQuery.of(context).size.height / 16,
            //       // width: MediaQuery.of(context).size.width,
            //
            //       decoration: BoxDecoration(
            //         color: Color(0xffE7F2F8),
            //         borderRadius: BorderRadius.circular(40),
            //       ),
            //       margin: EdgeInsets.all(15),
            //       // padding: EdgeInsets.all(5),
            //       child: Row(
            //         children: [
            //           Expanded(
            //             child: TextFormField(
            //
            //               validator: (value) {
            //                 if (value!.isEmpty) {
            //                   return 'search can not  be empty';
            //                 }
            //                 return null;
            //               },
            //               controller: searchController,
            //               // ignore: prefer_const_constructors
            //               decoration: InputDecoration(
            //                 border: InputBorder.none,
            //                 hintText: 'search',
            //                 hintStyle:
            //                     TextStyle(fontSize: 20, color: Colors.black12),
            //                 contentPadding: EdgeInsets.all(16),
            //               ),
            //
            //             ),
            //           ),
            //           InkWell(
            //               onTap: () {
            //
            //                 if (key.currentState!.validate()) {
            //                   Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                           builder: (context) =>
            //                               SearchedResultScreen()));
            //                 }else{
            //                   print('false');
            //                 }
            //                 searchApi();
            //
            //                 print(searchController);
            //                 setState(() {
            //                   searchController.text = "";
            //                 });
            //               },
            //               // ignore: prefer_const_constructors
            //               child: Padding(
            //                 padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            //                 // ignore: prefer_const_constructors
            //                 child: Icon(
            //                   Icons.search,
            //                   size: 30,
            //                 ),
            //               )),
            //         ],
            //       ),
            //     ),
            //     Expanded(
            //       // ignore: avoid_unnecessary_containers
            //       child: Container(
            //         child: GridView.builder(
            //           itemCount: images.length,
            //           gridDelegate:
            //               const SliverGridDelegateWithFixedCrossAxisCount(
            //                   mainAxisSpacing: 2,
            //                   crossAxisSpacing: 2,
            //                   childAspectRatio: 2 / 3,
            //                   crossAxisCount: 2),
            //           itemBuilder: (context, index) {
            //             return InkWell(
            //               onTap: () {
            //                 Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: (context) => FullScreen(
            //                               imageurl: images[index]['src']
            //                                   ['large2x'],
            //                             )));
            //               },
            //               child: Padding(
            //                 padding: const EdgeInsets.all(2.0),
            //                 child: Container(
            //                   child: ClipRRect(
            //                     borderRadius: BorderRadius.circular(8),
            //                     child: Image.network(
            //                       images[index]['src']['tiny'],
            //                       fit: BoxFit.cover,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             );
            //           },
            //         ),
            //       ),
            //     ),
            //     InkWell(
            //       onTap: () {
            //         loadMore();
            //       },
            //       child: SizedBox(
            //         height: 30,
            //         width: double.infinity,
            //         child: const Center(child: Text('Load More')),
            //       ),
            //     ),
            //   ],
            // ),
          ),
        ),
      ),
    );
  }
}
