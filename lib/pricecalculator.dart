import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:krish_biz/utils/appbar.dart';
import 'package:krish_biz/utils/common_utils.dart';
import 'package:krish_biz/utils/size.dart';

class PriceCalculator extends StatefulWidget {
  final String state;

  const PriceCalculator({Key? key, required this.state}) : super(key: key);

  @override
  _PriceCalculateState createState() => _PriceCalculateState();
}

class _PriceCalculateState extends State<PriceCalculator> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final Map<String, int> vegetables = {};
  final Map<String, double> selectedWeights = {};
  final Map<String, String> selectedUnit = {}; // Track selected unit
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchVegetables();
  }

  Future<void> fetchVegetables() async {
    try {
      DocumentSnapshot doc = await db.collection("prices").doc(widget.state).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        vegetables.clear();

        if (data['vegetables'] is List) {
          for (var veg in data['vegetables']) {
            if (veg is Map<String, dynamic> && veg.containsKey('name') && veg.containsKey('price')) {
              vegetables[veg['name'].toString()] = int.tryParse(veg['price'].toString()) ?? 0;
            }
          }
        }

        setState(() {});
      }
    } catch (e) {
      print("Error fetching vegetables: $e");
    }
  }

  double calculateTotalPrice() {
    double total = 0.0;
    selectedWeights.forEach((veg, weight) {
      if (selectedUnit[veg] == 'kg') {
        total += (vegetables[veg]! * weight); // Price is for 1000g, so multiply by weight in kg
      } else {
        total += (vegetables[veg]! * (weight / 1000)); // Convert grams to kg
      }
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);

    List<String> filteredVegetables = vegetables.keys
        .where((veg) => veg.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: CustomAppBar.showAppBar("Price Calculator", true, textScaleFactor),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Vegetables",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: vegetables.isEmpty
                ? const Center(child: CircularProgressIndicator(color: Colors.green))
                : ListView.builder(
                    itemCount: filteredVegetables.length,
                    itemBuilder: (context, index) {
                      String veg = filteredVegetables[index];
                      return ListTile(
                        title: Text('$veg - ₹${vegetables[veg]}/kg'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 60,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(hintText: 'Wght'),
                                onChanged: (value) {
                                  setState(() {
                                    double quantity = double.tryParse(value) ?? 0.0;
                                    if (quantity < 100 && selectedUnit[veg] == 'gram') {
                                      CUtils.toastMessage("Quantity cannot be less than 100 grams");
                                    } else {
                                      selectedWeights[veg] = quantity;
                                    }
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            DropdownButton<String>(
                              value: selectedUnit[veg] ?? 'gram',
                              items: ['gram', 'kg'].map((unit) {
                                return DropdownMenuItem(
                                  value: unit,
                                  child: Text(unit),
                                );
                              }).toList(),
                              onChanged: (unit) {
                                setState(() {
                                  selectedUnit[veg] = unit!;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {
          double total = calculateTotalPrice();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.green, width: 2),
              ),
              title: const Text('Total Price'),
              content: Text('Total: ₹${total.toStringAsFixed(2)}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK', style: TextStyle(color: Colors.green)),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.calculate, color: Colors.white),
        label: const Text("Calculate", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}