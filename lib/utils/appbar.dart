import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class   CustomAppBar {

  static PreferredSizeWidget? showAppBar(String text, bool automaticallyImplyLeading, double textScaleFactor){
    return AppBar(
      centerTitle: !automaticallyImplyLeading,
      automaticallyImplyLeading: automaticallyImplyLeading,
        title: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20 * textScaleFactor,
              color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        backgroundColor: Colors.green[300],
      );

  }

}
