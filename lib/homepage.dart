import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:krish_biz/login.dart';
import 'package:krish_biz/selectcalculatestate.dart';
import 'package:krish_biz/selectsetregion.dart';
import 'package:krish_biz/selectviewregion.dart';
import 'package:krish_biz/utils/appbar.dart';
import 'package:krish_biz/utils/size.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Widget customButton({
    required VoidCallback onPressed,
    required String imagePath,
    required String buttonText,
    required double screenHeight,
    required double screenWidth,
    required double textScaleFactor,
  }) {
    return Card(
      elevation: 10,
      shadowColor: const Color.fromARGB(81, 217, 220, 217),
      color: const Color.fromARGB(100, 219, 222, 219),
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.green[300]!, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: 0.168 * screenHeight,
        width: 0.378 * screenWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(38, 255, 255, 255),
            foregroundColor: const Color.fromARGB(76, 255, 255, 255),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screenWidth * 0.16,
                height: screenHeight * 0.10,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Text(
                buttonText,
                style: TextStyle(
                  fontSize: 16 * textScaleFactor,
                  color: const Color(0xff5C7744),
                  fontWeight: FontWeight.w900,
                  fontFamily: "Outfit",
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double textScaleFactor = ScaleSize.textScaleFactor(context);

    return Scaffold(
      appBar: CustomAppBar.showAppBar(
        "Sristi khedut haat",
        false,
        textScaleFactor,
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/homepagebg.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: screenHeight * 0.4,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        customButton(
                            onPressed: () {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SelectRegion()));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()));
                              }
                            },
                            imagePath: "assets/icons/setprices.png",
                            buttonText: "Set Prices",
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            textScaleFactor: textScaleFactor),
                        customButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SelectViewRegion()));
                            },
                            imagePath: "assets/icons/viewprices.png",
                            buttonText: "View Prices",
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            textScaleFactor: textScaleFactor),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        customButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SelectCalculateRegion()));
                            },
                            imagePath: "assets/icons/calculate.png",
                            buttonText: "Calculate",
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            textScaleFactor: textScaleFactor),
                        // customButton(
                        //     onPressed: () {

                        //     },
                        //     imagePath: "assets/icons/faqs.png",
                        //     buttonText:
                        //         "FAQS" ,
                        //     screenHeight: screenHeight,
                        //     screenWidth: screenWidth,
                        //     textScaleFactor: textScaleFactor),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
