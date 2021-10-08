import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(const WallPaperApp());
}

class WallPaperApp extends StatelessWidget {
  const WallPaperApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Home();
  }
}

