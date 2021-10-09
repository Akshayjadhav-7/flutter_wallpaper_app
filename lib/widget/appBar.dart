
import 'package:flutter/material.dart';


// ignore: non_constant_identifier_names
Widget AppBarWidget(){

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('WallPaper',style: TextStyle(color: Colors.black,fontSize: 25),),
      Text('Spot',style: TextStyle(color: Colors.pink,fontSize: 25)),
    ],
  );

}