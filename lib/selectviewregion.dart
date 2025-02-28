import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:krish_biz/utils/appbar.dart';
import 'package:krish_biz/utils/size.dart';
import 'package:krish_biz/viewprices.dart';

class SelectViewRegion extends StatefulWidget {
  @override
  _SelectViewRegionState createState() => _SelectViewRegionState();
}

class _SelectViewRegionState extends State<SelectViewRegion> {
  late Future<List<String>> _statesFuture;

  @override
  void initState() {
    super.initState();
    _statesFuture = fetchVegetables();
  }

  Future<List<String>> fetchVegetables() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('prices').get();
      List<String> states = snapshot.docs.map((doc) => doc.id).toList();
      print("Fetched Vegetables: $states");
      return states;
    } catch (e) {
      print("Error fetching vegetables: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);

    return Scaffold(
    appBar: CustomAppBar.showAppBar("Select Region",true,textScaleFactor),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/homepagebg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<String>>(
          future: _statesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child:  CircularProgressIndicator(color: Colors.green,));
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error fetching data"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No data available"));
            }

            List<String> statesData = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(1),
              itemCount: statesData.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color.fromARGB(91, 151, 211, 154),
                  
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    title: Text(
                      statesData[index],
                      style: TextStyle(
                        fontSize: 18 * textScaleFactor,
                        fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ViewPrice(state: statesData[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
