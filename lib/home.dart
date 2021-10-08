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
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          // backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                // ignore: avoid_unnecessary_containers
                child: Container(
                  child: GridView.builder(
                    itemCount: images.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
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
                        child: Container(
                          color: Colors.white,
                          child: Image.network(
                            images[index]['src']['tiny'],
                            fit: BoxFit.cover,
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
