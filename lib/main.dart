import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  // ignore: prefer_const_constructors
  runApp(MaterialApp(home: const WallPaperApp(),debugShowCheckedModeBanner: false,));
}

class WallPaperApp extends StatelessWidget {
  const WallPaperApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Home();
  }
}

