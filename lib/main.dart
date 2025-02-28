import 'dart:async';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:krish_biz/firebase_options.dart';
import 'package:krish_biz/homepage.dart';
import 'package:krish_biz/utils/size.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://sjaagvbvdtgrpqclzlfk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNqYWFndmJ2ZHRncnBxY2x6bGZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAyMTA3MDcsImV4cCI6MjA1NTc4NjcwN30.jdXmkaj2OrHbmxQeTk5ISgrdXyqmgD5fUDQjBeI_v-s',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Krish-Biz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "Krish-Biz"),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const Homepage())));

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textScaleFactor = ScaleSize.textScaleFactor(context);
  

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color(0xff9FC784),
            Color(0xff599522),
          ],
          stops: [0, 90],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: Column(
          children: [
            SizedBox(
              height: 0.3 * screenHeight,
            ),
            Image.asset(
              "assets/images/logo.png",
              width: screenWidth * 0.4,
              height: screenHeight * 0.2,
            ),
            Text(
              "Sristi Khedut Haat",
              style: TextStyle(
                fontSize: textScaleFactor * 40,
                fontWeight:FontWeight.w900,
                color: const Color(0xffF5F5F5),
                letterSpacing: 1,
              ),
            ),
            Text(
              "",
              style: TextStyle(
                fontFamily: "Mulish",
                fontSize: textScaleFactor * 20,
                fontWeight: FontWeight.w400,
                color: const Color(0xff599522),
                // color: Colors.white
              ),
            ),
            SizedBox(
              height: 0.04 * screenHeight,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image(
                alignment: Alignment.bottomCenter,
                image: const AssetImage(
                  "assets/images/splashplants.png",
                ),
                width: screenWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Directionality(
          textDirection: TextDirection.ltr,
          child: Text(text),
        ),
      ),
    );
  }
}