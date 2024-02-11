import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal/meal.dart';

class PersonAutocomplete extends StatefulWidget {
  TextEditingController personController;
  List<String> personOptions = <String>[];

  PersonAutocomplete({super.key, required this.personController});

  void newPersonOption() {
    for (var item in personOptions) {
      if (personController.text.toLowerCase().contains(item.toLowerCase())) {
        return;
      }
    }

    var auth = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance.collection('persons').doc(auth.uid).update({
      'persons': FieldValue.arrayUnion([personController.text.toLowerCase()])
    });

  }

  @override
  State<PersonAutocomplete> createState() => _PersonAutocompleteState();
}

class _PersonAutocompleteState extends State<PersonAutocomplete> {
  @override
  void initState() {
    super.initState();

    setPersonOptions().then((value) {setState(() {});});
  }

  Future<void> setPersonOptions() async {
    final auth = FirebaseAuth.instance.currentUser!;
    var db = FirebaseFirestore.instance;
    var _data;
    final docRef = await db.collection('persons').doc(auth.uid);
    await docRef.get().then( (DocumentSnapshot doc) {
      _data = doc.data();
    } );
    widget.personOptions = _data['persons'].cast<String>();
  }

  @override
  Widget build(BuildContext context) {
    return MealAutoComplete(
      controller: widget.personController,
      options: widget.personOptions,
      label: "Person",
      icon: Icons.people_rounded,
    );
  }
}
