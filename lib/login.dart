import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:krish_biz/homepage.dart';
import 'package:krish_biz/selectsetregion.dart';
import 'package:krish_biz/setprices.dart';
import 'package:krish_biz/utils/auth_service.dart';
import 'package:krish_biz/utils/common_utils.dart';
import 'package:krish_biz/utils/size.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}


class _LoginState extends State<Login> {
  //text controllers
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textScaleFactor = ScaleSize.textScaleFactor(context);

    return Scaffold(

      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              // Color.fromARGB(255, 255, 255, 255),
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
                height: 0.064 * screenHeight,
              ),

              Align(
                alignment: Alignment.topLeft,
                child: IconButton(onPressed:(){
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back_ios_rounded),iconSize: 30,color: Colors.white,
                ),
              ),
                                          SizedBox(
                height: 0.064 * screenHeight,
              ),

              Container(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.48,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(140, 217, 217, 217),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 0.03 * screenHeight,
                      ),
                      Image.asset(
                        "assets/images/logo.png",
                        width: screenWidth * 0.2,
                        height: screenHeight * 0.1,
                      ),
                      Text(
                        "KrishMandi",
                        style: TextStyle(
                         fontSize: textScaleFactor * 12,
                          fontWeight:FontWeight.w900,
                          color: Color(0xffF5F5F5),
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(
                        height: 0.025 * screenHeight,
                      ),
                      SingleChildScrollView(
                        child: Container(
                          width: screenWidth * 0.8,
                          child: TextField(
                            maxLength: 100,
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText:"Email",
                              labelStyle: TextStyle(
                                color: Color.fromARGB(127, 75, 97, 79),
                                fontSize: 19.0 * textScaleFactor,
                                fontFamily: "Outfit",
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0,
                              ),
                              counterText: '',
                              suffixIcon: Icon(
                                Icons.mail_outline_outlined,
                                color: Color.fromARGB(127, 75, 97, 79),
                                size: 25.0 * textScaleFactor,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(127, 75, 97, 79),
                                    width: 2),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(127, 75, 97, 79),
                                    width: 2),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              fillColor: Colors.transparent,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 25.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0.02 * screenHeight,
                      ),
                      Container(
                        width: screenWidth * 0.8,
                        child: TextField(
                          maxLength: 100,
                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              color: Color.fromARGB(127, 75, 97, 79),
                              fontSize: 19.0 * textScaleFactor,
                              fontFamily: "Outfit",
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0,
                            ),
                            counterText: '',
                            suffixIcon: Icon(
                              Icons.lock_outline_rounded,
                              color: Color.fromARGB(127, 75, 97, 79),
                              size: 25.0 * textScaleFactor,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(127, 75, 97, 79),
                                  width: 2),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(127, 75, 97, 79),
                                  width: 2),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            fillColor: Colors.transparent,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 25.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0.03 * screenHeight,
                      ),
                      Container(
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.07,
                          decoration: BoxDecoration(
                            color: Color(0xff5C7744),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ElevatedButton(
                              onPressed: ()
                              async {
                                bool access = await AuthService.login(email: _emailController.text, password: _passwordController.text);
                                if(access==true)
                                {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SelectRegion()));
                                }
                                else{
                                  CUtils.toastMessage("Invalid Credentials");
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
                                }
                              },
    
                              style: ElevatedButton.styleFrom(
                                // backgroundColor: Color.fromARGB(255, 48, 62, 35),
                                backgroundColor:
                                    Color.fromARGB(255, 75, 97, 79),
                                foregroundColor:
                                    Color.fromARGB(255, 75, 97, 79),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text(
                                "Log In",
                                style: TextStyle(
                                  fontSize: textScaleFactor * 20,
                                  color: Color(0xffE3EBDE),
                                ),
                              ))),
                    ],
                  )),
              SizedBox(height: screenHeight * 0.04),
              Image(
                image: AssetImage(
                  "assets/images/loginfarmer2.png",
                ),
                width: screenWidth,
                height: 208,
              ),
            ],
          ),
        ),
      ),
    );
  }

  okay() {
    print("okays");
  }
}
