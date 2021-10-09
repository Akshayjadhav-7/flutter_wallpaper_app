import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import './fullscreen.dart';
import '../widget/appBar.dart';
import './home.dart';

class SearchedResultScreen extends StatefulWidget {
  const SearchedResultScreen({Key? key}) : super(key: key);

  @override
  _SearchedResultScreenState createState() => _SearchedResultScreenState();
}

class _SearchedResultScreenState extends State<SearchedResultScreen> {
  int page = 1;

  loadMore() async {
    setState(() {
      page = page + 1;
    });

    String url =
        'https://api.pexels.com/v1/search?query=${searchController.text}?per_page=15' +
            page.toString();
    await http.get(Uri.parse(url), headers: {
      'Authorization':
          '563492ad6f917000010000010e72094cf8cf498ab463d7c70cb1a403'
    }).then((value) {
      Map result = jsonDecode(value.body);
      print(result);
      setState(() {
        searchImage.addAll(result['photos']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // create: (context) => GridView.instance(),
    return Scaffold(
      appBar: AppBar(
        title: AppBarWidget(),
        // backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  child: GridView.builder(
                      itemCount: searchImage.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FullScreen(
                                          imageurl: searchImage[index]['src']
                                              ['large2x'],
                                        )));
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                searchImage[index]['src']['tiny'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: () {
                      loadMore();
                      print('searchImage line no 97:$searchImage');
                    },
                    child: const Icon(
                      Icons.arrow_drop_down_circle,
                      size: 50,
                      color: Colors.pink,
                    )),
              )),
        ],
      ),
    );
  }
}
