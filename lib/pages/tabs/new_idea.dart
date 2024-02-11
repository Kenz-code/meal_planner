import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal/meal.dart';
import 'package:meal_planner/widgets/features/person_autocomplete.dart';


class NewIdea extends StatefulWidget {
  const NewIdea({super.key});

  @override
  State<NewIdea> createState() => _NewMealState();
}

class _NewMealState extends State<NewIdea> {
  TextEditingController nameController = TextEditingController();
  TextEditingController personController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  late PersonAutocomplete personAutocomplete = PersonAutocomplete(personController: personController);
  var is_edit = false;
  var set_input_data = false;
  Map? original_data;
  String title = "New Idea";
  String create_title = "Create";

  Future<bool> checkDuplicates(String name) async {
    // get the data
    final auth = FirebaseAuth.instance.currentUser;
    var _data;
    List ideas = [];
    if (auth != null) {
      var db = FirebaseFirestore.instance;
      final docRef = await db.collection('ideas').doc(auth.uid);
      await docRef.get().then((DocumentSnapshot doc) {
        _data = doc.data() as Map<String, dynamic>;
      });
      if (_data != null) {
        setState(() {
          ideas = _data['ideas'];
        });
      }
    }

    // check the dupes
    for (var idea in ideas){
      if (name == idea['name']) {return true;}
    }
    return false;
  }

  void createMeal(Map? _data) async {
    // make sure nothing is blank
    if (nameController.text == "" || personController.text == "") {
      // show snack bar message
      ScaffoldMessenger.of(context).showSnackBar(MealSnackbar.configure(context, 'All fields must be filled'));
      return;
    }

    // check for duplicates
    if (await checkDuplicates(nameController.text) == true) {
      ScaffoldMessenger.of(context).showSnackBar(MealSnackbar.configure(context, 'Duplicate item found'));
      return;
    }

    var auth = FirebaseAuth.instance.currentUser;
    var data = _data;
    if (auth != null) {
      if (data == null) {
        data = {
          'name': nameController.text,
          'person': personController.text,
          'notes': notesController.text == "" ? null : notesController.text,
        };
      }


      FirebaseFirestore.instance.collection('ideas').doc(auth.uid).update({
        'ideas': FieldValue.arrayUnion([data])
      });
    }

    // options
    personAutocomplete.newPersonOption();

    Navigator.of(context).pushReplacementNamed('/load_ideas');
  }

  void setInputData(Map? data) {
    if (set_input_data == false) {
      is_edit = true;
      original_data = data;
      if (data != null) {
        setState(() {
          nameController.text = data['name'];
          personController.text = data['person'];
          if (data['notes'] != null) {notesController.text = data['notes'];}
        });
      }
      set_input_data = true;
    }
    title = "Edit Idea";
    create_title = "Save";
  }

  void onBackPressed(){
    if (is_edit) {
      createMeal(original_data);
    } else {
      Navigator.pushReplacementNamed(context, "/load_ideas");
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
                  MealTextField(
                    controller: nameController,
                    icon: Icons.lightbulb_rounded,
                    label: 'Meal idea',
                  ),
                  SizedBox(height: 16),
                  personAutocomplete,
                  SizedBox(height: 16),
                  MealTextField.multiline(
                    controller: notesController,
                    icon: Icons.note_rounded,
                    label: "Notes",
                    maxLines: 4,
                  ),
                  SizedBox(height: 32),
                  MealButton.primary(onPressed: () {createMeal(null);}, label: create_title)
                ],
              ),
            ),
          )
      ),
    );
  }
}