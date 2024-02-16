import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal/meal.dart';

class NewGrocery extends StatefulWidget {
  const NewGrocery({super.key});

  @override
  State<NewGrocery> createState() => _NewGroceryState();
}

class _NewGroceryState extends State<NewGrocery> {
  TextEditingController nameController = TextEditingController();
  GroceryType groceryTypePicker = GroceryType();
  var is_edit = false;
  var set_input_data = false;
  Map? original_data;
  String title = "New Grocery";
  String create_title = "Create";
  List<String> groceriesOptions = <String>[];

  @override
  void initState() {
    super.initState();

    setGroceriesOptions().then((value) {setState(() {});});
  }

  Future<void> setGroceriesOptions() async {
    final auth = FirebaseAuth.instance.currentUser!;
    var db = FirebaseFirestore.instance;
    var _data;
    final docRef = await db.collection('groceries').doc(auth.uid);
    await docRef.get().then( (DocumentSnapshot doc) {
      _data = doc.data();
    } );
    groceriesOptions = _data['groceries'].cast<String>();
  }

  Future<bool> checkDuplicates(String name, int category) async {
    // get the data
    final auth = FirebaseAuth.instance.currentUser;
    var _data;
    List grocery_list = [];
    if (auth != null) {
      var db = FirebaseFirestore.instance;
      final docRef = await db.collection('grocery_list').doc(auth.uid);
      await docRef.get().then((DocumentSnapshot doc) {
        _data = doc.data() as Map<String, dynamic>;
      });
      if (_data != null) {
        grocery_list = _data['grocery_list'];
      }
    }

    // check the dupes
    for (var grocery in grocery_list){
      if (name == grocery['name'] && category == grocery["grocery_type"]) {return true;}
    }
    return false;
  }


  void createGrocery(Map? _data) async {

    // check for blank
    if (nameController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(MealSnackbar.configure(context, 'Item must be filled'));
      return;
    }

    // check for duplicates
    if (await checkDuplicates(nameController.text, type!.index) == true) {
      ScaffoldMessenger.of(context).showSnackBar(MealSnackbar.configure(context, 'Duplicate item found'));
      return;
    }

    // save data
    var auth = FirebaseAuth.instance.currentUser!;
    var data = _data;
    if (data == null) {
      data = {
        'name': nameController.text,
        'grocery_type': type!.index
      };
    }

    FirebaseFirestore.instance.collection('grocery_list').doc(auth.uid).update({
      'grocery_list': FieldValue.arrayUnion([data])
    });

    // add new item to grocery options list, if not there
    newGroceryOption();

    Navigator.of(context).pushReplacementNamed('/load_grocery');
  }

  void newGroceryOption() {
    for (var item in groceriesOptions) {
      if (nameController.text.toLowerCase().contains(item.toLowerCase())) {
        return;
      }
    }


    var auth = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance.collection('groceries').doc(auth.uid).update({
      'groceries': FieldValue.arrayUnion([nameController.text.toLowerCase()])
    });

  }

  void setInputData(Map? data) {
    if (set_input_data == false) {
      is_edit = true;
      original_data = data;
      if (data != null) {
        setState(() {
          nameController.text = data['name'];
          type = GroceryTypes.values[data['grocery_type']];
        });
      }
      set_input_data = true;
    }
    title = "Edit Grocery";
    create_title = "Save";
  }

  void onBackPressed(){
    if (is_edit) {
      createGrocery(original_data);
    } else {
      Navigator.pushReplacementNamed(context, "/load_grocery");
    }
  }

  @override
  Widget build(BuildContext context) {

    var data = ModalRoute.of(context)?.settings.arguments;
    if (data is Map){ setInputData(data); }

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        onBackPressed();
      },
      child: Scaffold(
        appBar: MealAppbar(
          label: title,
          darkMode: MealApp.of(context).darkMode!,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ListView(
              children: [
                MealAutoComplete(
                  options: groceriesOptions,
                  icon: Icons.shopping_bag_rounded,
                  label: "Item",
                  controller: nameController,
                ),
                SizedBox(height: 16),
                groceryTypePicker,
                SizedBox(height: 32),
                MealButton.primary(onPressed: () {createGrocery(null);}, label: create_title)
              ],
            )
          ),
        )
      ),
    );
  }
}

enum GroceryTypes { produce, dairy, frozen, bread, meat, other }

GroceryTypes? type = GroceryTypes.produce;

class GroceryType extends StatefulWidget {
  const GroceryType({super.key});

  @override
  State<GroceryType> createState() => _GroceryTypeState();
}

class _GroceryTypeState extends State<GroceryType> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MealSegmentedButton(
          initialPosition: 0,
          values: <MealSegmentedButtonValue>[
            MealSegmentedButtonValue(label: "Produce"),
            MealSegmentedButtonValue(label: "Dairy"),
            MealSegmentedButtonValue(label: "Frozen"),
            MealSegmentedButtonValue(label: "Bread/Pastry"),
            MealSegmentedButtonValue(label: "Meat/Poultry"),
            MealSegmentedButtonValue(label: "Other"),
          ],
          onSelected: (index) {
            setState(() {
              type = GroceryTypes.values[index];
            });
          }
        ),
      ],
    );
  }
}
