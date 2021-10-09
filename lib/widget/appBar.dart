
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// ignore: non_constant_identifier_names
Widget AppBarWidget(){

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('WallPaper',style: TextStyle(color: Colors.black,fontSize: 25),),
      Text('Spot',style:GoogleFonts.roboto(fontSize: 25,color: Colors.pink) ),
    ],
  );

}


