import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'fullscreen.dart';

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
      home: SafeArea(
        child: Scaffold(
          // backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                // height: MediaQuery.of(context).size.height/16,
                // width: MediaQuery.of(context).size.width,
                // color: Colors.orange,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(40),
                ),
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'search',
                        ),
                      ),
                    ),
                    InkWell(onTap: () {}, child: Icon(Icons.search)),
                  ],
                ),
              ),

              // ignore: prefer_const_constructors
              // SizedBox(
              //   height: 20,
              // ),
              Expanded(
                // ignore: avoid_unnecessary_containers
                child: Container(
                  child: GridView.builder(
                    itemCount: images.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            childAspectRatio: 2 / 4,
                            crossAxisCount: 3),
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
              InkWell(
                onTap: () {
                  loadMore();
                },
                child: Container(
                  height: 30,
                  width: double.infinity,
                  child: const Center(child: Text('Load More')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
