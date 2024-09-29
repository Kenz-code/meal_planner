import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal/meal.dart';
import 'package:meal_planner/widgets/features/person_autocomplete.dart';


class NewMeal extends StatefulWidget {
  const NewMeal({super.key});

  @override
  State<NewMeal> createState() => _NewMealState();
}

class _NewMealState extends State<NewMeal> {
  late TextEditingController nameController = TextEditingController();
  late TextEditingController dateController = TextEditingController();
  late TextEditingController personController = TextEditingController();
  late TextEditingController notesController = TextEditingController();
  late PersonAutocomplete personAutocomplete = PersonAutocomplete(personController: personController);
  MealType mealTypePicker = MealType();
  var is_edit = false;
  var set_input_data = false;
  Map? original_data;
  String title = "New Meal";
  String create_title = "Create";


  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateController.text == "" ? DateTime.now() : DateTime.parse(dateController.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            surface: neutral100,
            primary: primary600,
            onPrimary: neutral100,
            onSurface: neutral900
          )
        ),
        child: child!
      )
    );

    if (picked != null) {
      setState(() {
        dateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  Future<bool> checkDuplicates(DateTime date) async {
    // get the data
    final auth = FirebaseAuth.instance.currentUser;
    var _data;
    List meals = [];
    if (auth != null) {
      var db = FirebaseFirestore.instance;
      final docRef = await db.collection('meals').doc(auth.uid);
      await docRef.get().then((DocumentSnapshot doc) {
        _data = doc.data() as Map<String, dynamic>;
      });
      if (_data != null) {
        setState(() {
          meals = _data['meals'];
        });
      }
    }

    // check the dupes
    for (var meal in meals){
      if (date == meal["date"].toDate()) {return true;}
    }
    return false;
  }

  void createMeal(Map? _data) async {

    var dateAfterMealIndex = addMealTime(DateTime.parse(dateController.text));

    // make sure nothing is blank
    if (nameController.text == "" || personController.text == '' || dateController.text == '') {
      // show snack bar message
      ScaffoldMessenger.of(context).showSnackBar(MealSnackbar.configure(context, 'Name, person and date must be filled'));
      return;
    }

    // check for duplicates
    if (await checkDuplicates(dateAfterMealIndex) == true) {
      ScaffoldMessenger.of(context).showSnackBar(MealSnackbar.configure(context, 'Already a meal at this time'));
    return;
    }

    var auth = FirebaseAuth.instance.currentUser;
    var data = _data;
    if (auth != null) {
      if (data == null) {
        data = {
          'date': dateAfterMealIndex,
          'name': nameController.text,
          'person': personController.text,
          'meal_type': mealTypeView.index,
          'notes': notesController.text == "" ? null : notesController.text,
        };
      }


      FirebaseFirestore.instance.collection('meals').doc(auth.uid).update({
        'meals': FieldValue.arrayUnion([data])
      });
    }

    // options
    personAutocomplete.newPersonOption();

    Navigator.of(context).pushReplacementNamed('/load_meals');
  }

  DateTime addMealTime(DateTime time) {
    var dateAfterMealIndex = time;

    if (dateAfterMealIndex.hour != 0){
      dateAfterMealIndex = dateAfterMealIndex.subtract(Duration(hours: dateAfterMealIndex.hour));
    }

    switch (mealTypeView) {
      case MealTypes.breakfast:
        dateAfterMealIndex = dateAfterMealIndex.add(Duration(hours: 11));
      case MealTypes.lunch:
        dateAfterMealIndex = dateAfterMealIndex.add(Duration(hours: 14));
      case MealTypes.supper:
        dateAfterMealIndex = dateAfterMealIndex.add(Duration(hours: 21));
    }

    return dateAfterMealIndex;
  }

  void setInputData(Map? data) {
    if (set_input_data == false) {
      is_edit = true;
      original_data = data;
      if (data != null) {
        setState(() {
          nameController.text = data['name'];
          personController.text = data['person'];
          dateController.text = data['date'].toString().split(" ")[0];
          mealTypeView = MealTypes.values[data['meal_type']];
          if (data['notes'] != null) {notesController.text = data['notes'];}
        });
      }
      set_input_data = true;
    }
    title = "Edit Meal";
    create_title = "Save";
  }

  void onBackPressed(){
    if (is_edit) {
      createMeal(original_data);
    } else {
      Navigator.pushReplacementNamed(context, "/load_meals");
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
                  icon: Icons.fastfood_rounded,
                  label: "Meal name",
                ),
                SizedBox(height: 16),
                personAutocomplete,
                SizedBox(height: 16),
                MealTextField(
                  controller: dateController,
                  icon: Icons.calendar_month_rounded,
                  label: "Date",
                  readOnly: true,
                  onTap: selectDate,
                ),
                SizedBox(height: 16),
                MealTextField.multiline(
                  controller: notesController,
                  icon: Icons.note_rounded,
                  label: "Notes",
                  maxLines: 4,
                ),
                SizedBox(height: 16),
                mealTypePicker,
                SizedBox(height: 32),
                MealButton.primary(onPressed: () {createMeal(null);} , label: create_title)
              ],
            ),
          ),
        )
      ),
    );
  }
}

enum MealTypes { breakfast, lunch, supper }

MealTypes mealTypeView = MealTypes.supper;

class MealType extends StatefulWidget {
  const MealType({super.key});

  @override
  State<MealType> createState() => _MealTypeState();
}

class _MealTypeState extends State<MealType> {

  @override
  Widget build(BuildContext context) {
    return MealSegmentedButton(
      initialPosition: 2,
      values: <MealSegmentedButtonValue>[
        MealSegmentedButtonValue(label: "Breakfast"),
        MealSegmentedButtonValue(label: "Lunch"),
        MealSegmentedButtonValue(label: "Supper"),
      ],
      onSelected: (index) {
        setState(() {
          mealTypeView = MealTypes.values[index];
        });
      }
    );
  }
}
