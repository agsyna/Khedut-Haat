

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:krish_biz/models/vegetable.dart';
import 'package:krish_biz/utils/appbar.dart';
import 'package:krish_biz/utils/size.dart';

class ViewPrice extends StatefulWidget {
  final String state;

  const ViewPrice({Key? key, required this.state}) : super(key: key);

  @override
  _ViewPriceState createState() => _ViewPriceState();
}

class _ViewPriceState extends State<ViewPrice> {

  @override
  void initState() {
    super.initState();
    fetchVegetables();
    setState(() {
      
    });
  }

  List<Vegetable> vegetableData = [];
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> fetchVegetables() async {
    try {
      DocumentSnapshot doc = await db.collection("prices").doc(widget.state).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        print(" data : ${data['vegetables']}");

        for(int i=0;i<data['vegetables'].length; i++)
        {
            vegetableData.add(new Vegetable(name: data['vegetables'][i]["name"] ?? "", image: data['vegetables'][i]["image"] ?? "", price: data['vegetables'][i]["price"] ?? 0));
        }

        setState(() {;
        });
      }
      print("Fetched Vegetables: $vegetableData");
    } catch (e) {
      print("Error fetching vegetables: $e");
    }

  }


  Widget build(BuildContext context)
  {
        double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    
        return Scaffold(
      appBar: CustomAppBar.showAppBar("View Prices",true,textScaleFactor),
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
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: 
            
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < vegetableData.length; i++)
                              Column(
          children: [

                 Container(
          padding: EdgeInsets.symmetric(
              horizontal: 0.05 * screenWidth),
          width: screenWidth,
          height:screenHeight * 0.097,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
              Color.fromARGB(255, 255, 255, 255),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(color: Colors.grey),
              ),
            ),
            onPressed: () {},
            child: Row(
              children: [
                    Column(children: [

                      Image (
                        image : 
                        NetworkImage(
                        vegetableData[i].image,
                        ),
                        // width: 10,
                        height: 72,
                      ),


                    ],),

                    SizedBox(
                      width: screenWidth*0.05,
                    ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Container(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Name : ",
                                style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 12,
                                  fontFamily: "Outfit",
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text:
                                "${vegetableData[i].name}",
                                style: TextStyle(
                                  fontWeight:
                                  FontWeight.normal,
                                  fontSize: 11,
                                  fontFamily: "Outfit",
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Price : ",
                                style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 12,
                                  fontFamily: "Outfit",
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text:
                                "${vegetableData[i].price}",
                                style: TextStyle(
                                  fontWeight:
                                  FontWeight.normal,
                                  fontSize: 11,
                                  fontFamily: "Outfit",
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.005,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
            SizedBox(
              height: screenHeight*0.02,
              width: screenWidth,
            )

              ],
            ),
              ],
            ),
          ),
        ),
      ), 
        );

  }
}


