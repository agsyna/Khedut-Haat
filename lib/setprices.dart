import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:krish_biz/utils/appbar.dart';
import 'package:krish_biz/utils/photo_utils.dart';
import 'package:krish_biz/utils/size.dart';
import 'package:supabase_flutter/supabase_flutter.dart';




class SetPrice extends StatefulWidget {
    final String state;

    const SetPrice({Key? key , required this.state}) : super(key:key);

  @override
  _SetPriceState createState() => _SetPriceState();
}

class _SetPriceState extends State<SetPrice> {

    TextEditingController _nameController = TextEditingController();
    TextEditingController _priceController = TextEditingController();

    Uint8List? image;

    final supabase = Supabase.instance.client;
    String? imageUrl;

    void initState() {
    super.initState();
    setState(() {
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();

    
    super.dispose();
  }

  Future<void> selectAndUploadImage(
      BuildContext context, Function(String) onUploadComplete) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.green, width: 2)),
          title: const Text("Select Image", style: TextStyle(fontWeight: FontWeight.w600),),
          children: [
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                await handleImageSelection(
                    ImageSource.camera, onUploadComplete);
              },
              child: const Text("Camera", style: TextStyle(fontWeight: FontWeight.w400),),
            ),
            const Divider(),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                await handleImageSelection(
                    ImageSource.gallery, onUploadComplete);
              },
              child: const Text("Gallery", style: TextStyle(fontWeight: FontWeight.w400)),
            ),
            const Divider(),

            SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Future<void> handleImageSelection(
      ImageSource source, Function(String) onUploadComplete) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null) return;

    File file = File(pickedFile.path);
    Uint8List fileBytes = await file.readAsBytes(); // Convert file to Uint8List
    String fileName = 'user_${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
      await supabase.storage.from('Images').upload(fileName, file);
      String imageUrl = supabase.storage.from('Images').getPublicUrl(fileName);

      setState(() {
        image = fileBytes;
        this.imageUrl = imageUrl;
      });

      onUploadComplete(imageUrl);
    } catch (e) {
      print('Upload error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to upload image. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    
    String dropdownState = widget.state;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double textScaleFactor = ScaleSize.textScaleFactor(context);

    return Scaffold(
      appBar: CustomAppBar.showAppBar("Set Price",true,textScaleFactor),

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
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.04),
                image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            Image.memory(image!,
                                height: 200, fit: BoxFit.cover),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  image = null;
                                });
                              },
                              child: Container(
                                height: 20,
                                width: 20,
                                alignment: Alignment.topRight,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () 
                          {
                          selectAndUploadImage(context, (imageUrl) {
                            setState(() {
                              this.imageUrl = imageUrl;
                            });
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt,
                                  size: 50, color: Colors.black54),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Add image",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                    counterText: '',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[350]!),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.green[300]!),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // onTap: _selectDate,
                ),
                const SizedBox(height: 16),
                TextField(
                  maxLength: 75,
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: "Price",
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                    suffixIcon: const Icon(
                      Icons.balance,
                      color: Colors.grey,
                      size: 25.0,
                    ),
                    counterText: '',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[350]!),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.green[300]! ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      uploadData(context, dropdownState);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:Colors.green[300],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Set Price",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            title: const Text("Select Image"),
            children: [
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    image = file;
                  });
                },
                child: const Text("Camera"),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    image = file;
                  });
                },
                child: const Text("Gallery"),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        });
  }

  void uploadData(BuildContext context, String dropdownState) async {
  if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please fill all fields"),
      ),
    );
    return;
  }

  final vegetableData = {
    "name": _nameController.text,
    "price": _priceController.text,
    "image": imageUrl
  };

  final docRef = FirebaseFirestore.instance.collection("prices").doc(dropdownState);

  try {
    final docSnapshot = await docRef.get();
    
    if (docSnapshot.exists) {
      await docRef.update({
        "vegetables": FieldValue.arrayUnion([vegetableData])
      });
    } else {
      await docRef.set({
        "vegetables": [vegetableData]
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Data recorded successfully!")),
    );

    Navigator.pop(context);
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error saving data: $error")),
    );
  }
}
}