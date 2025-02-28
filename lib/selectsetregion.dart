import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:krish_biz/setprices.dart';
import 'package:krish_biz/utils/appbar.dart';
import 'package:krish_biz/utils/common_utils.dart';
import 'package:krish_biz/utils/size.dart';

class SelectRegion extends StatefulWidget {
  const SelectRegion({super.key});

  @override
  _SelectRegionState createState() => _SelectRegionState();
}

class _SelectRegionState extends State<SelectRegion> {
  late Future<List<String>> _regionsFuture;

  @override
  void initState() {
    super.initState();
    _regionsFuture = fetchRegions();
  }

  Future<List<String>> fetchRegions() async {
    try {
      QuerySnapshot states =
          await FirebaseFirestore.instance.collection('prices').get();
      List<String> regions = states.docs.map((doc) => doc.id).toList();
      return regions;
    } catch (e) {
      CUtils.toastMessage("Error : $e");
      return [];
    }
  }

  Future<void> addRegion(String regionName) async {
    try{
    await FirebaseFirestore.instance
        .collection('prices')
        .doc(regionName)
        .set({});
    setState(() {
      _regionsFuture = fetchRegions();
    });
    CUtils.toastMessage("Added $regionName");
    }
    catch(e)
        {
       CUtils.toastMessage("Error $e");
    }

  }

  Future<void> editRegion(String oldName, String newName) async {
    try{
    DocumentSnapshot oldDoc = await FirebaseFirestore.instance
        .collection('prices')
        .doc(oldName)
        .get();
    Map<String, dynamic>? data = oldDoc.data() as Map<String, dynamic>?;

    if (data != null) {
      await FirebaseFirestore.instance
          .collection('prices')
          .doc(newName)
          .set(data);
      await FirebaseFirestore.instance
          .collection('prices')
          .doc(oldName)
          .delete();
    }

    setState(() {
      _regionsFuture = fetchRegions();
    });
    CUtils.toastMessage("Changed $oldName to $newName");
    }
    catch(e)
    {
       CUtils.toastMessage("Error $e");
    }
  }

  Future<void> deleteRegion(String regionName) async {
    try{
    await FirebaseFirestore.instance
        .collection('prices')
        .doc(regionName)
        .delete();
    setState(() {
      _regionsFuture = fetchRegions();
    });
    CUtils.toastMessage("Deleted $regionName");
    }
    catch(e)
    {
       CUtils.toastMessage("Error $e");
    }

  }

  Future<void> showEditDialog(String oldName) async {
    TextEditingController controller = TextEditingController(text: oldName);
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.green, width: 2)),
        title: const Text("Edit Region"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter new name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel", style: TextStyle(color: Colors.black),),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Save", style: TextStyle(color: Colors.green),),
          ),
        ],
      ),
    );

    if (confirmed == true && controller.text.isNotEmpty) {
      editRegion(oldName, controller.text);
    }
  }
    Future<void> showDeleteDialog(String name) async {
    TextEditingController controller = TextEditingController(text: name);
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.green, width: 2)),
        title: const Text("Delete Region"),
        content: Text(
            "Are you sure you want to delete $name ?"
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("No", style: TextStyle(color: Colors.black),),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Yes", style: TextStyle(color: Colors.green),),
          ),
        ],
      ),
    );

    if (confirmed == true && controller.text.isNotEmpty) {
      deleteRegion(name);
    }
  }


  Future<void> showAddDialog() async {
    TextEditingController controller = TextEditingController();
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.green, width: 2)),
        title: const Text("Add Region"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter region name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel", style: const TextStyle(color: Colors.black),),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Save", style: TextStyle(color: Colors.green),),
          ),
        ],
      ),
    );

    if (confirmed == true && controller.text.isNotEmpty) {
      addRegion(controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green[300],
        onPressed: showAddDialog,
        label: const Text('Add',style: TextStyle(fontWeight: FontWeight.w600),),
        icon: const Icon(Icons.add),
      ),
      appBar: CustomAppBar.showAppBar("Select Region",true,textScaleFactor),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/homepagebg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child : 
      FutureBuilder<List<String>>(
        future: _regionsFuture,
        builder: (context, states) {
          if (states.connectionState == ConnectionState.waiting) {
            return const Center(child:  CircularProgressIndicator(color: Colors.green,));
          } else if (states.hasError ||
              !states.hasData ||
              states.data!.isEmpty) {
            return const Center(child: Text("No data available"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: states.data!.length,
            itemBuilder: (context, index) {
              return Card(
                color: const Color.fromARGB(130, 195, 246, 173),
                margin:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                child: ListTile(
                  title: Text(
                    states.data![index],
                    style: TextStyle(
                        fontSize: 18 * textScaleFactor,
                        fontWeight: FontWeight.w500),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => showDeleteDialog(states.data![index]),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => showEditDialog(states.data![index]),
                      ),
                    ],
                  ),
                  onTap: (){
                     Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SetPrice(state: states.data![index]),
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
